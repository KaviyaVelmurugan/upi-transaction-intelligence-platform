-- 1. Stores anomaly scores produced by the Isolation Forest model
CREATE TABLE IF NOT EXISTS public.transaction_anomaly_scores (
    transaction_id TEXT PRIMARY KEY,
    anomaly_score DOUBLE PRECISION NOT NULL,
    anomaly_risk_band TEXT NOT NULL,
    is_anomaly SMALLINT NOT NULL,
    model_version TEXT NOT NULL,
    scored_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_anomaly_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES public.upi_transactions (transaction_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_anomaly_risk_band
        CHECK (
            anomaly_risk_band IN (
                'Normal',
                'Monitor',
                'High Anomaly'
            )
        ),

    CONSTRAINT chk_is_anomaly
        CHECK (is_anomaly IN (0, 1))
);

-- 2. Summarizes Normal, Monitor and High Anomaly transactions
CREATE OR REPLACE VIEW public.vw_anomaly_risk_summary AS
SELECT
    scores.anomaly_risk_band,

    COUNT(*) AS total_transactions,

    ROUND(
        (
            100.0 * COUNT(*)
            / SUM(COUNT(*)) OVER ()
        )::NUMERIC,
        2
    ) AS transaction_share_percentage,

    ROUND(
        AVG(scores.anomaly_score)::NUMERIC,
        4
    ) AS average_anomaly_score,

    ROUND(
        MAX(scores.anomaly_score)::NUMERIC,
        4
    ) AS maximum_anomaly_score,

    ROUND(
        AVG(transactions.amount_inr)::NUMERIC,
        2
    ) AS average_transaction_amount,

    COUNT(*) FILTER (
        WHERE transactions.transaction_status = 'FAILED'
    ) AS failed_transactions,

    ROUND(
        (
            100.0
            * COUNT(*) FILTER (
                WHERE transactions.transaction_status = 'FAILED'
            )
            / COUNT(*)
        )::NUMERIC,
        3
    ) AS failure_rate_percentage,

    SUM(transactions.fraud_flag) AS fraud_transactions,

    ROUND(
        (
            100.0 * SUM(transactions.fraud_flag)
            / COUNT(*)
        )::NUMERIC,
        3
    ) AS fraud_rate_percentage

FROM public.transaction_anomaly_scores scores

INNER JOIN public.upi_transactions transactions
    ON transactions.transaction_id =
       scores.transaction_id

GROUP BY
    scores.anomaly_risk_band;
CREATE OR REPLACE VIEW public.vw_high_anomaly_review_queue AS
SELECT
    transactions.transaction_id,
    transactions.timestamp,
    transactions.transaction_type,
    transactions.merchant_category,
    transactions.amount_inr,
    transactions.sender_age_group,
    transactions.receiver_age_group,
    transactions.sender_state,
    transactions.sender_bank,
    transactions.receiver_bank,
    transactions.device_type,
    transactions.network_type,
    transactions.hour_of_day,
    transactions.is_weekend,
    transactions.transaction_status,
    transactions.fraud_flag,
    scores.anomaly_score,
    scores.anomaly_risk_band,
    scores.model_version,
    scores.scored_at

FROM public.transaction_anomaly_scores scores

INNER JOIN public.upi_transactions transactions
    ON transactions.transaction_id =
       scores.transaction_id

WHERE scores.anomaly_risk_band = 'High Anomaly';

-- 3. Provides High Anomaly transactions for investigation
CREATE OR REPLACE VIEW public.vw_high_anomaly_review_queue AS
SELECT
    transactions.transaction_id,
    transactions.timestamp,
    transactions.transaction_type,
    transactions.merchant_category,
    transactions.amount_inr,
    transactions.sender_age_group,
    transactions.receiver_age_group,
    transactions.sender_state,
    transactions.sender_bank,
    transactions.receiver_bank,
    transactions.device_type,
    transactions.network_type,
    transactions.hour_of_day,
    transactions.is_weekend,
    transactions.transaction_status,
    transactions.fraud_flag,
    scores.anomaly_score,
    scores.anomaly_risk_band,
    scores.model_version,
    scores.scored_at
FROM public.transaction_anomaly_scores AS scores
INNER JOIN public.upi_transactions AS transactions
    ON transactions.transaction_id = scores.transaction_id
WHERE scores.anomaly_risk_band = 'High Anomaly';

-- Verification: expected result is 2,500
SELECT COUNT(*) AS high_anomaly_review_records
FROM public.vw_high_anomaly_review_queue;