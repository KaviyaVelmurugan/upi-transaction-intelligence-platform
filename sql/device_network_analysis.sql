-- ============================================================================
-- Device and Network Intelligence
-- ============================================================================

-- Combined Power-BI-ready result for device and network slicers.
SELECT *
FROM public.vw_device_network_performance
ORDER BY dimension_type, total_transactions DESC;


-- Rank each dimension and compare failure rate with its peer average.
WITH scored_channels AS (
    SELECT
        channel.*,
        AVG(failure_rate_percentage) OVER (
            PARTITION BY dimension_type
        ) AS dimension_average_failure_rate
    FROM public.vw_device_network_performance AS channel
)
SELECT
    dimension_type,
    dimension_value,
    total_transactions,
    failed_transactions,
    failure_rate_percentage,
    total_transaction_value,
    average_transaction_value,
    fraud_rate_percentage,
    DENSE_RANK() OVER (
        PARTITION BY dimension_type
        ORDER BY success_rate_percentage DESC, total_transactions DESC
    ) AS operational_performance_rank,
    ROUND(
        failure_rate_percentage - dimension_average_failure_rate,
        2
    ) AS failure_rate_vs_dimension_average_pp
FROM scored_channels
ORDER BY dimension_type, operational_performance_rank;
