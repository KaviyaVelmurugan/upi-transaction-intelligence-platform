-- ============================================================================
-- Time Intelligence
-- ============================================================================

-- Daily transaction and failure trend.
SELECT *
FROM public.vw_daily_transaction_health
ORDER BY transaction_date;


-- Monthly transaction trend. New months appear automatically after ingestion.
SELECT
    DATE_TRUNC('month', timestamp)::DATE AS transaction_month,
    COUNT(*) AS total_transactions,
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
GROUP BY DATE_TRUNC('month', timestamp)::DATE
ORDER BY transaction_month;


-- Hourly volume and failure rate.
SELECT *
FROM public.vw_hourly_failure_analysis
ORDER BY hour_of_day;


-- Day-of-week behavior in calendar order.
SELECT
    EXTRACT(ISODOW FROM timestamp)::INTEGER AS weekday_number,
    TO_CHAR(timestamp, 'FMDay') AS weekday_name,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value
FROM public.upi_transactions
GROUP BY
    EXTRACT(ISODOW FROM timestamp)::INTEGER,
    TO_CHAR(timestamp, 'FMDay')
ORDER BY weekday_number;


-- Weekend versus weekday behavior.
SELECT
    CASE
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE transaction_status = 'FAILED')
        / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value
FROM public.upi_transactions
GROUP BY day_type
ORDER BY day_type;


-- Highest-volume periods.
SELECT
    hour_of_day,
    total_transactions,
    failed_transactions,
    failure_rate_percentage
FROM public.vw_hourly_failure_analysis
ORDER BY total_transactions DESC
LIMIT 5;


-- Highest-failure-rate periods with their supporting volume.
SELECT
    hour_of_day,
    total_transactions,
    failed_transactions,
    failure_rate_percentage
FROM public.vw_hourly_failure_analysis
ORDER BY failure_rate_percentage DESC, total_transactions DESC
LIMIT 5;
