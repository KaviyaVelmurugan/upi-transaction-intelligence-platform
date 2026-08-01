-- ============================================================
-- Project: UPI Transaction Intelligence Platform
-- Phase 7.2: SQL Data Quality Validation
-- Database: upi_transaction_intelligence
-- Table: public.upi_transactions
-- ============================================================
-- ============================================================
-- 7.2.1 Missing-value validation
-- Business question:
-- Are any mandatory transaction fields missing?
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE transaction_id IS NULL
    ) AS transaction_id_nulls,

    COUNT(*) FILTER (
        WHERE timestamp IS NULL
    ) AS timestamp_nulls,

    COUNT(*) FILTER (
        WHERE transaction_type IS NULL
    ) AS transaction_type_nulls,

    COUNT(*) FILTER (
        WHERE merchant_category IS NULL
    ) AS merchant_category_nulls,

    COUNT(*) FILTER (
        WHERE amount_inr IS NULL
    ) AS amount_nulls,

    COUNT(*) FILTER (
        WHERE transaction_status IS NULL
    ) AS transaction_status_nulls,

    COUNT(*) FILTER (
        WHERE sender_age_group IS NULL
    ) AS sender_age_group_nulls,

    COUNT(*) FILTER (
        WHERE receiver_age_group IS NULL
    ) AS receiver_age_group_nulls,

    COUNT(*) FILTER (
        WHERE sender_state IS NULL
    ) AS sender_state_nulls,

    COUNT(*) FILTER (
        WHERE sender_bank IS NULL
    ) AS sender_bank_nulls,

    COUNT(*) FILTER (
        WHERE receiver_bank IS NULL
    ) AS receiver_bank_nulls,

    COUNT(*) FILTER (
        WHERE device_type IS NULL
    ) AS device_type_nulls,

    COUNT(*) FILTER (
        WHERE network_type IS NULL
    ) AS network_type_nulls,

    COUNT(*) FILTER (
        WHERE fraud_flag IS NULL
    ) AS fraud_flag_nulls,

    COUNT(*) FILTER (
        WHERE hour_of_day IS NULL
    ) AS hour_of_day_nulls,

    COUNT(*) FILTER (
        WHERE day_of_week IS NULL
    ) AS day_of_week_nulls,

    COUNT(*) FILTER (
        WHERE is_weekend IS NULL
    ) AS is_weekend_nulls

FROM public.upi_transactions;

-- ============================================================
-- 7.2.2 Duplicate transaction validation
-- Business question:
-- Are any transaction IDs repeated in the database?
-- ============================================================

WITH duplicate_transactions AS (
    SELECT
        transaction_id,
        COUNT(*) AS occurrence_count
    FROM public.upi_transactions
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)

SELECT
    COUNT(*) AS duplicate_transaction_ids,

    COALESCE(
        SUM(occurrence_count - 1),
        0
    ) AS additional_duplicate_records

FROM duplicate_transactions;

-- ============================================================
-- 7.2.3 Categorical-value profile
-- Business question:
-- Do the categorical columns contain the expected values?
-- ============================================================

WITH category_profile AS (

    SELECT
        1 AS display_order,
        'transaction_type' AS column_name,
        COUNT(DISTINCT transaction_type) AS distinct_count,
        STRING_AGG(
            DISTINCT transaction_type,
            ', ' ORDER BY transaction_type
        ) AS observed_values
    FROM public.upi_transactions

    UNION ALL

    SELECT
        2,
        'merchant_category',
        COUNT(DISTINCT merchant_category),
        STRING_AGG(
            DISTINCT merchant_category,
            ', ' ORDER BY merchant_category
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        3,
        'transaction_status',
        COUNT(DISTINCT transaction_status),
        STRING_AGG(
            DISTINCT transaction_status,
            ', ' ORDER BY transaction_status
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        4,
        'sender_age_group',
        COUNT(DISTINCT sender_age_group),
        STRING_AGG(
            DISTINCT sender_age_group,
            ', ' ORDER BY sender_age_group
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        5,
        'receiver_age_group',
        COUNT(DISTINCT receiver_age_group),
        STRING_AGG(
            DISTINCT receiver_age_group,
            ', ' ORDER BY receiver_age_group
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        6,
        'sender_state',
        COUNT(DISTINCT sender_state),
        STRING_AGG(
            DISTINCT sender_state,
            ', ' ORDER BY sender_state
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        7,
        'sender_bank',
        COUNT(DISTINCT sender_bank),
        STRING_AGG(
            DISTINCT sender_bank,
            ', ' ORDER BY sender_bank
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        8,
        'receiver_bank',
        COUNT(DISTINCT receiver_bank),
        STRING_AGG(
            DISTINCT receiver_bank,
            ', ' ORDER BY receiver_bank
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        9,
        'device_type',
        COUNT(DISTINCT device_type),
        STRING_AGG(
            DISTINCT device_type,
            ', ' ORDER BY device_type
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        10,
        'network_type',
        COUNT(DISTINCT network_type),
        STRING_AGG(
            DISTINCT network_type,
            ', ' ORDER BY network_type
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        11,
        'day_of_week',
        COUNT(DISTINCT day_of_week),
        STRING_AGG(
            DISTINCT day_of_week,
            ', ' ORDER BY day_of_week
        )
    FROM public.upi_transactions
)

SELECT
    column_name,
    distinct_count,
    observed_values
FROM category_profile
ORDER BY display_order;

-- ============================================================
-- 7.2.4 Blank-text validation
-- Business question:
-- Do any categorical fields contain empty or whitespace values?
-- ============================================================

WITH blank_value_checks AS (

    SELECT
        1 AS display_order,
        'transaction_type' AS column_name,
        COUNT(*) FILTER (
            WHERE BTRIM(transaction_type) = ''
        ) AS blank_record_count
    FROM public.upi_transactions

    UNION ALL

    SELECT
        2,
        'merchant_category',
        COUNT(*) FILTER (
            WHERE BTRIM(merchant_category) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        3,
        'transaction_status',
        COUNT(*) FILTER (
            WHERE BTRIM(transaction_status) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        4,
        'sender_age_group',
        COUNT(*) FILTER (
            WHERE BTRIM(sender_age_group) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        5,
        'receiver_age_group',
        COUNT(*) FILTER (
            WHERE BTRIM(receiver_age_group) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        6,
        'sender_state',
        COUNT(*) FILTER (
            WHERE BTRIM(sender_state) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        7,
        'sender_bank',
        COUNT(*) FILTER (
            WHERE BTRIM(sender_bank) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        8,
        'receiver_bank',
        COUNT(*) FILTER (
            WHERE BTRIM(receiver_bank) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        9,
        'device_type',
        COUNT(*) FILTER (
            WHERE BTRIM(device_type) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        10,
        'network_type',
        COUNT(*) FILTER (
            WHERE BTRIM(network_type) = ''
        )
    FROM public.upi_transactions

    UNION ALL

    SELECT
        11,
        'day_of_week',
        COUNT(*) FILTER (
            WHERE BTRIM(day_of_week) = ''
        )
    FROM public.upi_transactions
)

SELECT
    column_name,
    blank_record_count
FROM blank_value_checks
ORDER BY display_order;

-- ============================================================
-- 7.2.5 Numerical and binary range validation
-- Business question:
-- Are numerical and binary fields within valid business ranges?
-- ============================================================

SELECT
    MIN(amount_inr) AS minimum_amount,
    MAX(amount_inr) AS maximum_amount,

    COUNT(*) FILTER (
        WHERE amount_inr <= 0
    ) AS non_positive_amount_records,

    MIN(hour_of_day) AS minimum_hour,
    MAX(hour_of_day) AS maximum_hour,

    COUNT(*) FILTER (
        WHERE hour_of_day NOT BETWEEN 0 AND 23
    ) AS invalid_hour_records,

    MIN(fraud_flag) AS minimum_fraud_flag,
    MAX(fraud_flag) AS maximum_fraud_flag,

    COUNT(*) FILTER (
        WHERE fraud_flag NOT IN (0, 1)
    ) AS invalid_fraud_flag_records,

    MIN(is_weekend) AS minimum_weekend_flag,
    MAX(is_weekend) AS maximum_weekend_flag,

    COUNT(*) FILTER (
        WHERE is_weekend NOT IN (0, 1)
    ) AS invalid_weekend_flag_records

FROM public.upi_transactions;

-- ============================================================
-- 7.2.6 Timestamp and derived-time consistency validation
-- Business question:
-- Do the derived time fields correctly match the timestamp?
-- ============================================================

SELECT
    MIN(timestamp) AS earliest_transaction,
    MAX(timestamp) AS latest_transaction,

    COUNT(*) FILTER (
        WHERE EXTRACT(YEAR FROM timestamp) <> 2024
    ) AS transactions_outside_2024,

    COUNT(*) FILTER (
        WHERE hour_of_day
              <> EXTRACT(HOUR FROM timestamp)::INTEGER
    ) AS hour_mismatch_records,

    COUNT(*) FILTER (
        WHERE LOWER(BTRIM(day_of_week))
              <> LOWER(TO_CHAR(timestamp, 'FMDay'))
    ) AS day_of_week_mismatch_records,

    COUNT(*) FILTER (
        WHERE is_weekend <> CASE
            WHEN EXTRACT(ISODOW FROM timestamp) IN (6, 7)
                THEN 1
            ELSE 0
        END
    ) AS weekend_flag_mismatch_records

FROM public.upi_transactions;

-- ============================================================
-- 7.2.7 Business-domain validation
-- Business question:
-- Do categorical fields contain only approved business values?
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE transaction_type NOT IN (
            'P2P',
            'P2M',
            'Bill Payment',
            'Recharge'
        )
    ) AS invalid_transaction_types,

    COUNT(*) FILTER (
        WHERE merchant_category NOT IN (
            'Grocery',
            'Food',
            'Shopping',
            'Fuel',
            'Other',
            'Utilities',
            'Transport',
            'Entertainment',
            'Healthcare',
            'Education'
        )
    ) AS invalid_merchant_categories,

    COUNT(*) FILTER (
        WHERE transaction_status NOT IN (
            'SUCCESS',
            'FAILED'
        )
    ) AS invalid_transaction_statuses,

    COUNT(*) FILTER (
        WHERE sender_bank NOT IN (
            'SBI',
            'HDFC',
            'ICICI',
            'IndusInd',
            'Axis',
            'PNB',
            'Yes Bank',
            'Kotak'
        )
    ) AS invalid_sender_banks,

    COUNT(*) FILTER (
        WHERE receiver_bank NOT IN (
            'SBI',
            'HDFC',
            'ICICI',
            'IndusInd',
            'Axis',
            'PNB',
            'Yes Bank',
            'Kotak'
        )
    ) AS invalid_receiver_banks,

    COUNT(*) FILTER (
        WHERE sender_state NOT IN (
            'Andhra Pradesh',
            'Delhi',
            'Gujarat',
            'Karnataka',
            'Maharashtra',
            'Rajasthan',
            'Tamil Nadu',
            'Telangana',
            'Uttar Pradesh',
            'West Bengal'
        )
    ) AS invalid_sender_states,

    COUNT(*) FILTER (
        WHERE device_type NOT IN (
            'Android',
            'iOS',
            'Web'
        )
    ) AS invalid_device_types,

    COUNT(*) FILTER (
        WHERE network_type NOT IN (
            '3G',
            '4G',
            '5G',
            'WiFi'
        )
    ) AS invalid_network_types,

    COUNT(*) FILTER (
        WHERE day_of_week NOT IN (
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
        )
    ) AS invalid_weekday_values

FROM public.upi_transactions;

-- ============================================================
-- 7.2.8 DATA QUALITY SUMMARY
-- ============================================================

WITH validation_results AS (

    -- 7.2.1 Missing values
    SELECT
        '7.2.1 Missing Values' AS validation_check,
        (
            COUNT(*) FILTER (WHERE transaction_id IS NULL) +
            COUNT(*) FILTER (WHERE timestamp IS NULL) +
            COUNT(*) FILTER (WHERE transaction_type IS NULL) +
            COUNT(*) FILTER (WHERE merchant_category IS NULL) +
            COUNT(*) FILTER (WHERE amount_inr IS NULL) +
            COUNT(*) FILTER (WHERE transaction_status IS NULL) +
            COUNT(*) FILTER (WHERE sender_age_group IS NULL) +
            COUNT(*) FILTER (WHERE receiver_age_group IS NULL) +
            COUNT(*) FILTER (WHERE sender_state IS NULL) +
            COUNT(*) FILTER (WHERE sender_bank IS NULL) +
            COUNT(*) FILTER (WHERE receiver_bank IS NULL) +
            COUNT(*) FILTER (WHERE device_type IS NULL) +
            COUNT(*) FILTER (WHERE network_type IS NULL) +
            COUNT(*) FILTER (WHERE fraud_flag IS NULL) +
            COUNT(*) FILTER (WHERE hour_of_day IS NULL) +
            COUNT(*) FILTER (WHERE day_of_week IS NULL) +
            COUNT(*) FILTER (WHERE is_weekend IS NULL)
        )::BIGINT AS issue_count
    FROM public.upi_transactions

    UNION ALL

    -- 7.2.2 Duplicate transaction records
    SELECT
        '7.2.2 Duplicate Records',
        COALESCE(SUM(occurrence_count - 1), 0)::BIGINT
    FROM (
        SELECT
            transaction_id,
            COUNT(*) AS occurrence_count
        FROM public.upi_transactions
        GROUP BY transaction_id
        HAVING COUNT(*) > 1
    ) AS duplicates

    UNION ALL

    -- 7.2.3 Unexpected categorical cardinality
    SELECT
        '7.2.3 Categorical Profile',
        (
            (COUNT(DISTINCT transaction_type) <> 4)::INTEGER +
            (COUNT(DISTINCT merchant_category) <> 10)::INTEGER +
            (COUNT(DISTINCT transaction_status) <> 2)::INTEGER +
            (COUNT(DISTINCT sender_age_group) <> 5)::INTEGER +
            (COUNT(DISTINCT receiver_age_group) <> 5)::INTEGER +
            (COUNT(DISTINCT sender_state) <> 10)::INTEGER +
            (COUNT(DISTINCT sender_bank) <> 8)::INTEGER +
            (COUNT(DISTINCT receiver_bank) <> 8)::INTEGER +
            (COUNT(DISTINCT device_type) <> 3)::INTEGER +
            (COUNT(DISTINCT network_type) <> 4)::INTEGER +
            (COUNT(DISTINCT day_of_week) <> 7)::INTEGER
        )::BIGINT
    FROM public.upi_transactions

    UNION ALL

    -- 7.2.4 Blank text values
    SELECT
        '7.2.4 Blank Text Values',
        (
            COUNT(*) FILTER (WHERE BTRIM(transaction_id) = '') +
            COUNT(*) FILTER (WHERE BTRIM(transaction_type) = '') +
            COUNT(*) FILTER (WHERE BTRIM(merchant_category) = '') +
            COUNT(*) FILTER (WHERE BTRIM(transaction_status) = '') +
            COUNT(*) FILTER (WHERE BTRIM(sender_age_group) = '') +
            COUNT(*) FILTER (WHERE BTRIM(receiver_age_group) = '') +
            COUNT(*) FILTER (WHERE BTRIM(sender_state) = '') +
            COUNT(*) FILTER (WHERE BTRIM(sender_bank) = '') +
            COUNT(*) FILTER (WHERE BTRIM(receiver_bank) = '') +
            COUNT(*) FILTER (WHERE BTRIM(device_type) = '') +
            COUNT(*) FILTER (WHERE BTRIM(network_type) = '') +
            COUNT(*) FILTER (WHERE BTRIM(day_of_week) = '')
        )::BIGINT
    FROM public.upi_transactions

    UNION ALL

    -- 7.2.5 Invalid numerical or binary values
    SELECT
        '7.2.5 Numerical and Binary Ranges',
        (
            COUNT(*) FILTER (WHERE amount_inr <= 0) +
            COUNT(*) FILTER (WHERE hour_of_day NOT BETWEEN 0 AND 23) +
            COUNT(*) FILTER (WHERE fraud_flag NOT IN (0, 1)) +
            COUNT(*) FILTER (WHERE is_weekend NOT IN (0, 1))
        )::BIGINT
    FROM public.upi_transactions

    UNION ALL

    -- 7.2.6 Timestamp inconsistencies
    SELECT
        '7.2.6 Timestamp Consistency',
        (
            COUNT(*) FILTER (
                WHERE EXTRACT(YEAR FROM timestamp) <> 2024
            ) +
            COUNT(*) FILTER (
                WHERE EXTRACT(HOUR FROM timestamp)::INTEGER <> hour_of_day
            ) +
            COUNT(*) FILTER (
                WHERE TO_CHAR(timestamp, 'FMDay') <> day_of_week
            ) +
            COUNT(*) FILTER (
                WHERE
                    CASE
                        WHEN EXTRACT(ISODOW FROM timestamp) IN (6, 7)
                        THEN 1
                        ELSE 0
                    END <> is_weekend
            )
        )::BIGINT
    FROM public.upi_transactions

    UNION ALL

    -- 7.2.7 Values outside approved business domains
    SELECT
        '7.2.7 Business Domain Values',
        (
            COUNT(*) FILTER (
                WHERE transaction_type NOT IN
                ('P2P', 'P2M', 'Bill Payment', 'Recharge')
            ) +
            COUNT(*) FILTER (
                WHERE merchant_category NOT IN (
                    'Grocery', 'Food', 'Shopping', 'Fuel', 'Other',
                    'Utilities', 'Transport', 'Entertainment',
                    'Healthcare', 'Education'
                )
            ) +
            COUNT(*) FILTER (
                WHERE transaction_status NOT IN ('SUCCESS', 'FAILED')
            ) +
            COUNT(*) FILTER (
                WHERE sender_bank NOT IN (
                    'SBI', 'HDFC', 'ICICI', 'IndusInd',
                    'Axis', 'PNB', 'Yes Bank', 'Kotak'
                )
            ) +
            COUNT(*) FILTER (
                WHERE receiver_bank NOT IN (
                    'SBI', 'HDFC', 'ICICI', 'IndusInd',
                    'Axis', 'PNB', 'Yes Bank', 'Kotak'
                )
            ) +
            COUNT(*) FILTER (
                WHERE sender_state NOT IN (
                    'Andhra Pradesh', 'Delhi', 'Gujarat',
                    'Karnataka', 'Maharashtra', 'Rajasthan',
                    'Tamil Nadu', 'Telangana',
                    'Uttar Pradesh', 'West Bengal'
                )
            ) +
            COUNT(*) FILTER (
                WHERE device_type NOT IN ('Android', 'iOS', 'Web')
            ) +
            COUNT(*) FILTER (
                WHERE network_type NOT IN ('3G', '4G', '5G', 'WiFi')
            ) +
            COUNT(*) FILTER (
                WHERE day_of_week NOT IN (
                    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
                    'Friday', 'Saturday', 'Sunday'
                )
            )
        )::BIGINT
    FROM public.upi_transactions
)

SELECT
    validation_check,
    issue_count,
    CASE
        WHEN issue_count = 0 THEN 'PASS'
        ELSE 'REVIEW REQUIRED'
    END AS validation_status
FROM validation_results
ORDER BY validation_check;