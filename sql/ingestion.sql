-- ============================================================================
-- UPI Transaction Operational Intelligence Platform
-- Dynamic pipeline: idempotent staging-to-production upsert
-- Run schema.sql before this script.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.merge_upi_transactions_from_staging(
    p_source_file TEXT DEFAULT 'manual-load'
)
RETURNS TABLE (
    staged_rows BIGINT,
    distinct_transaction_ids BIGINT,
    duplicate_rows_in_batch BIGINT,
    inserted_rows BIGINT,
    updated_rows BIGINT,
    unchanged_rows BIGINT,
    target_rows_after BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_staged_rows BIGINT;
    v_distinct_ids BIGINT;
    v_duplicate_rows BIGINT;
    v_inserted_rows BIGINT;
    v_affected_rows BIGINT;
    v_updated_rows BIGINT;
    v_unchanged_rows BIGINT;
    v_target_rows BIGINT;
BEGIN
    SELECT
        COUNT(*),
        COUNT(DISTINCT transaction_id)
    INTO
        v_staged_rows,
        v_distinct_ids
    FROM public.upi_transactions_staging;

    v_duplicate_rows := v_staged_rows - v_distinct_ids;

    -- Count genuinely new transaction IDs before performing the upsert.
    WITH ranked_staging AS (
        SELECT
            s.*,
            ROW_NUMBER() OVER (
                PARTITION BY transaction_id
                ORDER BY timestamp DESC, staging_row_id DESC
            ) AS row_priority
        FROM public.upi_transactions_staging AS s
    ),
    deduplicated_staging AS (
        SELECT *
        FROM ranked_staging
        WHERE row_priority = 1
    )
    SELECT COUNT(*)
    INTO v_inserted_rows
    FROM deduplicated_staging AS s
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.upi_transactions AS t
        WHERE t.transaction_id = s.transaction_id
    );

    -- Keep one row per transaction ID, insert new transactions, and update only
    -- when an existing transaction has actually changed.
    WITH ranked_staging AS (
        SELECT
            s.*,
            ROW_NUMBER() OVER (
                PARTITION BY transaction_id
                ORDER BY timestamp DESC, staging_row_id DESC
            ) AS row_priority
        FROM public.upi_transactions_staging AS s
    ),
    deduplicated_staging AS (
        SELECT *
        FROM ranked_staging
        WHERE row_priority = 1
    )
    INSERT INTO public.upi_transactions AS target (
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
    SELECT
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
    FROM deduplicated_staging
    ON CONFLICT (transaction_id) DO UPDATE
    SET
        timestamp = EXCLUDED.timestamp,
        transaction_type = EXCLUDED.transaction_type,
        merchant_category = EXCLUDED.merchant_category,
        amount_inr = EXCLUDED.amount_inr,
        transaction_status = EXCLUDED.transaction_status,
        sender_age_group = EXCLUDED.sender_age_group,
        receiver_age_group = EXCLUDED.receiver_age_group,
        sender_state = EXCLUDED.sender_state,
        sender_bank = EXCLUDED.sender_bank,
        receiver_bank = EXCLUDED.receiver_bank,
        device_type = EXCLUDED.device_type,
        network_type = EXCLUDED.network_type,
        fraud_flag = EXCLUDED.fraud_flag,
        hour_of_day = EXCLUDED.hour_of_day,
        day_of_week = EXCLUDED.day_of_week,
        is_weekend = EXCLUDED.is_weekend
    WHERE (
        target.timestamp,
        target.transaction_type,
        target.merchant_category,
        target.amount_inr,
        target.transaction_status,
        target.sender_age_group,
        target.receiver_age_group,
        target.sender_state,
        target.sender_bank,
        target.receiver_bank,
        target.device_type,
        target.network_type,
        target.fraud_flag,
        target.hour_of_day,
        target.day_of_week,
        target.is_weekend
    ) IS DISTINCT FROM (
        EXCLUDED.timestamp,
        EXCLUDED.transaction_type,
        EXCLUDED.merchant_category,
        EXCLUDED.amount_inr,
        EXCLUDED.transaction_status,
        EXCLUDED.sender_age_group,
        EXCLUDED.receiver_age_group,
        EXCLUDED.sender_state,
        EXCLUDED.sender_bank,
        EXCLUDED.receiver_bank,
        EXCLUDED.device_type,
        EXCLUDED.network_type,
        EXCLUDED.fraud_flag,
        EXCLUDED.hour_of_day,
        EXCLUDED.day_of_week,
        EXCLUDED.is_weekend
    );

    GET DIAGNOSTICS v_affected_rows = ROW_COUNT;

    v_updated_rows := v_affected_rows - v_inserted_rows;
    v_unchanged_rows := v_distinct_ids - v_inserted_rows - v_updated_rows;

    SELECT COUNT(*)
    INTO v_target_rows
    FROM public.upi_transactions;

    INSERT INTO public.ingestion_batches (
        source_file,
        staged_rows,
        distinct_transaction_ids,
        duplicate_rows_in_batch,
        inserted_rows,
        updated_rows,
        unchanged_rows,
        target_rows_after,
        status
    )
    VALUES (
        p_source_file,
        v_staged_rows,
        v_distinct_ids,
        v_duplicate_rows,
        v_inserted_rows,
        v_updated_rows,
        v_unchanged_rows,
        v_target_rows,
        'SUCCESS'
    );

    ANALYZE public.upi_transactions;

    RETURN QUERY
    SELECT
        v_staged_rows,
        v_distinct_ids,
        v_duplicate_rows,
        v_inserted_rows,
        v_updated_rows,
        v_unchanged_rows,
        v_target_rows;
END;
$$;

-- Most recent ingestion runs for operational verification.
CREATE OR REPLACE VIEW public.vw_ingestion_history AS
SELECT
    batch_id,
    source_file,
    processed_at,
    staged_rows,
    distinct_transaction_ids,
    duplicate_rows_in_batch,
    inserted_rows,
    updated_rows,
    unchanged_rows,
    target_rows_after,
    status
FROM public.ingestion_batches
ORDER BY processed_at DESC;
