-- ============================================================================
-- Operational Intelligence
-- Uses dynamic maximum dates and rolling baselines; no fixed 2024 filters.
-- ============================================================================

-- Daily health with week-over-week change and statistical spike flag.
SELECT *
FROM public.vw_daily_failure_alerts
ORDER BY transaction_date DESC;


-- Only dates currently flagged as unusual.
SELECT
    transaction_date,
    total_transactions,
    failed_transactions,
    failure_rate_percentage,
    rolling_failure_rate_average,
    upper_control_limit_percentage,
    weekly_failure_rate_change_pp
FROM public.vw_daily_failure_alerts
WHERE failure_spike_flag
ORDER BY transaction_date DESC;


-- Compare the latest seven observed calendar days with the preceding seven.
WITH data_boundary AS (
    SELECT MAX(timestamp)::DATE AS latest_date
    FROM public.upi_transactions
),
period_metrics AS (
    SELECT
        COUNT(*) FILTER (
            WHERE timestamp::DATE > latest_date - INTERVAL '7 days'
        ) AS current_period_transactions,
        COUNT(*) FILTER (
            WHERE timestamp::DATE > latest_date - INTERVAL '7 days'
              AND transaction_status = 'FAILED'
        ) AS current_period_failures,
        COUNT(*) FILTER (
            WHERE timestamp::DATE > latest_date - INTERVAL '14 days'
              AND timestamp::DATE <= latest_date - INTERVAL '7 days'
        ) AS previous_period_transactions,
        COUNT(*) FILTER (
            WHERE timestamp::DATE > latest_date - INTERVAL '14 days'
              AND timestamp::DATE <= latest_date - INTERVAL '7 days'
              AND transaction_status = 'FAILED'
        ) AS previous_period_failures
    FROM public.upi_transactions
    CROSS JOIN data_boundary
),
period_rates AS (
    SELECT
        *,
        100.0 * current_period_failures
            / NULLIF(current_period_transactions, 0)
            AS current_failure_rate,
        100.0 * previous_period_failures
            / NULLIF(previous_period_transactions, 0)
            AS previous_failure_rate
    FROM period_metrics
)
SELECT
    current_period_transactions,
    current_period_failures,
    ROUND(current_failure_rate, 2) AS current_failure_rate_percentage,
    previous_period_transactions,
    previous_period_failures,
    ROUND(previous_failure_rate, 2) AS previous_failure_rate_percentage,
    ROUND(
        current_failure_rate - previous_failure_rate,
        2
    ) AS failure_rate_change_pp,
    CASE
        WHEN current_failure_rate - previous_failure_rate >= 0.50
            THEN 'DEGRADING'
        WHEN current_failure_rate - previous_failure_rate <= -0.50
            THEN 'IMPROVING'
        ELSE 'STABLE'
    END AS trend_status
FROM period_rates;


-- Detect sender or receiver banks degrading over the latest 30 days.
WITH data_boundary AS (
    SELECT MAX(timestamp)::DATE AS latest_date
    FROM public.upi_transactions
),
bank_events AS (
    SELECT
        'SENDER'::TEXT AS bank_role,
        sender_bank AS bank_name,
        timestamp::DATE AS transaction_date,
        transaction_status
    FROM public.upi_transactions

    UNION ALL

    SELECT
        'RECEIVER'::TEXT,
        receiver_bank,
        timestamp::DATE,
        transaction_status
    FROM public.upi_transactions
),
bank_periods AS (
    SELECT
        bank_role,
        bank_name,
        COUNT(*) FILTER (
            WHERE transaction_date > latest_date - INTERVAL '30 days'
        ) AS current_transactions,
        COUNT(*) FILTER (
            WHERE transaction_date > latest_date - INTERVAL '30 days'
              AND transaction_status = 'FAILED'
        ) AS current_failures,
        COUNT(*) FILTER (
            WHERE transaction_date > latest_date - INTERVAL '60 days'
              AND transaction_date <= latest_date - INTERVAL '30 days'
        ) AS previous_transactions,
        COUNT(*) FILTER (
            WHERE transaction_date > latest_date - INTERVAL '60 days'
              AND transaction_date <= latest_date - INTERVAL '30 days'
              AND transaction_status = 'FAILED'
        ) AS previous_failures
    FROM bank_events
    CROSS JOIN data_boundary
    GROUP BY bank_role, bank_name
),
bank_rates AS (
    SELECT
        *,
        100.0 * current_failures / NULLIF(current_transactions, 0)
            AS current_failure_rate,
        100.0 * previous_failures / NULLIF(previous_transactions, 0)
            AS previous_failure_rate
    FROM bank_periods
)
SELECT
    bank_role,
    bank_name,
    current_transactions,
    current_failures,
    ROUND(current_failure_rate, 2) AS current_failure_rate_percentage,
    previous_transactions,
    previous_failures,
    ROUND(previous_failure_rate, 2) AS previous_failure_rate_percentage,
    ROUND(
        current_failure_rate - previous_failure_rate,
        2
    ) AS failure_rate_change_pp,
    CASE
        WHEN current_failure_rate - previous_failure_rate >= 0.50
            THEN 'DEGRADING'
        WHEN current_failure_rate - previous_failure_rate <= -0.50
            THEN 'IMPROVING'
        ELSE 'STABLE'
    END AS trend_status
FROM bank_rates
ORDER BY failure_rate_change_pp DESC, current_transactions DESC;


-- Flag bank/time/network combinations with sufficient volume and a failure
-- rate at least one percentage point above the platform baseline.
WITH bank_events AS (
    SELECT
        'SENDER'::TEXT AS bank_role,
        sender_bank AS bank_name,
        hour_of_day,
        network_type,
        transaction_status
    FROM public.upi_transactions

    UNION ALL

    SELECT
        'RECEIVER'::TEXT,
        receiver_bank,
        hour_of_day,
        network_type,
        transaction_status
    FROM public.upi_transactions
),
platform_baseline AS (
    SELECT
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
            / NULLIF(COUNT(*), 0) AS platform_failure_rate
    FROM public.upi_transactions
),
combination_metrics AS (
    SELECT
        bank_role,
        bank_name,
        hour_of_day,
        network_type,
        COUNT(*) AS total_transactions,
        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
            / NULLIF(COUNT(*), 0) AS combination_failure_rate
    FROM bank_events
    GROUP BY bank_role, bank_name, hour_of_day, network_type
    HAVING COUNT(*) >= 100
)
SELECT
    combination.bank_role,
    combination.bank_name,
    combination.hour_of_day,
    combination.network_type,
    combination.total_transactions,
    combination.failed_transactions,
    ROUND(combination.combination_failure_rate, 2)
        AS failure_rate_percentage,
    ROUND(
        combination.combination_failure_rate
        - baseline.platform_failure_rate,
        2
    ) AS failure_rate_above_platform_pp,
    CASE
        WHEN combination.combination_failure_rate
             >= baseline.platform_failure_rate + 1.0
        THEN 'ABNORMAL'
        ELSE 'NORMAL'
    END AS operational_status
FROM combination_metrics AS combination
CROSS JOIN platform_baseline AS baseline
ORDER BY failure_rate_above_platform_pp DESC, total_transactions DESC;
