-- ============================================================================
-- Merchant Intelligence
-- ============================================================================

-- Merchant category volume, value, and reliability.
SELECT *
FROM public.vw_merchant_performance
ORDER BY total_transactions DESC;


-- Risk-screen merchant categories relative to the category distribution.
WITH scored_categories AS (
    SELECT
        merchant.*,
        AVG(failure_rate_percentage) OVER ()
            AS category_average_failure_rate,
        STDDEV_SAMP(failure_rate_percentage) OVER ()
            AS category_failure_rate_stddev
    FROM public.vw_merchant_performance AS merchant
)
SELECT
    merchant_category,
    total_transactions,
    failed_transactions,
    failure_rate_percentage,
    total_transaction_value,
    average_transaction_value,
    fraud_rate_percentage,
    ROUND(
        failure_rate_percentage - category_average_failure_rate,
        2
    ) AS failure_rate_vs_category_average_pp,
    CASE
        WHEN failure_rate_percentage > (
            category_average_failure_rate
            + COALESCE(category_failure_rate_stddev, 0)
        )
        THEN 'INVESTIGATE'
        ELSE 'NORMAL'
    END AS operational_status
FROM scored_categories
ORDER BY failure_rate_percentage DESC, total_transactions DESC;
