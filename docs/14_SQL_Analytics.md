# 14. SQL Analytics

## 7.1 Database Setup and Data Import

### Objective

The objective of this section is to establish an isolated PostgreSQL environment, create a structured transaction table, import the processed UPI dataset, and verify that the database results match the previously validated Python dataset.

---

### Database Architecture

The project uses the following architecture:

```text
VS Code SQL Scripts
        ↓
pgAdmin 4
        ↓
PostgreSQL 17 inside Docker
        ↓
upi_transaction_intelligence
        ↓
upi_transactions
```

Docker provides an isolated PostgreSQL environment without affecting previously installed database servers. pgAdmin is used to connect to PostgreSQL and execute SQL queries, while VS Code stores the permanent SQL scripts for GitHub.

---

### Environment Configuration

| Component           | Configuration                  |
| ------------------- | ------------------------------ |
| Database Engine     | PostgreSQL 17                  |
| Container Platform  | Docker Desktop                 |
| Container Name      | `upi-postgres`                 |
| Database Name       | `upi_transaction_intelligence` |
| Database User       | `upi_admin`                    |
| Host                | `127.0.0.1`                    |
| Port                | `5433`                         |
| Persistent Volume   | `upi_postgres_data`            |
| Administration Tool | pgAdmin 4                      |
| SQL Script          | `sql/01_database_setup.sql`    |

The database password is stored locally and is not included in the GitHub repository.

---

### Table Created

The processed dataset was imported into:

```text
public.upi_transactions
```

The table contains 17 columns representing transaction details, payment status, merchant information, customer demographics, banking information, device and network information, time attributes, and fraud indicators.

---

### Data Integrity Controls

The following constraints were included in the table design:

| Constraint      | Purpose                                   |
| --------------- | ----------------------------------------- |
| `PRIMARY KEY`   | Ensures every transaction ID is unique    |
| `NOT NULL`      | Prevents incomplete transaction records   |
| `CHECK`         | Restricts fields to valid business values |
| `NUMERIC(12,2)` | Stores transaction amounts accurately     |
| `TIMESTAMP`     | Supports date- and time-based analysis    |
| `SMALLINT`      | Efficiently stores binary and hour values |

Validation rules were applied to:

- Transaction status: `SUCCESS` or `FAILED`
- Fraud flag: `0` or `1`
- Weekend flag: `0` or `1`
- Hour of day: `0` through `23`
- Transaction amount: zero or greater

---

### Data Import Method

The validated CSV file was first copied into the Docker container and then imported using PostgreSQL’s `COPY` command.

```text
Local processed CSV
        ↓
Docker container temporary directory
        ↓
PostgreSQL COPY command
        ↓
upi_transactions table
```

The `COPY` operation imported all 250,000 records successfully.

---

### Import Validation Results

| Validation Metric         |          SQL Result |       Python Result | Status |
| ------------------------- | ------------------: | ------------------: | ------ |
| Total Records             |             250,000 |             250,000 | Passed |
| Unique Transaction IDs    |             250,000 |             250,000 | Passed |
| Duplicate Transaction IDs |                   0 |                   0 | Passed |
| Successful Transactions   |             237,624 |             237,624 | Passed |
| Failed Transactions       |              12,376 |              12,376 | Passed |
| Failure Rate              |              4.950% |              4.950% | Passed |
| Fraudulent Transactions   |                 480 |                 480 | Passed |
| Fraud Rate                |              0.192% |              0.192% | Passed |
| Total Transaction Value   |        ₹327,939,009 |        ₹327,939,009 | Passed |
| Average Transaction Value |           ₹1,311.76 |           ₹1,311.76 | Passed |
| Earliest Transaction      | 2024-01-01 00:05:10 | 2024-01-01 00:05:10 | Passed |
| Latest Transaction        | 2024-12-30 23:55:40 | 2024-12-30 23:55:40 | Passed |

---

### SQL Functions Used

| Function or Clause    | Purpose                                    |
| --------------------- | ------------------------------------------ |
| `CREATE TABLE`        | Creates the transaction table              |
| `IF NOT EXISTS`       | Prevents accidental duplicate-table errors |
| `COPY`                | Imports CSV records efficiently            |
| `COUNT(*)`            | Counts all imported transactions           |
| `COUNT(DISTINCT ...)` | Verifies transaction-ID uniqueness         |
| `FILTER (WHERE ...)`  | Performs conditional aggregation           |
| `NULLIF()`            | Prevents division-by-zero errors           |
| `ROUND()`             | Formats calculated business metrics        |
| `SUM()`               | Calculates total transaction value         |
| `AVG()`               | Calculates average transaction value       |
| `MIN()` and `MAX()`   | Validate the dataset’s time coverage       |

---

### Key Outcome

The PostgreSQL database was created successfully, and all 250,000 transaction records were imported without duplicates. SQL results match the Python-validated dataset across record counts, transaction statuses, fraud metrics, transaction values, and time boundaries.

This confirms that PostgreSQL is ready for detailed business queries, dimensional analysis, time analysis, failure analysis, and Power BI integration.

---

### Section Status

```text
Phase 7.1 — Database Setup and Data Import: Completed
```

### Next Section

```text
Phase 7.2 — SQL Data Quality Validation
```

Section 7.2 will perform deeper SQL-based validation of null values, invalid categories, numerical ranges, timestamp consistency, and derived time fields.

## 7.2 SQL Data Quality Validation

### Objective

The objective of this section was to verify the completeness, uniqueness, consistency, validity, and business reliability of the UPI transaction data after importing it into PostgreSQL.

### Validation Results

| Section | Validation                            | Issues Detected | Status |
| ------- | ------------------------------------- | --------------: | ------ |
| 7.2.1   | Missing-value validation              |               0 | PASS   |
| 7.2.2   | Duplicate transaction validation      |               0 | PASS   |
| 7.2.3   | Categorical profile validation        |    0 mismatches | PASS   |
| 7.2.4   | Blank-text validation                 |               0 | PASS   |
| 7.2.5   | Numerical and binary range validation |               0 | PASS   |
| 7.2.6   | Timestamp consistency validation      |               0 | PASS   |
| 7.2.7   | Business-domain validation            |               0 | PASS   |

### Key Findings

- All 250,000 transaction records contain complete information.
- Every transaction ID is unique.
- No blank values were detected in text columns.
- Transaction amounts, hours, fraud flags, and weekend indicators contain valid values.
- The stored hour, weekday, and weekend fields are consistent with the transaction timestamp.
- All categorical fields contain approved business-domain values.
- The PostgreSQL data matches the quality results previously obtained using Python.

### Business Interpretation

The imported transaction table is sufficiently reliable for KPI calculation, dimensional analysis, time-series reporting, operational failure analysis, and Power BI dashboard development.

Because no material data-quality issues were detected, the dataset can proceed to the business analytics stage without corrective SQL transformations.

### Conclusion

SQL Data Quality Validation was completed successfully. All validation checks returned zero issues and received a PASS status.

## 7.3 Core Business KPIs

### Objective

The objective of this section was to calculate executive-level transaction, monetary, operational, fraud, and business-target KPIs using PostgreSQL.

### 7.3.1 Executive Transaction KPIs

| KPI                       |       Result |
| ------------------------- | -----------: |
| Total Transactions        |      250,000 |
| Successful Transactions   |      237,624 |
| Failed Transactions       |       12,376 |
| Success Rate              |       95.05% |
| Failure Rate              |        4.95% |
| Total Transaction Value   | ₹327,939,009 |
| Average Transaction Value |    ₹1,311.76 |
| Fraud Transactions        |          480 |
| Fraud Rate                |       0.192% |

### 7.3.2 Transaction Value KPIs

The average transaction value was ₹1,311.76, while the median was ₹629.00. This difference indicates a right-skewed transaction-value distribution influenced by a smaller number of high-value payments.

Transaction values ranged from ₹10 to ₹42,099. The 95th percentile was ₹4,687.05, meaning 95% of transactions had values at or below this amount.

### 7.3.3 Transaction Status and Value Exposure

Successful transactions processed ₹311,181,812, representing 94.89% of total attempted transaction value.

Failed payment attempts involved ₹16,757,197, representing 5.11% of attempted value. Failed transactions accounted for 4.95% of volume but 5.11% of value because their average value of ₹1,354.01 was slightly higher than the successful transaction average of ₹1,309.56.

The failed amount represents attempted payment value exposed to failure and should not be interpreted as confirmed revenue loss.

### 7.3.4 Fraud Exposure KPIs

The dataset contained 480 fraud-flagged transactions, representing 0.192% of transaction volume.

Fraud-flagged transactions were associated with ₹719,631, or 0.219% of total transaction value. Their average value was ₹1,499.23, approximately 14.32% higher than the normal transaction average of ₹1,311.40.

Only 21 fraud-flagged transactions failed. Therefore, transaction failure should not be treated as a direct indicator of fraud because a fraud-flagged transaction may still be processed successfully.

### 7.3.5 Business Target Gap Analysis

| KPI          | Current |        Target |                    Gap |
| ------------ | ------: | ------------: | ---------------------: |
| Success Rate |  95.05% |        98.50% | 3.45 percentage points |
| Failure Rate |   4.95% | Maximum 1.50% | 3.45 percentage points |

To achieve a 98.50% success rate at the current transaction volume:

- Successful transactions must increase from 237,624 to 246,250.
- An additional 8,626 transactions must complete successfully.
- Failed transactions must decrease from 12,376 to no more than 3,750.
- Approximately 69.70% of current failures must be prevented.

The current platform performance is therefore classified as **BELOW TARGET**.

### Business Interpretation

The platform processes substantial transaction volume and value, but its 4.95% failure rate remains significantly above the business target of 1.50%. Failed payment attempts also represent a slightly larger proportion of monetary value than transaction volume.

Fraud prevalence is low, but fraud-flagged transactions have higher average values and should be monitored separately from operational payment failures.

### Conclusion

The SQL KPI analysis established a reliable executive baseline for monitoring transaction performance, monetary exposure, fraud activity, and progress toward the project’s business objectives.
