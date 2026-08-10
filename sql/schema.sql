-- ============================================================================
-- UPI Transaction Operational Intelligence Platform
-- Dynamic pipeline: stable production schema and ingestion support objects
-- PostgreSQL 17
-- ============================================================================

BEGIN;

-- The production table intentionally keeps the same 17 business columns used
-- by the validated processed dataset and the completed Phase 7 SQL analysis.
CREATE TABLE IF NOT EXISTS public.upi_transactions (
    transaction_id VARCHAR(100) PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    transaction_type TEXT NOT NULL,
    merchant_category TEXT NOT NULL,
    amount_inr NUMERIC(12, 2) NOT NULL CHECK (amount_inr >= 0),
    transaction_status TEXT NOT NULL
        CHECK (transaction_status IN ('SUCCESS', 'FAILED')),
    sender_age_group TEXT NOT NULL,
    receiver_age_group TEXT NOT NULL,
    sender_state TEXT NOT NULL,
    sender_bank TEXT NOT NULL,
    receiver_bank TEXT NOT NULL,
    device_type TEXT NOT NULL,
    network_type TEXT NOT NULL,
    fraud_flag SMALLINT NOT NULL CHECK (fraud_flag IN (0, 1)),
    hour_of_day SMALLINT NOT NULL CHECK (hour_of_day BETWEEN 0 AND 23),
    day_of_week TEXT NOT NULL,
    is_weekend SMALLINT NOT NULL CHECK (is_weekend IN (0, 1))
);

-- Incoming files are copied here before being merged into the production table.
-- A staging row ID lets the merge keep the latest row when a batch repeats a
-- transaction ID.
CREATE TABLE IF NOT EXISTS public.upi_transactions_staging (
    staging_row_id BIGSERIAL PRIMARY KEY,
    transaction_id VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    transaction_type TEXT NOT NULL,
    merchant_category TEXT NOT NULL,
    amount_inr NUMERIC(12, 2) NOT NULL CHECK (amount_inr >= 0),
    transaction_status TEXT NOT NULL
        CHECK (transaction_status IN ('SUCCESS', 'FAILED')),
    sender_age_group TEXT NOT NULL,
    receiver_age_group TEXT NOT NULL,
    sender_state TEXT NOT NULL,
    sender_bank TEXT NOT NULL,
    receiver_bank TEXT NOT NULL,
    device_type TEXT NOT NULL,
    network_type TEXT NOT NULL,
    fraud_flag SMALLINT NOT NULL CHECK (fraud_flag IN (0, 1)),
    hour_of_day SMALLINT NOT NULL CHECK (hour_of_day BETWEEN 0 AND 23),
    day_of_week TEXT NOT NULL,
    is_weekend SMALLINT NOT NULL CHECK (is_weekend IN (0, 1)),
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Each successful merge is recorded separately from transaction data.
CREATE TABLE IF NOT EXISTS public.ingestion_batches (
    batch_id BIGSERIAL PRIMARY KEY,
    source_file TEXT NOT NULL,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    staged_rows BIGINT NOT NULL,
    distinct_transaction_ids BIGINT NOT NULL,
    duplicate_rows_in_batch BIGINT NOT NULL,
    inserted_rows BIGINT NOT NULL,
    updated_rows BIGINT NOT NULL,
    unchanged_rows BIGINT NOT NULL,
    target_rows_after BIGINT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('SUCCESS', 'FAILED'))
);

-- Indexes support the dimensions used by SQL analytics and Power BI filters.
CREATE INDEX IF NOT EXISTS idx_upi_transactions_timestamp
    ON public.upi_transactions (timestamp);

CREATE INDEX IF NOT EXISTS idx_upi_transactions_status
    ON public.upi_transactions (transaction_status);

CREATE INDEX IF NOT EXISTS idx_upi_transactions_sender_bank
    ON public.upi_transactions (sender_bank);

CREATE INDEX IF NOT EXISTS idx_upi_transactions_receiver_bank
    ON public.upi_transactions (receiver_bank);

CREATE INDEX IF NOT EXISTS idx_upi_transactions_merchant_category
    ON public.upi_transactions (merchant_category);

CREATE INDEX IF NOT EXISTS idx_upi_transactions_device_network
    ON public.upi_transactions (device_type, network_type);

COMMIT;
