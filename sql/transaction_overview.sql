-- ============================================================================
-- Transaction Overview
-- Uses reusable views so results update whenever production data changes.
-- ============================================================================

-- Executive KPI cards for Power BI.
SELECT *
FROM public.vw_transaction_overview;


-- Transaction status volume and monetary exposure.
SELECT
    transaction_status,
    COUNT(*) AS total_transactions,
    ROUND(
        100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS transaction_share_percentage,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(
        100.0 * SUM(amount_inr) / NULLIF(SUM(SUM(amount_inr)) OVER (), 0),
        2
    ) AS transaction_value_share_percentage,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value
FROM public.upi_transactions
GROUP BY transaction_status
ORDER BY total_transactions DESC;


-- Transaction-type operating mix.
SELECT
    transaction_type,
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
GROUP BY transaction_type
ORDER BY total_transactions DESC;
