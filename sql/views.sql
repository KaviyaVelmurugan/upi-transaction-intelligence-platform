-- ============================================================================
-- UPI Transaction Operational Intelligence Platform
-- Reusable, Power-BI-ready PostgreSQL views
-- Views query current production data whenever they are selected.
-- ============================================================================

CREATE OR REPLACE VIEW public.vw_transaction_overview AS
SELECT
    MAX(timestamp) AS data_current_through,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'SUCCESS')
        / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value,
    COUNT(*) FILTER (WHERE fraud_flag = 1) AS fraud_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE fraud_flag = 1)
        / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage
FROM public.upi_transactions;


CREATE OR REPLACE VIEW public.vw_bank_performance AS
WITH bank_activity AS (
    SELECT
        'SENDER'::TEXT AS bank_role,
        sender_bank AS bank_name,
        transaction_status,
        amount_inr,
        fraud_flag
    FROM public.upi_transactions

    UNION ALL

    SELECT
        'RECEIVER'::TEXT,
        receiver_bank,
        transaction_status,
        amount_inr,
        fraud_flag
    FROM public.upi_transactions
)
SELECT
    bank_role,
    bank_name,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'SUCCESS')
        / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value,
    COUNT(*) FILTER (WHERE fraud_flag = 1) AS fraud_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE fraud_flag = 1)
        / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage
FROM bank_activity
GROUP BY bank_role, bank_name;


CREATE OR REPLACE VIEW public.vw_daily_transaction_health AS
SELECT
    timestamp::DATE AS transaction_date,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'SUCCESS')
        / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value,
    COUNT(*) FILTER (WHERE fraud_flag = 1) AS fraud_transactions
FROM public.upi_transactions
GROUP BY timestamp::DATE;


CREATE OR REPLACE VIEW public.vw_hourly_failure_analysis AS
SELECT
    hour_of_day,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value
FROM public.upi_transactions
GROUP BY hour_of_day;


CREATE OR REPLACE VIEW public.vw_merchant_performance AS
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'SUCCESS')
        / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value,
    COUNT(*) FILTER (WHERE fraud_flag = 1) AS fraud_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE fraud_flag = 1)
        / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage
FROM public.upi_transactions
GROUP BY merchant_category;


CREATE OR REPLACE VIEW public.vw_device_network_performance AS
WITH channel_activity AS (
    SELECT
        'DEVICE'::TEXT AS dimension_type,
        device_type AS dimension_value,
        transaction_status,
        amount_inr,
        fraud_flag
    FROM public.upi_transactions

    UNION ALL

    SELECT
        'NETWORK'::TEXT,
        network_type,
        transaction_status,
        amount_inr,
        fraud_flag
    FROM public.upi_transactions
)
SELECT
    dimension_type,
    dimension_value,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'SUCCESS')
        / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value,
    COUNT(*) FILTER (WHERE fraud_flag = 1) AS fraud_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE fraud_flag = 1)
        / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage
FROM channel_activity
GROUP BY dimension_type, dimension_value;


-- Rolling daily health view. The 28 preceding observed days form the baseline;
-- the current day is excluded so it cannot influence its own alert threshold.
CREATE OR REPLACE VIEW public.vw_daily_failure_alerts AS
WITH rolling_baseline AS (
    SELECT
        daily.*,
        COUNT(*) OVER (
            ORDER BY transaction_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS baseline_day_count,
        AVG(failure_rate_percentage) OVER (
            ORDER BY transaction_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS rolling_failure_rate_average,
        STDDEV_SAMP(failure_rate_percentage) OVER (
            ORDER BY transaction_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS rolling_failure_rate_stddev,
        LAG(failure_rate_percentage, 7) OVER (
            ORDER BY transaction_date
        ) AS failure_rate_seven_days_ago
    FROM public.vw_daily_transaction_health AS daily
)
SELECT
    transaction_date,
    total_transactions,
    successful_transactions,
    failed_transactions,
    success_rate_percentage,
    failure_rate_percentage,
    total_transaction_value,
    average_transaction_value,
    fraud_transactions,
    ROUND(rolling_failure_rate_average, 3)
        AS rolling_failure_rate_average,
    ROUND(rolling_failure_rate_stddev, 3)
        AS rolling_failure_rate_stddev,
    ROUND(
        rolling_failure_rate_average
        + 3 * COALESCE(rolling_failure_rate_stddev, 0),
        3
    ) AS upper_control_limit_percentage,
    ROUND(
        failure_rate_percentage - failure_rate_seven_days_ago,
        2
    ) AS weekly_failure_rate_change_pp,
    CASE
        WHEN baseline_day_count >= 14
         AND failure_rate_percentage > (
             rolling_failure_rate_average
             + 3 * COALESCE(rolling_failure_rate_stddev, 0)
         )
        THEN TRUE
        ELSE FALSE
    END AS failure_spike_flag
FROM rolling_baseline;
