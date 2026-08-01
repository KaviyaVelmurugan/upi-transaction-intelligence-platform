-- ============================================================
-- PHASE 7.4: DIMENSIONAL ANALYSIS
-- UPI Transaction Intelligence Platform
-- ============================================================


-- ============================================================
-- 7.4.1 TRANSACTION TYPE PERFORMANCE
-- ============================================================

WITH transaction_type_metrics AS (
    SELECT
        transaction_type,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY transaction_type
)

SELECT
    transaction_type,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM transaction_type_metrics

ORDER BY total_transactions DESC;
-- ============================================================
-- 7.4.2 MERCHANT CATEGORY PERFORMANCE
-- ============================================================

WITH merchant_category_metrics AS (
    SELECT
        merchant_category,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY merchant_category
)

SELECT
    merchant_category,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM merchant_category_metrics

ORDER BY total_transactions DESC;
-- ============================================================
-- 7.4.3 SENDER BANK PERFORMANCE
-- ============================================================

WITH sender_bank_metrics AS (
    SELECT
        sender_bank,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY sender_bank
)

SELECT
    sender_bank,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM sender_bank_metrics

ORDER BY total_transactions DESC;

-- ============================================================
-- 7.4.3 SENDER BANK PERFORMANCE
-- ============================================================

WITH sender_bank_metrics AS (
    SELECT
        sender_bank,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY sender_bank
)

SELECT
    sender_bank,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM sender_bank_metrics

ORDER BY total_transactions DESC;
-- ============================================================
-- 7.4.4 RECEIVER BANK PERFORMANCE
-- ============================================================

WITH receiver_bank_metrics AS (
    SELECT
        receiver_bank,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY receiver_bank
)

SELECT
    receiver_bank,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM receiver_bank_metrics

ORDER BY total_transactions DESC;
-- ============================================================
-- 7.4.5 SENDER STATE PERFORMANCE
-- ============================================================

WITH sender_state_metrics AS (
    SELECT
        sender_state,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY sender_state
)

SELECT
    sender_state,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM sender_state_metrics

ORDER BY total_transactions DESC;

-- ============================================================
-- 7.4.6 DEVICE TYPE PERFORMANCE
-- ============================================================

WITH device_type_metrics AS (
    SELECT
        device_type,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY device_type
)

SELECT
    device_type,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM device_type_metrics

ORDER BY total_transactions DESC;
-- ============================================================
-- 7.4.7 NETWORK TYPE PERFORMANCE
-- ============================================================

WITH network_type_metrics AS (
    SELECT
        network_type,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions,

        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) AS failed_transactions,

        COUNT(*) FILTER (
            WHERE fraud_flag = 1
        ) AS fraud_transactions,

        SUM(amount_inr) AS total_transaction_value,

        AVG(amount_inr) AS average_transaction_value

    FROM public.upi_transactions

    GROUP BY network_type
)

SELECT
    network_type,
    total_transactions,

    ROUND(
        100.0 * total_transactions
        / NULLIF(SUM(total_transactions) OVER (), 0),
        2
    ) AS transaction_share_percentage,

    successful_transactions,
    failed_transactions,

    ROUND(
        100.0 * successful_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS success_rate_percentage,

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
        2
    ) AS transaction_value_share_percentage,

    ROUND(average_transaction_value, 2)
        AS average_transaction_value,

    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions
        / NULLIF(total_transactions, 0),
        3
    ) AS fraud_rate_percentage

FROM network_type_metrics

ORDER BY total_transactions DESC;