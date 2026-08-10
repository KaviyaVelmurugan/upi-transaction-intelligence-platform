-- ============================================================================
-- Bank Performance Intelligence
-- Sender and receiver roles remain separate because their performance differs.
-- ============================================================================

-- Bank volume, value, reliability, and performance rank.
WITH scored_banks AS (
    SELECT
        bank.*,
        AVG(failure_rate_percentage) OVER (
            PARTITION BY bank_role
        ) AS role_average_failure_rate,
        STDDEV_SAMP(failure_rate_percentage) OVER (
            PARTITION BY bank_role
        ) AS role_failure_rate_stddev
    FROM public.vw_bank_performance AS bank
)
SELECT
    bank_role,
    bank_name,
    total_transactions,
    successful_transactions,
    failed_transactions,
    success_rate_percentage,
    failure_rate_percentage,
    total_transaction_value,
    average_transaction_value,
    fraud_transactions,
    fraud_rate_percentage,
    DENSE_RANK() OVER (
        PARTITION BY bank_role
        ORDER BY success_rate_percentage DESC, total_transactions DESC
    ) AS operational_performance_rank,
    ROUND(
        failure_rate_percentage - role_average_failure_rate,
        2
    ) AS failure_rate_vs_role_average_pp,
    CASE
        WHEN failure_rate_percentage > (
            role_average_failure_rate
            + COALESCE(role_failure_rate_stddev, 0)
        )
        THEN 'INVESTIGATE'
        ELSE 'NORMAL'
    END AS operational_status
FROM scored_banks
ORDER BY bank_role, operational_performance_rank;


-- Highest absolute failure workload by role.
SELECT
    bank_role,
    bank_name,
    total_transactions,
    failed_transactions,
    failure_rate_percentage
FROM public.vw_bank_performance
ORDER BY bank_role, failed_transactions DESC;
