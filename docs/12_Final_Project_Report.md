# UPI Transaction Operational Intelligence Platform

## Final Project Report

## 1. Executive Summary

The UPI Transaction Operational Intelligence Platform is an end-to-end FinTech analytics solution designed to help business and operations teams monitor transaction performance, investigate failures, analyse bank and channel behaviour, and identify unusual transaction patterns.

The project combines business analysis, Python, statistical analysis, PostgreSQL, a repeatable ingestion pipeline, Power BI DirectQuery and responsible machine-learning evaluation.

The final solution processes 250,000 synthetic UPI transactions covering January–December 2024.

## 2. Business Problem

UPI payment platforms require timely visibility into transaction failures and operational deterioration.

Raw transaction records alone do not allow stakeholders to determine:

- Whether transaction health is improving or worsening
- Which banks handle the greatest operational volume
- Which time periods experience elevated failures
- Which merchant and channel segments require attention
- Whether unusual transaction combinations should be investigated
- Whether new data can be added without rebuilding the analysis

The platform addresses these needs through reusable analytics and operational monitoring.

## 3. Project Objectives

The project was designed to:

1. Monitor transaction success and failure KPIs.
2. Analyse transaction volume and value.
3. Compare sender-bank and receiver-bank performance.
4. Identify daily and hourly failure patterns.
5. Evaluate merchant, device and network behaviour.
6. Detect statistically unusual failure periods.
7. Build a repeatable PostgreSQL ingestion workflow.
8. Create a refreshable Power BI dashboard.
9. Evaluate transaction-failure prediction responsibly.
10. Create a behavioural anomaly investigation queue.

## 4. Project Scope

### Included

- Business requirements
- Dataset evaluation and selection
- Data quality assessment
- Exploratory data analysis
- Statistical testing
- PostgreSQL analytics
- Dynamic transaction ingestion
- Power BI DirectQuery dashboard
- Failure-prediction evaluation
- Isolation Forest anomaly detection
- PostgreSQL anomaly-score integration
- Documentation and reproducibility

### Excluded

- Real UPI payment processing
- Real customer or banking data
- Production banking APIs
- Automatic transaction blocking
- Production fraud confirmation
- Managed cloud deployment
- Power BI Service gateway deployment
- Real-time model serving

## 5. Dataset Summary

| Metric                      |                Result |
| --------------------------- | --------------------: |
| Transactions                |               250,000 |
| Columns                     |                    17 |
| Data period                 | January–December 2024 |
| Successful transactions     |               237,624 |
| Failed transactions         |                12,376 |
| Success rate                |                95.05% |
| Failure rate                |                 4.95% |
| Total transaction value     |          ₹327,939,009 |
| Average transaction value   |             ₹1,311.76 |
| Fraud-labelled transactions |                   480 |
| Fraud rate                  |                0.192% |

The dataset is synthetic and contains no real personally identifiable or confidential banking information.

## 6. Solution Components

| Component            | Deliverable                                                |
| -------------------- | ---------------------------------------------------------- |
| Business analysis    | BRD, scope, objectives, stakeholders, risks and KPIs       |
| Data preparation     | Validated and standardized transaction dataset             |
| Exploratory analysis | Business-focused EDA and statistical analysis              |
| Database             | PostgreSQL transaction, staging and audit structures       |
| Data ingestion       | Duplicate-safe Transaction-ID upsert pipeline              |
| SQL analytics        | Reusable KPI and operational-intelligence views            |
| Dashboard            | Five-page Power BI DirectQuery report                      |
| Failure prediction   | Baseline, Logistic Regression and Random Forest evaluation |
| Anomaly detection    | Isolation Forest scoring and risk bands                    |
| Operational review   | High-anomaly PostgreSQL review queue                       |
| Documentation        | Technical, analytical and recruiter-facing reports         |

## 7. Power BI Dashboard

The dashboard contains five pages:

1. **Executive Overview** — platform-wide transaction, value, failure and fraud KPIs.
2. **Transaction Health** — daily and hourly activity, failure rates and control limits.
3. **Bank Performance** — sender and receiver bank operational analysis.
4. **Merchant and Channel** — merchant category, device and network performance.
5. **Operational Monitoring** — failure alerts, data freshness and ingestion history.

Power BI connects to PostgreSQL using DirectQuery and reusable SQL views.

## 8. Key Analytical Findings

- The platform achieved a 95.05% success rate across 250,000 transactions.
- P2P represented 44.98% of transaction activity.
- P2M represented 35.06% of transaction activity.
- Grocery was the highest-volume merchant category with 49,966 transactions.
- SBI handled approximately 25% of sender and receiver transaction volume.
- Android supported 75.11% of transactions.
- 4G supported 59.93% of transactions.
- Transaction values were strongly right-skewed, with a median of ₹629 and an average of ₹1,311.76.
- Platform-wide failure-rate differences across the available dimensions were relatively small.
- Statistical monitoring identified unusual daily failure periods requiring operational investigation.

## 9. Dynamic Data Pipeline

The project was upgraded from a static CSV analysis to a repeatable ingestion architecture.

The workflow:

1. Receives an incoming transaction batch.
2. Validates its schema.
3. Loads valid records into a PostgreSQL staging table.
4. Uses Transaction ID to insert new records.
5. Updates changed records.
6. Skips unchanged records.
7. Records the ingestion outcome.
8. Updates analytical views through the stable transaction table.
9. Makes current results available to Power BI.

This makes the analytical layer refreshable without rebuilding the project.

## 10. Failure-Prediction Evaluation

Three approaches were evaluated using a chronological train–test split.

| Model               | Failure Precision | Failure Recall | Failure F1 | PR-AUC | ROC-AUC |
| ------------------- | ----------------: | -------------: | ---------: | -----: | ------: |
| Dummy Baseline      |             0.00% |          0.00% |      0.00% |  4.85% |  50.00% |
| Logistic Regression |             4.83% |         47.32% |      8.76% |  4.78% |  49.50% |
| Random Forest       |             4.44% |          3.83% |      4.11% |  4.83% |  50.05% |

The available features did not provide sufficient predictive signal. No classifier was presented as deployable.

This conclusion prevents misleading claims based on high accuracy caused by class imbalance.

## 11. Anomaly Detection

Isolation Forest used 13 behavioural features without using transaction status or fraud flag during training.

| Risk band    | Transactions |  Share | Failure rate | Average amount |
| ------------ | -----------: | -----: | -----------: | -------------: |
| Normal       |      237,500 | 95.00% |       4.947% |      ₹1,291.59 |
| Monitor      |       10,000 |  4.00% |       4.980% |      ₹1,668.66 |
| High Anomaly |        2,500 |  1.00% |       5.120% |      ₹1,799.56 |

The High Anomaly band became an investigation queue containing 2,500 transactions.

Anomaly status represents behavioural unusualness and is not treated as confirmed fraud.

## 12. Business Recommendations

1. Monitor failure rates using statistical control limits.
2. Prioritize high-volume banks during operational investigations.
3. Maintain daily and hourly failure-monitoring views.
4. Use anomaly results for review rather than automatic blocking.
5. Collect bank latency, API response, retry, server-load and error-code features.
6. Record investigation outcomes as reliable future model labels.
7. Retrain and monitor anomaly models as transaction behaviour changes.
8. Maintain an audited ingestion history for data freshness and governance.

## 13. Limitations

- Synthetic data may not represent all production UPI behaviour.
- Operational latency and infrastructure signals were unavailable.
- Failure classifiers did not demonstrate deployable performance.
- Isolation Forest output depends partly on the configured contamination assumption.
- PostgreSQL runs locally through Docker.
- Real-time scoring and cloud deployment are not implemented.
- Power BI Service gateway configuration is outside the project scope.

## 14. Skills Demonstrated

- FinTech domain understanding
- Business requirement analysis
- Data quality assessment
- Python data analysis
- Statistical hypothesis testing
- PostgreSQL and SQL
- Data-pipeline design
- Power BI and DAX
- Machine-learning evaluation
- Anomaly detection
- Responsible AI decision-making
- Git and GitHub documentation

## 15. Final Outcome

The project successfully delivers a reproducible UPI operational-intelligence platform.

It demonstrates more than static data analysis by integrating:

- Business requirements
- Validated data
- Analytical notebooks
- PostgreSQL storage
- Repeatable ingestion
- Reusable SQL views
- Power BI DirectQuery
- Failure-model evaluation
- Anomaly-score integration
- Operational review workflows

The solution is suitable as a portfolio case study demonstrating business analysis, analytics engineering, business intelligence and applied machine-learning capabilities.

## 16. Project Status

| Phase                                          | Status                    |
| ---------------------------------------------- | ------------------------- |
| Business understanding and BRD                 | Complete                  |
| Dataset selection and validation               | Complete                  |
| Exploratory data analysis                      | Complete                  |
| SQL analytics                                  | Complete                  |
| Dynamic ingestion pipeline                     | Complete                  |
| Power BI dashboard                             | Complete                  |
| Machine learning and anomaly detection         | Complete                  |
| Final documentation and repository preparation | Complete                  |
| LinkedIn publication                           | Deferred by project owner |
