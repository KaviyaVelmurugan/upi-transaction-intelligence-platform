-- ============================================================
-- PHASE 7.3: CORE BUSINESS KPIs
-- UPI Transaction Intelligence Platform
-- ============================================================
-- ============================================================
-- 7.3.1 EXECUTIVE TRANSACTION KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS success_rate_percentage,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,

    ROUND(SUM(amount_inr), 2) AS total_transaction_value,

    ROUND(AVG(amount_inr), 2) AS average_transaction_value,

    COUNT(*) FILTER (
        WHERE fraud_flag = 1
    ) AS fraud_transactions,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage

FROM public.upi_transactions;
-- ============================================================
-- 7.3.2 TRANSACTION VALUE KPIs
-- ============================================================

SELECT
    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value,

    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY amount_inr)::NUMERIC,
        2
    ) AS median_transaction_value,

    ROUND(
        MODE()
        WITHIN GROUP (ORDER BY amount_inr),
        2
    ) AS most_frequent_transaction_value,

    ROUND(MIN(amount_inr), 2)
        AS minimum_transaction_value,

    ROUND(MAX(amount_inr), 2)
        AS maximum_transaction_value,

    ROUND(STDDEV_SAMP(amount_inr), 2)
        AS standard_deviation,

    ROUND(
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY amount_inr)::NUMERIC,
        2
    ) AS q1_transaction_value,

    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY amount_inr)::NUMERIC,
        2
    ) AS q3_transaction_value,

    ROUND(
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY amount_inr)::NUMERIC,
        2
    ) AS percentile_95_value

FROM public.upi_transactions;
-- ============================================================
-- 7.3.3 TRANSACTION STATUS AND VALUE EXPOSURE
-- ============================================================

WITH status_value_summary AS (
    SELECT
        transaction_status,
        COUNT(*) AS transaction_count,
        SUM(amount_inr) AS total_transaction_value,
        AVG(amount_inr) AS average_transaction_value
    FROM public.upi_transactions
    GROUP BY transaction_status
)

SELECT
    transaction_status,
    transaction_count,

    ROUND(
        100.0 * transaction_count
        / NULLIF(SUM(transaction_count) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    ROUND(total_transaction_value, 2)
        AS total_transaction_value,

    ROUND(
        100.0 * total_transaction_value
        / NULLIF(SUM(total_transaction_value) OVER (), 0),
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value

FROM status_value_summary

ORDER BY
    CASE
        WHEN transaction_status = 'SUCCESS' THEN 1
        WHEN transaction_status = 'FAILED' THEN 2
    END;
-- ============================================================
-- 7.3.4 FRAUD EXPOSURE KPIs
-- ============================================================

WITH fraud_summary AS (
    SELECT
        fraud_flag,

        CASE
            WHEN fraud_flag = 1 THEN 'Fraud'
            ELSE 'Normal'
        END AS fraud_category,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY fraud_flag
)

SELECT
    fraud_flag,
    fraud_category,
    total_transactions,
    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        3
    ) AS transaction_share_percentage,

    ROUND(
        100.0 * failed_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS failure_rate_percentage,

    ROUND(total_transaction_value, 2)
        AS total_transaction_value,

    ROUND(
        100.0 * total_transaction_value
        / NULLIF(SUM(total_transaction_value) OVER (), 0),
        3
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value

FROM fraud_summary

ORDER BY fraud_flag;

-- ============================================================
-- 7.3.5 BUSINESS TARGET GAP ANALYSIS
-- ============================================================

WITH current_kpis AS (
    SELECT
        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions

    FROM public.upi_transactions
),

business_targets AS (
    SELECT
        98.50::NUMERIC AS target_success_rate_percentage,
        1.50::NUMERIC AS maximum_failure_rate_percentage
),

target_calculation AS (
    SELECT
        current_kpis.*,

        ROUND(
            100.0 * successful_transactions
            / NULLIF(total_transactions, 0),
            2
        ) AS actual_success_rate_percentage,

        ROUND(
            100.0 * failed_transactions
            / NULLIF(total_transactions, 0),
            2
        ) AS actual_failure_rate_percentage,

        target_success_rate_percentage,
        maximum_failure_rate_percentage,

        CEIL(
            target_success_rate_percentage
            / 100.0 * total_transactions
        )::BIGINT AS target_successful_transactions,

        FLOOR(
            maximum_failure_rate_percentage
            / 100.0 * total_transactions
        )::BIGINT AS maximum_failed_transactions

    FROM current_kpis
    CROSS JOIN business_targets
)

SELECT
    total_transactions,

    actual_success_rate_percentage,
    target_success_rate_percentage,

    ROUND(
        target_success_rate_percentage
        - actual_success_rate_percentage,
        2
    ) AS success_rate_gap_percentage_points,

    successful_transactions,
    target_successful_transactions,

    GREATEST(
        target_successful_transactions
        - successful_transactions,
        0
    ) AS additional_successes_required,

    actual_failure_rate_percentage,
    maximum_failure_rate_percentage,

    ROUND(
        actual_failure_rate_percentage
        - maximum_failure_rate_percentage,
        2
    ) AS failure_rate_gap_percentage_points,

    failed_transactions,
    maximum_failed_transactions,

    GREATEST(
        failed_transactions
        - maximum_failed_transactions,
        0
    ) AS failures_to_prevent,

    ROUND(
        100.0
        * GREATEST(
            failed_transactions - maximum_failed_transactions,
            0
        )
        / NULLIF(failed_transactions, 0),
        2
    ) AS required_failure_reduction_percentage,

    CASE
        WHEN actual_success_rate_percentage
             >= target_success_rate_percentage
        THEN 'TARGET ACHIEVED'
        ELSE 'BELOW TARGET'
    END AS success_target_status

FROM target_calculation;