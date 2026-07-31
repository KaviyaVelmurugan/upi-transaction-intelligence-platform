-- ============================================================
-- Project: UPI Transaction Intelligence Platform
-- Phase 7.1: Database and Table Setup
-- Database: upi_transaction_intelligence
-- ============================================================

CREATE TABLE IF NOT EXISTS upi_transactions (
    transaction_id VARCHAR(100) PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    transaction_type TEXT NOT NULL,
    merchant_category TEXT NOT NULL,
    amount_inr NUMERIC(12, 2) NOT NULL
        CHECK (amount_inr >= 0),
    transaction_status TEXT NOT NULL
        CHECK (transaction_status IN ('SUCCESS', 'FAILED')),
    sender_age_group TEXT NOT NULL,
    receiver_age_group TEXT NOT NULL,
    sender_state TEXT NOT NULL,
    sender_bank TEXT NOT NULL,
    receiver_bank TEXT NOT NULL,
    device_type TEXT NOT NULL,
    network_type TEXT NOT NULL,
    fraud_flag SMALLINT NOT NULL
        CHECK (fraud_flag IN (0, 1)),
    hour_of_day SMALLINT NOT NULL
        CHECK (hour_of_day BETWEEN 0 AND 23),
    day_of_week TEXT NOT NULL,
    is_weekend SMALLINT NOT NULL
        CHECK (is_weekend IN (0, 1))
);

-- ============================================================
-- Import processed UPI transaction data
-- The CSV was copied into the Docker container's /tmp directory
-- ============================================================

COPY public.upi_transactions (
    transaction_id,
    timestamp,
    transaction_type,
    merchant_category,
    amount_inr,
    transaction_status,
    sender_age_group,
    receiver_age_group,
    sender_state,
    sender_bank,
    receiver_bank,
    device_type,
    network_type,
    fraud_flag,
    hour_of_day,
    day_of_week,
    is_weekend
)
FROM '/tmp/upi_transactions_processed.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

-- ============================================================
-- Final database import validation
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(DISTINCT transaction_id)
        AS unique_transaction_ids,

    COUNT(*) - COUNT(DISTINCT transaction_id)
        AS duplicate_transaction_ids,

    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,

    ROUND(
        100.0 * (
            COUNT(*) FILTER (
                WHERE transaction_status = 'FAILED'
            )
        ) / NULLIF(COUNT(*), 0),
        3
    ) AS failure_rate_percentage,

    COUNT(*) FILTER (
        WHERE fraud_flag = 1
    ) AS fraudulent_transactions,

    ROUND(
        100.0 * (
            COUNT(*) FILTER (
                WHERE fraud_flag = 1
            )
        ) / NULLIF(COUNT(*), 0),
        3
    ) AS fraud_rate_percentage,

    SUM(amount_inr) AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value,

    MIN(timestamp) AS earliest_transaction,

    MAX(timestamp) AS latest_transaction

FROM public.upi_transactions;