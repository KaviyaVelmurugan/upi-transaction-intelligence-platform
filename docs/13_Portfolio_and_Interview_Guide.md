# UPI Transaction Operational Intelligence Platform

## Portfolio and Interview Guide

## 1. GitHub Repository Description

End-to-end UPI operational intelligence platform using Python, PostgreSQL, Docker, Power BI DirectQuery and Isolation Forest to monitor transaction health, support repeatable data ingestion and prioritise unusual transactions for investigation.

## 2. Resume Project Title

**UPI Transaction Operational Intelligence Platform**

## 3. Resume Bullets

- Developed an end-to-end FinTech operational intelligence platform analysing **250,000 synthetic UPI transactions** using Python, PostgreSQL, Power BI and machine learning.
- Built a repeatable PostgreSQL ingestion pipeline using staging tables, Transaction-ID upserts and ingestion auditing to insert new records, update changed records and prevent duplicate loading.
- Designed a five-page Power BI DirectQuery dashboard covering executive KPIs, transaction health, bank performance, merchant and channel analysis, and operational monitoring.
- Evaluated Dummy, Logistic Regression and Random Forest failure classifiers using a chronological split and imbalance-aware metrics; determined that available features did not provide sufficient predictive signal for deployment.
- Implemented an Isolation Forest pipeline using 13 behavioural features and created Normal, Monitor and High Anomaly bands, producing a **2,500-transaction investigation queue**.
- Integrated anomaly scores into PostgreSQL using an idempotent loading script and reusable operational-summary and review-queue views.
- Documented business requirements, EDA, statistical tests, SQL analytics, architecture, limitations and business recommendations in a reproducible GitHub repository.

Select three or four bullets according to available resume space.

## 4. Sixty-Second Interview Introduction

I developed a UPI Transaction Operational Intelligence Platform using a synthetic dataset of 250,000 transactions.

I started by defining the business problem and requirements, then performed data-quality validation, exploratory analysis and statistical testing. I loaded the data into PostgreSQL and created a repeatable ingestion process using a staging table and Transaction-ID upsert logic.

I built reusable SQL views and connected them to a five-page Power BI dashboard through DirectQuery. The dashboard covers executive KPIs, transaction health, bank performance, merchant and channel analysis, and operational monitoring.

For machine learning, I evaluated failure-prediction models using imbalance-aware metrics. The models did not provide reliable predictive performance, so I did not present them as deployable. Instead, I implemented Isolation Forest to create behavioural anomaly risk bands and a 2,500-transaction investigation queue.

The project demonstrates business analysis, data analytics, SQL, business intelligence, data-pipeline design and responsible machine-learning evaluation.

## 5. Business Problem Explanation

The problem was not simply to calculate transaction counts.

Business and operations teams need to understand:

- Whether failures are increasing
- Which banks and transaction segments are affected
- When operational deterioration occurs
- Whether new data can be incorporated consistently
- Which unusual transactions should be investigated first

The project therefore combines monitoring, investigation and reproducibility rather than presenting only static charts.

## 6. Why PostgreSQL Was Used

PostgreSQL provides a stable analytical data layer between incoming transaction files and Power BI.

It enables:

- Schema enforcement
- Duplicate prevention
- Staging-table validation
- Insert and update logic
- Reusable business calculations
- Ingestion-history auditing
- Current-source reporting through DirectQuery

## 7. Why Docker Was Used

Docker provides a reproducible local PostgreSQL environment.

It allows the database to run with a defined version and port without depending on an older PostgreSQL installation already configured on the computer.

Docker supports the database; pgAdmin is only the graphical tool used to manage and query it.

## 8. Why DirectQuery Was Used

DirectQuery allows Power BI to retrieve analytical results from PostgreSQL instead of depending entirely on manually exported CSV files.

When transaction records and SQL views change, Power BI can retrieve current database results while PostgreSQL is available.

## 9. Why Accuracy Was Not Used Alone

Approximately 95% of transactions were successful.

A model predicting every transaction as successful achieved approximately 95% accuracy while detecting no failures. Therefore, accuracy alone was misleading.

The evaluation focused on:

- Failure precision
- Failure recall
- Failure F1-score
- PR-AUC
- ROC-AUC
- Confusion matrix

## 10. Why the Failure Model Was Not Deployed

The tested models did not separate successful and failed transactions reliably.

The available dataset lacked operational predictors such as:

- Bank latency
- API response codes
- Retry attempts
- Server load
- Application version
- Network latency
- Recent failure history

Presenting the model as deployable would therefore have been misleading.

## 11. What Isolation Forest Does

Isolation Forest identifies records that are easier to isolate from the majority of observations.

In this project, it detects unusual combinations of:

- Transaction type
- Merchant category
- Amount
- Customer age groups
- State
- Banks
- Device
- Network
- Hour and weekend behaviour

It does not determine whether a transaction is fraudulent.

## 12. Anomaly Detection Versus Fraud Detection

Anomaly detection identifies unusual behaviour.

Fraud detection predicts or confirms fraudulent behaviour using reliable fraud labels and relevant risk signals.

A transaction may be unusual but legitimate. A fraudulent transaction may also resemble normal behaviour. Therefore, the High Anomaly band is used as an investigation queue, not an automatic fraud decision.

## 13. Main Project Challenge

The most important challenge was recognising that the transaction dataset was strong for descriptive analytics but weak for transaction-failure prediction.

Instead of forcing a misleading model, the project documented the limitation, identified missing operational features and implemented anomaly detection as a more appropriate analytical capability.

## 14. Future Improvements

- Add real operational latency and response-code features
- Implement automated batch scheduling
- Add model and data-drift monitoring
- Deploy PostgreSQL to managed cloud infrastructure
- Configure Power BI Service with a secure gateway
- Add investigation outcomes as supervised labels
- Implement real-time anomaly scoring through an API
- Introduce role-based database and dashboard access

## 15. Skills Demonstrated

- FinTech business analysis
- Data-quality validation
- Python and Pandas
- Statistical analysis
- PostgreSQL and advanced SQL
- ETL and upsert design
- Docker
- Power BI and DAX
- Machine-learning evaluation
- Isolation Forest
- Responsible AI communication
- Git and GitHub
