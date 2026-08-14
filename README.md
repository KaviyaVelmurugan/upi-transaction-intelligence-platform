# UPI Transaction Operational Intelligence Platform

## Project Overview

A FinTech Operational Intelligence Platform that helps business and operations teams monitor transaction health, analyze failure trends, evaluate bank performance, and support operational decision-making using SQL, Power BI, and Machine Learning.

The platform analyzes transaction success and failure patterns, bank-wise performance, time-based trends, merchant categories, device usage, and network-related behaviour.

The main purpose of the project is not only to report transaction failures, but also to provide operational insights that can support faster and more informed decision-making.

---

## Business Problem

UPI platforms process a large number of transactions every day. When transaction failures increase, business and operations teams may not have enough visibility to identify the affected banks, time periods, transaction categories, or possible operational causes.

This project addresses that problem by creating an analytics and intelligence layer that helps stakeholders monitor transaction health and investigate unusual failure patterns.

## Project Objective

The objective of this project is to build a UPI operational intelligence solution that can:

- Monitor transaction success and failure rates
- Analyze bank-wise transaction performance
- Identify peak transaction and failure periods
- Compare merchant, device, and network behaviour
- Detect unusual transaction patterns
- Generate actionable insights for business and operations teams

## Current Phase

- ✅ Phase 1 – Business Understanding
- ✅ Phase 2 – UPI Domain Research
- ✅ Phase 3 – Business Requirement Document
- ✅ Phase 4 – Data Collection
- ✅ Phase 5 – Data Quality & Cleaning
- ✅ Phase 6 – Exploratory Data Analysis
- ✅Phase 7 – SQL Analytics
- ✅ Phase 8 – Power BI Dashboard
- ✅ Phase 9 – Machine Learning
- 🟡 Phase 10 – Final Documentation (In Progress)

---

## How This Project Is Different

Many transaction analytics projects mainly focus on displaying transaction counts, success rates, and failure rates.

This project is positioned as an operational intelligence platform. It focuses on helping stakeholders understand:

- Which banks require investigation
- When transaction failures increase
- Which transaction segments are affected
- How transaction health changes over time
- What operational patterns should be prioritised

The project combines business understanding, Python-based analysis, SQL analytics, Power BI visualisation, and machine learning into one structured FinTech solution.

## Dynamic Analytics Architecture

The platform is designed to accept additional transaction batches without rebuilding the analysis. New CSV records are validated, copied into a PostgreSQL staging table, and merged into the stable transaction table using `transaction_id` as the unique key.

```text
New transaction CSV
        -> Python ingestion command
        -> PostgreSQL staging table
        -> Transaction-ID upsert
        -> Stable production table
        -> Reusable SQL views
        -> Power BI refresh or DirectQuery
```

Existing Transaction IDs are updated only when their stored values change. New IDs are appended, unchanged IDs are skipped, and every ingestion run is recorded in an audit table.

See [`docs/15_Dynamic_Data_Pipeline.md`](docs/15_Dynamic_Data_Pipeline.md) for setup and operating instructions.

## Project Structure

```text
docs/         -> Business documentation
data/         -> Raw and processed datasets
notebooks/    -> Jupyter notebooks
src/          -> Python source code
scripts/      -> Repeatable transaction ingestion
sql/          -> Schema, upsert logic, views, and business analytics
dashboard/    -> Power BI files
diagrams/     -> Architecture and process diagrams
images/       -> Screenshots and visuals
linkedin/     -> LinkedIn article drafts
```

## Power BI Operational Dashboard

The five-page Power BI dashboard connects to PostgreSQL using DirectQuery, allowing the report to retrieve current analytical results from reusable SQL views.

### 1. Executive Overview

![Executive Overview](dashboard/images/01_executive_overview.png)

### 2. Transaction Health Intelligence

![Transaction Health](dashboard/images/02_transaction_health.png)

### 3. Bank Performance Intelligence

![Bank Performance](dashboard/images/03_bank_performance.png)

### 4. Merchant and Channel Intelligence

![Merchant and Channel](dashboard/images/04_merchant_channel.png)

### 5. Operational Monitoring Intelligence

![Operational Monitoring](dashboard/images/05_operational_monitoring.png)

## Machine Learning and Anomaly Detection

Phase 9 evaluated two AI capabilities: transaction-failure prediction and behavioural anomaly detection.

### Transaction Failure Prediction

Three classification approaches were evaluated using a chronological train–test split:

| Model               | Failure Precision | Failure Recall | Failure F1 | PR-AUC | ROC-AUC |
| ------------------- | ----------------: | -------------: | ---------: | -----: | ------: |
| Dummy Baseline      |             0.00% |          0.00% |      0.00% |  4.85% |  50.00% |
| Logistic Regression |             4.83% |         47.32% |      8.76% |  4.78% |  49.50% |
| Random Forest       |             4.44% |          3.83% |      4.11% |  4.83% |  50.05% |

The available transaction attributes did not provide sufficient predictive signal for reliable failure prediction. Therefore, no failure classifier was presented as production-ready.

This decision prevents misleading conclusions based only on accuracy and demonstrates responsible model evaluation for imbalanced financial data.

### Behavioural Anomaly Detection

An Isolation Forest pipeline was developed using 13 behavioural features, including transaction context, log-transformed amount and cyclical hour features.

| Risk Band    | Transactions |  Share | Failure Rate | Average Amount |
| ------------ | -----------: | -----: | -----------: | -------------: |
| Normal       |      237,500 | 95.00% |       4.947% |      ₹1,291.59 |
| Monitor      |       10,000 |  4.00% |       4.980% |      ₹1,668.66 |
| High Anomaly |        2,500 |  1.00% |       5.120% |      ₹1,799.56 |

The model identifies behavioural unusualness rather than confirmed fraud. High-anomaly transactions are placed in an investigation queue for operational review.

### Database Integration

Anomaly scores were loaded into PostgreSQL using an idempotent upsert workflow based on Transaction ID.

The following reusable views support reporting and investigation:

- `vw_anomaly_risk_summary`
- `vw_high_anomaly_review_queue`

Supporting files:

- [`notebooks/04_failure_prediction.ipynb`](notebooks/04_failure_prediction.ipynb)
- [`notebooks/06_anomaly_detection.ipynb`](notebooks/06_anomaly_detection.ipynb)
- [`scripts/load_anomaly_scores.py`](scripts/load_anomaly_scores.py)
- [`sql/anomaly_detection.sql`](sql/anomaly_detection.sql)
- [`docs/17_Machine_Learning_and_Anomaly_Detection.md`](docs/17_Machine_Learning_and_Anomaly_Detection.md)
