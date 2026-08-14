# Phase 9 — Machine Learning and Anomaly Detection

## 1. Phase Overview

Phase 9 evaluates whether historical UPI transaction attributes can support transaction-failure prediction and behavioural anomaly detection.

The phase contains two analytical components:

1. Supervised transaction-failure prediction.
2. Unsupervised transaction anomaly detection.

The objective is not merely to produce a model with high accuracy. The models must provide meaningful operational value and must be evaluated using metrics appropriate for imbalanced financial transaction data.

---

## 2. Dataset Summary

| Attribute                   |                 Value |
| --------------------------- | --------------------: |
| Total transactions          |               250,000 |
| Total columns               |                    17 |
| Successful transactions     |               237,624 |
| Failed transactions         |                12,376 |
| Success rate                |                95.05% |
| Failure rate                |                 4.95% |
| Fraud-labelled transactions |                   480 |
| Fraud rate                  |                0.192% |
| Data period                 | January–December 2024 |

The processed and validated dataset produced during the earlier project phases was used for modelling.

---

# Part A — Transaction Failure Prediction

## 3. Business Objective

The objective of the supervised learning component was to determine whether a transaction could be classified as successful or failed using information available in the dataset.

The target variable was derived as follows:

| Transaction status | Target value |
| ------------------ | -----------: |
| SUCCESS            |            0 |
| FAILED             |            1 |

Failure was treated as the positive class because identifying operational failures is the primary business objective.

---

## 4. Selected Features

Eleven features were selected:

- Transaction type
- Merchant category
- Transaction amount
- Sender age group
- Receiver age group
- Sender state
- Sender bank
- Receiver bank
- Device type
- Network type
- Hour of day

The following fields were excluded:

- `transaction_id`: identifier with no behavioural predictive meaning.
- `timestamp`: replaced by the usable hour feature.
- `transaction_status`: target variable.
- `fraud_flag`: outcome-related field that could introduce leakage.
- `day_of_week` and `is_weekend`: excluded from the initial model feature set to avoid unnecessary duplication.

---

## 5. Chronological Train–Test Split

The dataset was sorted by timestamp and divided chronologically rather than randomly.

| Dataset  | Period                      |    Rows | Failed transactions | Failure rate |
| -------- | --------------------------- | ------: | ------------------: | -----------: |
| Training | 1 January–18 October 2024   | 200,000 |               9,950 |        4.98% |
| Testing  | 18 October–30 December 2024 |  50,000 |               2,426 |        4.85% |

A chronological split more closely represents a production scenario: the model learns from earlier transactions and is evaluated using later, unseen transactions.

---

## 6. Class-Imbalance Challenge

Approximately 95% of transactions were successful, while only about 5% failed.

Because of this imbalance, accuracy alone is misleading. A model predicting every transaction as successful would achieve approximately 95% accuracy while detecting no failures.

The evaluation therefore focused on:

- Failure precision
- Failure recall
- Failure F1-score
- Precision–Recall Area Under the Curve
- Receiver Operating Characteristic Area Under the Curve
- Confusion matrix

---

## 7. Model Results

| Model               | Accuracy | Failure Precision | Failure Recall | Failure F1 | PR-AUC | ROC-AUC |
| ------------------- | -------: | ----------------: | -------------: | ---------: | -----: | ------: |
| Dummy Baseline      |   95.15% |             0.00% |          0.00% |      0.00% |  4.85% |  50.00% |
| Logistic Regression |   52.20% |             4.83% |         47.32% |      8.76% |  4.78% |  49.50% |
| Random Forest       |   91.33% |             4.44% |          3.83% |      4.11% |  4.83% |  50.05% |

### Dummy Baseline

The dummy classifier predicted every transaction as successful.

Although it achieved 95.15% accuracy, it detected none of the 2,426 failed transactions. This demonstrates why accuracy is not an appropriate standalone metric for this problem.

### Logistic Regression

The class-balanced Logistic Regression model identified 47.32% of failures but generated a very large number of false alerts.

Its 4.83% failure precision means that only a small proportion of predicted failures were genuinely failed transactions. Its ROC-AUC of 49.50% indicates no meaningful separation between successful and failed transactions.

### Random Forest

The Random Forest achieved 91.33% accuracy but detected only 93 of the 2,426 failed test transactions.

Its failure recall of 3.83% and ROC-AUC of 50.05% indicate that the model did not discover useful predictive patterns.

---

## 8. Failure-Prediction Decision

None of the tested failure-prediction models should be deployed.

The available features describe transaction context but do not appear to contain the operational signals required to predict failures reliably.

Production-quality failure prediction would likely require additional features such as:

- API response time
- Bank latency
- Payment gateway response code
- Server load
- Retry count
- Application version
- Network latency
- Bank availability
- Error and failure reason
- Recent bank-level performance
- Recent device or customer failure history

Reporting this limitation is an important analytical result. Deploying an unreliable model would generate excessive false alerts or miss most genuine failures.

---

# Part B — Transaction Anomaly Detection

## 9. Business Objective

The anomaly-detection component identifies transactions whose behavioural combinations are unusual compared with the overall transaction population.

An anomaly does not automatically represent fraud or a failed transaction. It represents a transaction requiring additional attention because its combination of characteristics is uncommon.

---

## 10. Anomaly Features

Thirteen behavioural features were used.

### Categorical features

- Transaction type
- Merchant category
- Sender age group
- Receiver age group
- Sender state
- Sender bank
- Receiver bank
- Device type
- Network type

### Numerical and engineered features

- Log-transformed transaction amount
- Hour sine component
- Hour cosine component
- Weekend indicator

The logarithmic amount transformation reduces the influence of extremely large amounts.

Sine and cosine transformations represent hour-of-day as a cyclical variable, ensuring that 23:00 and 00:00 are treated as neighbouring hours.

Transaction status and fraud flag were excluded from training. They were used only afterward to evaluate the operational characteristics of detected anomalies.

---

## 11. Preprocessing and Algorithm

Categorical variables were converted using one-hot encoding. Numerical variables were standardized before modelling.

The anomaly-detection pipeline used:

- `OneHotEncoder` for categorical features
- `StandardScaler` for numerical features
- `IsolationForest` for unsupervised anomaly detection

Isolation Forest was configured with:

- 200 estimators
- 10,000 samples per estimator
- 1% contamination assumption
- Fixed random state for reproducibility

The contamination value instructs the model to identify approximately 1% of transactions as the most unusual observations.

---

## 12. Anomaly-Score Distribution

| Metric          | Anomaly score |
| --------------- | ------------: |
| Minimum         |        0.3972 |
| Mean            |        0.4562 |
| Median          |        0.4544 |
| 95th percentile |        0.4926 |
| 99th percentile |        0.5094 |
| Maximum         |        0.5531 |

A higher score represents a more unusual behavioural pattern.

---

## 13. Risk-Band Framework

The anomaly scores were converted into operational risk bands.

| Risk band    | Transactions |  Share |   Score range |
| ------------ | -----------: | -----: | ------------: |
| Normal       |      237,500 | 95.00% | 0.3972–0.4926 |
| Monitor      |       10,000 |  4.00% | 0.4926–0.5094 |
| High Anomaly |        2,500 |  1.00% | 0.5094–0.5531 |

This approach gives operations teams a manageable review framework:

- **Normal:** no immediate review required.
- **Monitor:** observe for repeated or worsening behaviour.
- **High Anomaly:** prioritize for investigation.

These are analytical prioritization bands, not confirmed fraud classifications.

---

## 14. Risk-Band Validation

| Risk band    | Average amount | Failed transactions | Failure rate | Fraud transactions | Fraud rate |
| ------------ | -------------: | ------------------: | -----------: | -----------------: | ---------: |
| Normal       |      ₹1,291.59 |              11,750 |       4.947% |                456 |     0.192% |
| Monitor      |      ₹1,668.66 |                 498 |       4.980% |                 21 |     0.210% |
| High Anomaly |      ₹1,799.56 |                 128 |       5.120% |                  3 |     0.120% |

High-anomaly transactions had a higher average amount and a slightly higher failure rate than normal transactions.

However, their fraud rate was not higher. This confirms that behavioural unusualness and fraud probability are different concepts.

---

## 15. Important Anomaly Patterns

Several categories appeared more frequently among high-anomaly transactions than expected from their overall representation.

Notable anomaly lifts included:

| Category                    | Approximate anomaly lift |
| --------------------------- | -----------------------: |
| Web device                  |                    9.35× |
| Recharge                    |                    4.81× |
| 3G network                  |                    4.67× |
| Sender age 56+              |                    4.58× |
| Receiver age 56+            |                    4.28× |
| WiFi network                |                    4.17× |
| Education merchant category |                    2.67× |
| Bill Payment                |                    2.20× |

These results do not prove that these categories are inherently risky. They show that the model identified unusual multivariate combinations involving these attributes.

For example, a combination such as Recharge, Education, Web and WiFi may be rare in the dataset even if each individual attribute is legitimate.

---

## 16. High-Anomaly Review Queue

The High Anomaly review queue contains:

| Metric                        |     Value |
| ----------------------------- | --------: |
| Transactions requiring review |     2,500 |
| Failed transactions           |       128 |
| Fraud-labelled transactions   |         3 |
| Average transaction amount    | ₹1,799.56 |
| Maximum anomaly score         |    0.5531 |

The review queue enables analysts to prioritize unusual transactions for further investigation without treating them automatically as fraudulent.

---

## 17. PostgreSQL Integration

Anomaly scores were loaded into PostgreSQL using the table:

```text
public.transaction_anomaly_scores
```

The table stores:

- Transaction ID
- Anomaly score
- Anomaly risk band
- Isolation Forest anomaly flag
- Model version
- Scoring timestamp
- Update timestamp

Transaction ID is used as the primary key and references the main UPI transaction table. This prevents duplicate anomaly records and preserves data integrity.

Two reusable database views were created:

### `public.vw_anomaly_risk_summary`

Provides summary statistics for the Normal, Monitor and High Anomaly bands.

### `public.vw_high_anomaly_review_queue`

Provides the 2,500 detailed High Anomaly transactions for operational investigation.

The database objects can be reproduced using:

```text
sql/anomaly_detection.sql
```

The anomaly scores can be loaded or updated using:

```text
scripts/load_anomaly_scores.py
```

---

## 18. Generated Project Outputs

The anomaly-detection workflow generates:

- Complete transaction anomaly scores
- High-anomaly review queue
- Categorical anomaly profile
- Trained Isolation Forest pipeline
- Model metadata
- PostgreSQL anomaly table
- Power-BI-ready anomaly views

Large generated model and scoring artifacts are retained locally and excluded from GitHub where appropriate. The notebook, database definition, loading script, metadata and smaller analytical outputs provide reproducibility.

---

## 19. Business Recommendations

1. Use the High Anomaly band as an investigation queue, not an automatic blocking mechanism.
2. Combine anomaly scores with operational failure signals and fraud rules.
3. Monitor whether the same customers, banks, devices or networks repeatedly enter high-anomaly bands.
4. Record investigation outcomes to create reliable labels for future supervised models.
5. Add latency, API response, retry and bank-availability features before rebuilding the failure classifier.
6. Retrain the anomaly model periodically as transaction behaviour changes.
7. Monitor anomaly-score distributions to identify model or behavioural drift.

---

## 20. Limitations

- The dataset is synthetic and may not represent every production condition.
- The failure-prediction features provide insufficient discriminatory information.
- The Isolation Forest contamination value controls the number of flagged records.
- An anomaly is not equivalent to fraud.
- No customer-history or merchant-history features were available.
- Real-time scoring and automated model retraining are outside the current portfolio scope.

---

## 21. Phase Conclusion

Phase 9 demonstrated two important outcomes.

First, conventional supervised models could not reliably predict transaction failures using the available attributes. The project therefore avoids presenting a misleading model as production-ready.

Second, Isolation Forest successfully created a behavioural unusualness framework that separates transactions into Normal, Monitor and High Anomaly bands. The resulting 2,500-record investigation queue was integrated into PostgreSQL through a reproducible loading process and reusable SQL views.

This provides a responsible AI component for the UPI Transaction Operational Intelligence Platform while clearly distinguishing anomaly detection, failure prediction and fraud detection.
