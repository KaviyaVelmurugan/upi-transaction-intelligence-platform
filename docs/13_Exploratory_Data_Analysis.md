# 13. Exploratory Data Analysis (EDA)

## 6.1. Objective

The objective of Exploratory Data Analysis (EDA) is to understand the characteristics of the UPI transaction dataset by identifying patterns, trends, relationships, and anomalies. The insights obtained from this phase will support business decision-making, SQL analytics, Power BI dashboard development, and fraud detection modeling.

---

# 6.2.1 Dataset Overview

## Dataset Summary

| Attribute           |                 Value |
| ------------------- | --------------------: |
| Dataset Name        | UPI Transactions 2024 |
| Total Records       |               250,000 |
| Total Columns       |                    17 |
| Missing Values      |                     0 |
| Duplicate Records   |                     0 |
| Datetime Columns    |                     1 |
| Numerical Columns   |                     4 |
| Categorical Columns |                    12 |

---

## Dataset Description

The dataset contains synthetic UPI transaction records collected throughout the year 2024. Each record represents a single digital payment transaction and includes transaction details, customer demographics, merchant information, banking details, device information, network information, and fraud indicators.

---

## Initial Observation

The dataset is well-structured and suitable for business analytics. It contains no missing values or duplicate records, and all data types have been validated during the Data Preparation phase. The timestamp column has been converted to datetime format, enabling time-based analysis in the subsequent sections.

---

## Next Phase

The following sections will perform detailed exploratory analysis, including:

- Univariate Analysis
- Bivariate Analysis
- Time-Series Analysis
- Fraud Analysis
- Statistical Analysis
- Business Insights

### Observation

The dataset contains four major transaction types. Person-to-Person (P2P) transactions account for the largest share with **112,445 transactions (44.98%)**, followed by Person-to-Merchant (P2M) transactions with **87,660 transactions (35.06%)**. Bill Payments contribute **14.95%**, while Recharge transactions represent only **5.01%** of the total transactions.

---

### Business Interpretation

The high volume of P2P transactions indicates that users primarily utilize UPI for transferring money between individuals, such as payments to friends and family. P2M transactions also form a significant portion, demonstrating strong merchant adoption of digital payments. Bill payments and mobile recharges are comparatively less frequent, suggesting that users may rely on specialized applications or automated payment methods for these services.

---

### Recommendation

Financial institutions and UPI service providers should continue enhancing the user experience for P2P and P2M transactions, as these represent nearly 80% of all transactions. Promotional campaigns and cashback offers could be introduced for bill payments and recharge services to encourage greater adoption and increase transaction diversity.

## 6.2.2 Merchant Category Distribution

### Business Question

Which merchant categories receive the highest number of UPI transactions?

### Objective

To analyze the distribution of merchant categories and identify the sectors with the highest transaction volume.

### Observation

The dataset consists of transactions across ten merchant categories. Grocery transactions account for the highest share with **49,966 transactions (19.99%)**, followed by Food with **37,464 transactions (14.99%)** and Shopping with **29,872 transactions (11.95%)**. Fuel (10.03%), Other (9.93%), Utilities (8.94%), Transport (8.04%), and Entertainment (8.04%) contribute a moderate share of transactions. Healthcare (5.07%) and Education (3.04%) represent the smallest transaction volumes.

### Business Interpretation

The analysis indicates that UPI is primarily used for everyday consumer spending, particularly in grocery stores and food outlets. Shopping and fuel payments also contribute significantly, highlighting the growing preference for digital payments in routine purchases. Lower transaction volumes in healthcare and education suggest that these expenses occur less frequently or are often settled using alternative payment methods.

### Recommendation

Banks, payment service providers, and merchants should continue strengthening digital payment experiences in high-volume categories such as Grocery, Food, and Shopping. Targeted cashback offers, reward programs, or promotional campaigns could encourage increased UPI adoption in lower-volume categories like Healthcare and Education.

## 6.2.3 Transaction Status Distribution

### Business Question

What proportion of UPI transactions are successful and failed?

### Objective

To measure transaction outcomes and establish the dataset's overall transaction success and failure rates.

### Results

| Transaction Status | Transaction Count |  Percentage |
| ------------------ | ----------------: | ----------: |
| SUCCESS            |           237,624 |      95.05% |
| FAILED             |            12,376 |       4.95% |
| **Total**          |       **250,000** | **100.00%** |

### Observation

Of the 250,000 transactions in the dataset, **237,624 transactions (95.05%)** were successful, while **12,376 transactions (4.95%)** failed.

This means approximately one out of every twenty transactions in the synthetic dataset was unsuccessful.

### Business Interpretation

The high success rate indicates that most transactions were completed successfully. However, the 4.95% failure rate still represents a meaningful number of unsuccessful transactions at this dataset's scale.

Failed transactions may negatively affect customer experience and platform trust. Therefore, the failure segment requires further investigation across dimensions such as time, bank, transaction type, device type, and network type.

Because the dataset does not contain a detailed failure-reason field, the analysis can identify patterns associated with failed transactions but cannot determine their confirmed technical root causes.

### Recommendation

The business and operations teams should:

- Monitor transaction success and failure rates as core operational KPIs.
- Analyze failure rates by sender bank, receiver bank, transaction type, device type, network type, and time period.
- Establish alerts for unusual increases in the failure rate.
- Prioritize high-volume segments where even a small failure-rate increase could affect many transactions.
- Obtain operational error codes or failure-reason data in a production environment for confirmed root-cause investigation.

## 6.2.4 Transaction Amount Distribution

### Business Question

How are UPI transaction amounts distributed, and are there unusually high-value transactions?

### Objective

To examine the central tendency, spread, skewness, and potential outliers in transaction amounts.

### Results

| Metric              |     Amount |
| ------------------- | ---------: |
| Total Transactions  |    250,000 |
| Mean                |  ₹1,311.76 |
| Median              |    ₹629.00 |
| Mode                |    ₹215.00 |
| Minimum             |     ₹10.00 |
| First Quartile (Q1) |    ₹288.00 |
| Third Quartile (Q3) |  ₹1,596.00 |
| 90th Percentile     |  ₹3,236.00 |
| 95th Percentile     |  ₹4,687.05 |
| 99th Percentile     |  ₹9,003.01 |
| Maximum             | ₹42,099.00 |
| Standard Deviation  |  ₹1,848.06 |
| Skewness            |       3.92 |

### IQR Outlier Assessment

| Metric                  |      Value |
| ----------------------- | ---------: |
| Interquartile Range     |  ₹1,308.00 |
| Lower Bound             | -₹1,674.00 |
| Upper Bound             |  ₹3,558.00 |
| Potential Outliers      |     21,171 |
| Potential Outlier Share |      8.47% |

### Observation

The mean transaction amount is **₹1,311.76**, while the median is substantially lower at **₹629.00**. The difference between the mean and median, together with a skewness value of **3.92**, indicates a strongly right-skewed distribution.

Half of all transactions have amounts between **₹288 and ₹1,596**. Approximately 90% are below **₹3,236**, while the largest transaction is **₹42,099**.

Using the IQR method, transactions above **₹3,558** are statistically flagged as potential outliers. This identifies **21,171 transactions**, representing **8.47%** of the dataset.

The negative lower bound does not indicate negative transactions. The minimum observed amount is ₹10, so no lower-end IQR outliers exist.

### Business Interpretation

The distribution indicates that the platform is predominantly used for relatively small and routine payments. A smaller number of high-value transactions raises the overall average, making the median more representative of a typical transaction.

The transactions flagged by the IQR method should not automatically be treated as errors or fraud. Legitimate use cases such as shopping, education, healthcare, travel, or bill payments may naturally involve larger amounts.

However, high-value transactions may carry greater financial exposure and can be treated as a separate monitoring segment during fraud and risk analysis.

### Recommendation

- Use the median alongside the mean when reporting typical transaction value.
- Create transaction-value bands for clearer analysis and dashboard reporting.
- Analyze high-value transactions by merchant category, bank, transaction type, and fraud flag.
- Do not delete IQR outliers without investigating their business context.
- Apply enhanced monitoring to unusual combinations of amount, device, network, time, and transaction behavior.

## 6.2.5 Sender Bank Distribution

### Business Question

Which sender banks process the highest number and value of UPI transactions?

### Objective

To compare sender banks based on transaction count, share of transaction volume, total transaction value, and average transaction value.

### Results

| Sender Bank | Transaction Count | Transaction Share | Total Transaction Value | Average Transaction Value |
| ----------- | ----------------: | ----------------: | ----------------------: | ------------------------: |
| SBI         |            62,693 |            25.08% |             ₹82,816,520 |                 ₹1,320.99 |
| HDFC        |            37,485 |            14.99% |             ₹49,791,194 |                 ₹1,328.30 |
| ICICI       |            29,769 |            11.91% |             ₹38,731,193 |                 ₹1,301.06 |
| IndusInd    |            25,173 |            10.07% |             ₹32,842,711 |                 ₹1,304.68 |
| Axis        |            25,042 |            10.02% |             ₹32,472,530 |                 ₹1,296.72 |
| PNB         |            24,946 |             9.98% |             ₹32,476,972 |                 ₹1,301.89 |
| Yes Bank    |            24,860 |             9.94% |             ₹32,492,477 |                 ₹1,307.02 |
| Kotak       |            20,032 |             8.01% |             ₹26,315,412 |                 ₹1,313.67 |

### Observation

SBI records the highest sender-side transaction volume with **62,693 transactions**, accounting for **25.08%** of all transactions. HDFC follows with **37,485 transactions (14.99%)**, while ICICI contributes **29,769 transactions (11.91%)**.

Together, SBI, HDFC, and ICICI account for **51.98%** of sender-side transaction volume.

The total transaction value across all sender banks is **₹327,939,009**. SBI records the highest total value at approximately **₹82.82 million**, mainly because it has the largest transaction count.

Average transaction values are relatively similar across all banks, ranging from approximately **₹1,296.72 to ₹1,328.30**.

### Business Interpretation

The sender-bank distribution in this synthetic dataset is concentrated around SBI, HDFC, and ICICI, with SBI processing approximately one-quarter of all transactions.

Because average transaction values are similar across banks, differences in total transaction value are primarily driven by transaction volume rather than substantially larger individual payments.

A high-volume bank can have a greater effect on overall platform performance. Even a small increase in its failure or fraud rate could affect a larger absolute number of transactions.

These findings describe the synthetic dataset and should not be interpreted as the actual UPI market shares of the named banks.

### Recommendation

- Prioritize transaction-performance monitoring for high-volume sender banks.
- Compare bank-level success, failure, and fraud rates rather than relying only on transaction counts.
- Establish volume-sensitive alerts because anomalies in larger banks may affect more customers.
- Evaluate whether transaction patterns vary by time, transaction type, device, or network for each bank.
- Avoid ranking bank quality using volume alone; operational performance requires success-rate and risk measures.

## 6.2.6 Receiver Bank Distribution

### Business Question

Which receiver banks receive the highest number and value of UPI transactions?

### Objective

To compare receiver banks based on transaction count, transaction share, total received value, and average received transaction value.

### Results

| Receiver Bank | Transaction Count | Transaction Share | Total Transaction Value | Average Transaction Value |
| ------------- | ----------------: | ----------------: | ----------------------: | ------------------------: |
| SBI           |            62,378 |            24.95% |             ₹82,565,386 |                 ₹1,323.63 |
| HDFC          |            37,651 |            15.06% |             ₹49,157,476 |                 ₹1,305.61 |
| ICICI         |            29,944 |            11.98% |             ₹39,029,938 |                 ₹1,303.43 |
| IndusInd      |            25,086 |            10.03% |             ₹32,677,495 |                 ₹1,302.62 |
| Yes Bank      |            25,009 |            10.00% |             ₹32,838,599 |                 ₹1,313.07 |
| Axis          |            24,992 |            10.00% |             ₹33,007,678 |                 ₹1,320.73 |
| PNB           |            24,802 |             9.92% |             ₹32,160,203 |                 ₹1,296.68 |
| Kotak         |            20,138 |             8.06% |             ₹26,502,234 |                 ₹1,316.03 |

### Observation

SBI receives the highest number of transactions with **62,378 transactions**, representing **24.95%** of the dataset. HDFC follows with **37,651 transactions (15.06%)**, while ICICI receives **29,944 transactions (11.98%)**.

Together, the three leading receiver banks account for **51.99%** of all received transactions.

SBI also records the largest received transaction value at approximately **₹82.57 million**. Average transaction values remain similar across banks, ranging from approximately **₹1,296.68 to ₹1,323.63**.

### Business Interpretation

The receiver-bank pattern is highly similar to the sender-bank distribution. SBI, HDFC, and ICICI are the largest banking participants on both sides of transactions in this synthetic dataset.

Because average values are relatively consistent, the differences in total received value are primarily caused by transaction volume.

Receiver-bank volume is operationally important because disruptions involving a high-volume beneficiary bank may affect a comparatively large number of payments.

These values describe the synthetic dataset and should not be interpreted as actual market-share statistics.

### Recommendation

- Monitor receiver-bank transaction success and failure rates alongside transaction volume.
- Give higher operational visibility to disruptions affecting high-volume receiving banks.
- Compare sender-to-receiver bank combinations during bivariate analysis.
- Investigate whether particular bank pairs exhibit unusual failure or fraud patterns.
- Avoid interpreting transaction count alone as an indicator of bank performance or service quality.

## 6.2.7 Sender State Distribution

### Business Question

Which states generate the highest number and value of UPI transactions?

### Objective

To compare sender states based on transaction count, transaction share, total transaction value, and average transaction value.

### Results

| Sender State   | Transaction Count | Transaction Share | Total Transaction Value | Average Transaction Value |
| -------------- | ----------------: | ----------------: | ----------------------: | ------------------------: |
| Maharashtra    |            37,427 |            14.97% |             ₹49,043,948 |                 ₹1,310.39 |
| Uttar Pradesh  |            30,125 |            12.05% |             ₹40,035,717 |                 ₹1,328.99 |
| Karnataka      |            29,756 |            11.90% |             ₹38,451,158 |                 ₹1,292.22 |
| Tamil Nadu     |            25,367 |            10.15% |             ₹33,343,518 |                 ₹1,314.44 |
| Delhi          |            24,870 |             9.95% |             ₹32,689,865 |                 ₹1,314.43 |
| Telangana      |            22,435 |             8.97% |             ₹29,750,930 |                 ₹1,326.09 |
| Gujarat        |            20,061 |             8.02% |             ₹25,988,190 |                 ₹1,295.46 |
| Andhra Pradesh |            20,006 |             8.00% |             ₹25,952,619 |                 ₹1,297.24 |
| Rajasthan      |            19,981 |             7.99% |             ₹26,730,470 |                 ₹1,337.79 |
| West Bengal    |            19,972 |             7.99% |             ₹25,952,594 |                 ₹1,299.45 |

### Observation

Maharashtra generates the highest transaction volume with **37,427 transactions**, representing **14.97%** of the dataset. Uttar Pradesh follows with **30,125 transactions (12.05%)**, while Karnataka contributes **29,756 transactions (11.90%)**.

The three leading states collectively account for **38.92%** of all transactions.

Maharashtra also generates the highest total transaction value at approximately **₹49.04 million**. Average transaction values are comparatively similar across states, ranging from **₹1,292.22 to ₹1,337.79**.

Rajasthan records the highest average transaction value at **₹1,337.79**, despite having one of the lowest transaction counts.

### Business Interpretation

The geographic distribution is relatively diversified, although Maharashtra, Uttar Pradesh, and Karnataka form the largest transaction markets in this synthetic dataset.

Maharashtra's leading total transaction value is primarily driven by its higher transaction count. Rajasthan's higher average value suggests that transaction frequency and typical transaction size should be evaluated separately.

The geographic patterns may reflect differences in population, urbanization, merchant availability, and digital-payment adoption. However, the dataset does not contain population or economic-normalization measures, so the results should not be interpreted as per-capita UPI adoption.

### Recommendation

- Prioritize operational capacity and merchant engagement in high-volume states.
- Compare state-level success, failure, and fraud rates rather than relying only on total volume.
- Normalize future geographic analysis using population or active-user data when available.
- Investigate whether transaction types and merchant categories vary across states.
- Avoid interpreting the synthetic state distribution as official UPI market-share data.

## 6.2.8 Device Type Distribution

### Business Question

Which device types are most commonly used for UPI transactions?

### Objective

To measure the distribution of transactions across device types and identify the primary channels used for UPI payments.

### Results

| Device Type | Transaction Count | Transaction Share |
| ----------- | ----------------: | ----------------: |
| Android     |           187,777 |            75.11% |
| iOS         |            49,613 |            19.85% |
| Web         |            12,610 |             5.04% |
| **Total**   |       **250,000** |       **100.00%** |

### Observation

Android is the dominant device type with **187,777 transactions**, representing **75.11%** of the dataset. iOS accounts for **49,613 transactions (19.85%)**, while Web contributes **12,610 transactions (5.04%)**.

Android and iOS collectively account for **94.96%** of all transactions. This demonstrates that transaction activity in the synthetic dataset is overwhelmingly mobile-based.

### Business Interpretation

The results reflect the mobile-first nature of UPI payments. Android alone represents approximately three out of every four transactions, making it the most operationally significant device channel in the dataset.

Although iOS has a smaller share, it still represents almost one-fifth of the transactions and remains an important platform. Web usage is comparatively limited and may represent browser-enabled or desktop payment journeys.

Because Android handles the largest transaction volume, performance degradation or technical issues affecting this channel could potentially influence a larger number of transactions.

Transaction count alone does not demonstrate whether Android, iOS, or Web provides better reliability. Device-level success, failure, and fraud rates must be compared before evaluating channel performance.

### Recommendation

- Prioritize Android application reliability, security, performance testing, and user-experience improvements.
- Maintain consistent payment functionality across Android and iOS.
- Compare transaction success, failure, and fraud rates across device types.
- Investigate whether Web transactions differ in amount, transaction type, merchant category, or fraud exposure.
- Include device-level transaction and risk metrics in operational and fraud-monitoring dashboards.
- Avoid interpreting transaction volume alone as a measure of device reliability.

## 6.2.9 Network Type Distribution

### Business Question

Which network types are most frequently used for UPI transactions?

### Objective

To analyze transaction distribution across network types and understand the connectivity channels supporting UPI activity.

### Results

| Network Type | Transaction Count | Transaction Share |
| ------------ | ----------------: | ----------------: |
| 4G           |           149,813 |            59.93% |
| 5G           |            62,582 |            25.03% |
| WiFi         |            25,134 |            10.05% |
| 3G           |            12,471 |             4.99% |

### Observation

4G is the most frequently used network type, supporting **149,813 transactions (59.93%)**. It is followed by 5G with **62,582 transactions (25.03%)**, WiFi with **25,134 transactions (10.05%)**, and 3G with **12,471 transactions (4.99%)**.

Cellular networks collectively support **89.95%** of all transactions, while WiFi accounts for the remaining 10.05%.

### Business Interpretation

The results show that transaction activity in this synthetic dataset is strongly dependent on mobile connectivity. The dominance of 4G indicates that it remains the primary network environment for UPI payments, despite increasing 5G usage.

The continued presence of 3G transactions suggests that the payment experience must remain functional under slower or less stable network conditions.

Transaction count alone does not indicate whether one network is more reliable than another. Reliability must be evaluated using network-specific success and failure rates.

### Recommendation

- Optimize transaction flows for 4G because it supports the highest transaction volume.
- Maintain lightweight and resilient payment journeys for slower network conditions.
- Compare failure and fraud rates across network types during bivariate analysis.
- Monitor whether transaction response and completion patterns change by network type.
- Avoid assuming that lower network usage automatically indicates weaker performance.

## 6.2.10 Fraud Flag Distribution

### Business Question

What proportion of transactions are labelled as fraudulent?

### Objective

To measure the distribution of normal and fraudulent transactions and determine the level of class imbalance in the fraud target.

### Results

| Fraud Flag | Category | Transaction Count | Transaction Share |
| ---------: | -------- | ----------------: | ----------------: |
|          0 | Normal   |           249,520 |           99.808% |
|          1 | Fraud    |               480 |            0.192% |
|  **Total** |          |       **250,000** |      **100.000%** |

### Class-Imbalance Assessment

| Metric                  |   Result |
| ----------------------- | -------: |
| Normal Transactions     |  249,520 |
| Fraudulent Transactions |      480 |
| Fraud Rate              |   0.192% |
| Imbalance Ratio         | 519.83:1 |

### Observation

Of the 250,000 transactions, **249,520 transactions (99.808%)** are labelled as normal, while only **480 transactions (0.192%)** are labelled as fraudulent.

There are approximately **520 normal transactions for every fraudulent transaction**, demonstrating an extreme class imbalance.

### Business Interpretation

Fraud represents a very small proportion of the dataset but may still create significant financial, operational, and reputational risk.

The extreme imbalance creates an important machine-learning challenge. A model that predicts every transaction as normal would achieve approximately **99.808% accuracy** while detecting no fraudulent transactions. Therefore, overall accuracy would be a misleading primary evaluation metric.

The low fraud frequency also means that false positives require careful control. Flagging too many legitimate transactions could increase manual-review workloads and negatively affect customer experience.

Because the dataset is synthetic, the observed fraud rate should not be interpreted as an official or real-world UPI fraud rate.

### Recommendation

- Use imbalance-aware evaluation metrics such as precision, recall, F1-score, PR-AUC, and the confusion matrix.
- Give special attention to fraud recall while monitoring the false-positive rate.
- Use stratified train-test splitting to preserve fraud representation.
- Evaluate class weighting and suitable resampling methods during model development.
- Avoid performing data resampling before splitting the dataset, as this could cause data leakage.
- Analyze fraud patterns by transaction type, amount, bank, state, device, network, merchant category, and time.
- Develop risk thresholds that balance fraud detection with customer experience and review capacity.

## 6.2.10 Fraud Flag Distribution

### Business Question

What proportion of transactions are labelled as fraudulent?

### Objective

To measure the distribution of normal and fraudulent transactions and determine the level of class imbalance in the fraud target.

### Results

| Fraud Flag | Category | Transaction Count | Transaction Share |
| ---------: | -------- | ----------------: | ----------------: |
|          0 | Normal   |           249,520 |           99.808% |
|          1 | Fraud    |               480 |            0.192% |
|  **Total** |          |       **250,000** |      **100.000%** |

### Class-Imbalance Assessment

| Metric                  |   Result |
| ----------------------- | -------: |
| Normal Transactions     |  249,520 |
| Fraudulent Transactions |      480 |
| Fraud Rate              |   0.192% |
| Imbalance Ratio         | 519.83:1 |

### Observation

Of the 250,000 transactions, **249,520 transactions (99.808%)** are labelled as normal, while only **480 transactions (0.192%)** are labelled as fraudulent.

There are approximately **520 normal transactions for every fraudulent transaction**, demonstrating an extreme class imbalance.

### Business Interpretation

Fraud represents a very small proportion of the dataset but may still create significant financial, operational, and reputational risk.

The extreme imbalance creates an important machine-learning challenge. A model that predicts every transaction as normal would achieve approximately **99.808% accuracy** while detecting no fraudulent transactions. Therefore, overall accuracy would be a misleading primary evaluation metric.

The low fraud frequency also means that false positives require careful control. Flagging too many legitimate transactions could increase manual-review workloads and negatively affect customer experience.

Because the dataset is synthetic, the observed fraud rate should not be interpreted as an official or real-world UPI fraud rate.

### Recommendation

- Use imbalance-aware evaluation metrics such as precision, recall, F1-score, PR-AUC, and the confusion matrix.
- Give special attention to fraud recall while monitoring the false-positive rate.
- Use stratified train-test splitting to preserve fraud representation.
- Evaluate class weighting and suitable resampling methods during model development.
- Avoid performing data resampling before splitting the dataset, as this could cause data leakage.
- Analyze fraud patterns by transaction type, amount, bank, state, device, network, merchant category, and time.
- Develop risk thresholds that balance fraud detection with customer experience and review capacity.

## 6.2 Univariate Analysis Summary

The univariate analysis established the individual distributions of the project's principal transaction, banking, geographic, channel, amount, outcome, and fraud variables.

### Key Findings

- P2P is the largest transaction type, contributing **44.98%** of transactions.
- Grocery is the leading merchant category with a **19.99%** share.
- The overall transaction success rate is **95.05%**, while the failure rate is **4.95%**.
- Transaction amounts are strongly right-skewed, with a median of **₹629** and a mean of **₹1,311.76**.
- The IQR method flags **8.47%** of transaction amounts as potential high-value outliers; these are not automatically errors or fraud.
- SBI has the highest sender-bank and receiver-bank transaction shares in the synthetic dataset.
- Maharashtra generates the highest sender-state transaction volume at **14.97%**.
- Mobile devices account for **94.96%** of transactions, led by Android at **75.11%**.
- Cellular networks support **89.95%** of transactions, with 4G contributing **59.93%**.
- Fraudulent transactions represent only **0.192%** of records, producing an imbalance ratio of approximately **519.83:1**.

### Analytical Implications

The univariate results provide important baseline distributions but do not establish relationships or causation. For example, a bank, device, or network with a high transaction count may also have a high number of failed or fraudulent transactions simply because it processes more activity.

The next phase must therefore compare normalized rates across variables rather than relying only on absolute counts.

### Next Step

The project will proceed to bivariate analysis to investigate relationships including:

- Transaction type versus status
- Bank versus success and failure rates
- Device and network type versus transaction outcomes
- Merchant category versus transaction amount
- Transaction amount versus fraud
- Bank, state, device, and network versus fraud rate

## 6.3 Failure-Focused Bivariate Analysis

## 6.3.1 Transaction Type vs Transaction Status

### Business Question

Which transaction types have the highest number and rate of failed transactions?

### Objective

To compare transaction outcomes across transaction types and identify segments with elevated failure rates.

### Results

| Transaction Type | Total Transactions | Successful | Failed | Success Rate | Failure Rate |
| ---------------- | -----------------: | ---------: | -----: | -----------: | -----------: |
| Recharge         |             12,527 |     11,889 |    638 |       94.91% |        5.09% |
| P2P              |            112,445 |    106,870 |  5,575 |       95.04% |        4.96% |
| P2M              |             87,660 |     83,321 |  4,339 |       95.05% |        4.95% |
| Bill Payment     |             37,368 |     35,544 |  1,824 |       95.12% |        4.88% |

**Overall failure rate: 4.95%**

### Observation

Recharge records the highest failure rate at **5.09%**, followed by P2P at **4.96%**, P2M at **4.95%**, and Bill Payment at **4.88%**.

However, P2P produces the highest absolute number of failed transactions with **5,575 failures** because it also has the largest transaction volume. P2M follows with **4,339 failed transactions**.

The difference between the highest and lowest transaction-type failure rates is only **0.21 percentage points**.

### Business Interpretation

The analysis demonstrates why both failure count and failure rate must be examined.

Recharge has the highest relative failure rate, but its smaller transaction volume limits its total operational impact. P2P has a slightly lower failure rate but contributes the largest number of failed transactions because it represents the largest transaction segment.

The failure rates are closely grouped around the overall 4.95% baseline. Therefore, transaction type alone does not appear to create a strong separation in transaction outcomes within this synthetic dataset.

Additional analysis across banks, devices, networks, transaction amounts, and time periods is required before identifying meaningful contributing patterns.

### Recommendation

- Prioritize P2P for operational monitoring because it produces the highest absolute number of failed transactions.
- Monitor Recharge because its failure rate is slightly above the overall baseline.
- Avoid concluding that Recharge has a serious performance problem based on the small percentage-point difference alone.
- Combine transaction type with bank, network, device, amount, and time dimensions in deeper analysis.
- Apply statistical testing later to determine whether observed failure-rate differences are meaningful or likely caused by sampling variation.

## 6.3.2 Merchant Category vs Transaction Status

### Business Question

Which merchant categories have the highest number and rate of failed transactions?

### Objective

To compare transaction outcomes across merchant categories and identify categories with elevated failure rates or operational impact.

### Results

| Merchant Category | Total Transactions | Successful | Failed | Success Rate | Failure Rate |
| ----------------- | -----------------: | ---------: | -----: | -----------: | -----------: |
| Education         |              7,598 |      7,199 |    399 |       94.75% |        5.25% |
| Shopping          |             29,872 |     28,353 |  1,519 |       94.91% |        5.09% |
| Grocery           |             49,966 |     47,463 |  2,503 |       94.99% |        5.01% |
| Food              |             37,464 |     35,588 |  1,876 |       94.99% |        5.01% |
| Other             |             24,828 |     23,598 |  1,230 |       95.05% |        4.95% |
| Entertainment     |             20,103 |     19,113 |    990 |       95.08% |        4.92% |
| Utilities         |             22,338 |     21,252 |  1,086 |       95.14% |        4.86% |
| Healthcare        |             12,663 |     12,051 |    612 |       95.17% |        4.83% |
| Fuel              |             25,063 |     23,859 |  1,204 |       95.20% |        4.80% |
| Transport         |             20,105 |     19,148 |    957 |       95.24% |        4.76% |

**Overall failure rate: 4.95%**

### Observation

Education records the highest failure rate at **5.25%**, followed by Shopping at **5.09%**. Grocery and Food both record a failure rate of **5.01%**.

Grocery produces the largest absolute number of failed transactions with **2,503 failures**, followed by Food with **1,876** and Shopping with **1,519**.

Transport records the lowest failure rate at **4.76%**. The difference between the highest and lowest category-level failure rates is **0.49 percentage points**.

### Business Interpretation

Education has the highest relative failure rate, but it is also the smallest merchant category by transaction volume. Its result should therefore be interpreted cautiously and validated statistically before treating it as an operational concern.

Grocery has a failure rate close to the overall baseline, but its high transaction volume causes it to generate the largest number of failures. Improvements in this category could therefore affect more transactions in absolute terms.

The relatively narrow failure-rate range suggests that merchant category alone does not strongly separate successful and failed transactions in this synthetic dataset.

### Recommendation

- Prioritize Grocery for operational-impact analysis because it produces the greatest number of failed transactions.
- Monitor Education and Shopping because their failure rates exceed the overall baseline.
- Avoid concluding that Education has a systemic problem based only on its observed percentage.
- Compare merchant categories across transaction amount, bank, device, network, and time.
- Apply a statistical test later to determine whether category-level differences are meaningful.

## 6.3.3 Sender Bank vs Transaction Status

### Business Question

How does transaction performance vary across sender banks?

### Objective

To compare transaction volume, successful transactions, failed transactions, and failure rates across sender banks and identify banks requiring operational attention.

### Findings

| Sender Bank | Total Transactions | Failed Transactions | Failure Rate |
| ----------- | -----------------: | ------------------: | -----------: |
| Yes Bank    |             24,860 |               1,269 |        5.10% |
| ICICI       |             29,769 |               1,499 |        5.04% |
| Kotak       |             20,032 |                 998 |        4.98% |
| Axis        |             25,042 |               1,239 |        4.95% |
| IndusInd    |             25,173 |               1,247 |        4.95% |
| SBI         |             62,693 |               3,095 |        4.94% |
| PNB         |             24,946 |               1,221 |        4.89% |
| HDFC        |             37,485 |               1,808 |        4.82% |

### Observation

Yes Bank recorded the highest sender-bank failure rate at **5.10%**, followed by ICICI at **5.04%**. HDFC recorded the lowest failure rate at **4.82%**.

SBI generated the highest absolute number of failed transactions, with **3,095 failures**, despite its failure rate of **4.94%** being close to the overall platform failure rate of **4.95%**. This is primarily associated with SBI’s larger transaction volume of 62,693 transactions.

The difference between the highest and lowest bank failure rates is only **0.28 percentage points**.

### Business Interpretation

Two different operational perspectives are visible:

- **Failure rate:** Yes Bank shows the highest relative failure exposure.
- **Failure count:** SBI creates the largest operational impact because it handles the highest transaction volume.

The narrow variation in failure rates suggests that sender bank alone is not a strong explanation for transaction failures. Additional dimensions such as transaction hour, network type, device type, transaction amount, and receiver bank should be examined together.

These results show associations in the synthetic dataset and do not prove that any particular bank caused the failures.

### Recommendation

- Monitor Yes Bank and ICICI because their failure rates are above the platform average.
- Prioritize SBI in operational monitoring because even a small improvement could prevent a large number of failures due to its high transaction volume.
- Investigate bank performance together with time, network, device, and receiver-bank dimensions.
- Use statistical testing later to determine whether the observed differences are meaningful rather than random variation.

## 6.3.4 Receiver Bank vs Transaction Status

### Business Question

How does transaction performance vary across receiver banks?

### Objective

To compare transaction volume, successful transactions, failed transactions, and failure rates across receiver banks and identify potential operational performance differences.

### Findings

| Receiver Bank | Total Transactions | Failed Transactions | Failure Rate |
| ------------- | -----------------: | ------------------: | -----------: |
| HDFC          |             37,651 |               1,945 |        5.17% |
| Axis          |             24,992 |               1,280 |        5.12% |
| ICICI         |             29,944 |               1,500 |        5.01% |
| SBI           |             62,378 |               3,104 |        4.98% |
| PNB           |             24,802 |               1,210 |        4.88% |
| Yes Bank      |             25,009 |               1,217 |        4.87% |
| Kotak         |             20,138 |                 951 |        4.72% |
| IndusInd      |             25,086 |               1,169 |        4.66% |

### Observation

HDFC recorded the highest receiver-bank failure rate at **5.17%**, followed by Axis at **5.12%**. IndusInd recorded the lowest failure rate at **4.66%**.

SBI produced the highest absolute number of failed transactions, with **3,104 failures**, because it processed the largest receiver-bank volume of 62,378 transactions.

The difference between the highest and lowest receiver-bank failure rates is **0.51 percentage points**, which is greater than the 0.28-percentage-point variation observed among sender banks.

### Business Interpretation

Receiver-bank performance shows slightly more variation than sender-bank performance. HDFC and Axis are above the overall platform failure rate of **4.95%**, while Kotak and IndusInd are below it.

An important finding is that HDFC recorded the lowest failure rate when acting as the sender bank but the highest rate when acting as the receiver bank. This indicates that performance should be evaluated according to transaction direction rather than assigning a single performance label to each bank.

SBI represents the largest operational impact because its high transaction volume generates the greatest number of failures, even though its failure rate is close to the platform average.

These findings represent associations in the synthetic dataset and do not establish that a receiver bank caused a transaction to fail.

### Recommendation

- Monitor HDFC and Axis receiver-bank transactions because their failure rates exceed the platform average.
- Prioritize SBI for operational improvements because its high volume produces the largest number of failed transactions.
- Analyze sender-bank and receiver-bank combinations to identify specific transaction routes with elevated failure rates.
- Combine bank information with transaction hour, network type, device type, and transaction amount.
- Validate observed differences statistically before treating them as meaningful performance gaps.

## 6.3.5 Sender State vs Transaction Status

### Business Question

How does transaction performance vary across sender states?

### Objective

To compare transaction volume, successful transactions, failed transactions, and failure rates across states and identify geographic areas requiring operational attention.

### Findings

| Sender State   | Total Transactions | Failed Transactions | Failure Rate |
| -------------- | -----------------: | ------------------: | -----------: |
| Uttar Pradesh  |             30,125 |               1,572 |        5.22% |
| Tamil Nadu     |             25,367 |               1,298 |        5.12% |
| West Bengal    |             19,972 |               1,007 |        5.04% |
| Andhra Pradesh |             20,006 |               1,000 |        5.00% |
| Delhi          |             24,870 |               1,237 |        4.97% |
| Maharashtra    |             37,427 |               1,842 |        4.92% |
| Karnataka      |             29,756 |               1,447 |        4.86% |
| Rajasthan      |             19,981 |                 958 |        4.79% |
| Gujarat        |             20,061 |                 959 |        4.78% |
| Telangana      |             22,435 |               1,056 |        4.71% |

### Observation

Uttar Pradesh recorded the highest failure rate at **5.22%**, followed by Tamil Nadu at **5.12%** and West Bengal at **5.04%**. Telangana recorded the lowest failure rate at **4.71%**.

Maharashtra generated the highest absolute number of failures, with **1,842 failed transactions**, because it also recorded the largest transaction volume. Its failure rate of **4.92%** was slightly below the overall platform rate of **4.95%**.

Uttar Pradesh produced the second-highest failure count and the highest failure rate, making it important from both relative-performance and operational-impact perspectives.

The difference between the highest and lowest state failure rates is **0.51 percentage points**.

### Business Interpretation

State-level performance shows moderate variation. Uttar Pradesh requires particular attention because its failure rate is above average while its transaction volume is also high.

Maharashtra represents a high-volume operational priority. Although its failure rate is not unusually high, even a small improvement could prevent a meaningful number of failed transactions.

Geographic differences may be associated with other factors such as network type, device usage, bank combinations, transaction timing, or transaction mix. The state itself should not be treated as the direct cause of failure.

The dataset is synthetic and covers only ten states, so these findings should be interpreted as portfolio-case evidence rather than conclusions about actual state-level UPI performance.

### Recommendation

- Prioritize Uttar Pradesh for further investigation because it combines high volume with the highest failure rate.
- Monitor Tamil Nadu because its failure rate is also materially above the platform average.
- Include Maharashtra in operational improvement initiatives because it generates the highest failure count.
- Compare state performance by network type, device type, sender bank, and transaction hour.
- Use both failure counts and failure rates in the dashboard to avoid misleading geographic comparisons.

## 6.3.6 Device Type vs Transaction Status

### Business Question

Does transaction performance vary across device types?

### Objective

To compare transaction volume, failed-transaction counts, and failure rates across Android, iOS, and Web transactions.

### Findings

| Device Type | Total Transactions | Failed Transactions | Failure Rate |
| ----------- | -----------------: | ------------------: | -----------: |
| Web         |             12,610 |                 650 |        5.15% |
| Android     |            187,777 |               9,278 |        4.94% |
| iOS         |             49,613 |               2,448 |        4.93% |

### Observation

Web transactions recorded the highest failure rate at **5.15%**, which is 0.20 percentage points above the platform failure rate of **4.95%**.

Android generated **9,278 failed transactions**, representing the largest absolute failure count. However, Android also processed 187,777 transactions, or approximately 75% of the complete dataset. Its failure rate of **4.94%** was approximately equal to the platform average.

iOS recorded the lowest failure rate at **4.93%**, although the difference between Android and iOS was only 0.01 percentage points.

The complete variation between the highest and lowest device failure rates was **0.22 percentage points**.

### Business Interpretation

Web transactions show slightly higher relative failure exposure than mobile transactions. However, the difference is modest and should be validated before concluding that the Web channel is less reliable.

Android creates the greatest operational workload because of its dominant transaction volume—not because it has an unusually high failure rate. Android and iOS exhibit nearly identical transaction performance.

Device type alone appears to provide limited separation between successful and failed transactions. Its value may become clearer when combined with network type, transaction hour, bank, or transaction amount.

### Recommendation

- Monitor the Web channel because its failure rate is moderately above the platform average.
- Prioritize Android in operational monitoring because its large volume produces most failed transactions.
- Do not interpret Android’s high failure count as evidence of weaker reliability.
- Analyze device and network combinations to identify more specific performance patterns.
- Apply statistical testing later to determine whether the Web–mobile difference is meaningful.

## 6.3.7 Network Type vs Transaction Status

### Business Question

Does transaction performance vary across network types?

### Objective

To compare transaction volume, failure counts, and failure rates across 3G, 4G, 5G, and WiFi transactions.

### Findings

| Network Type | Total Transactions | Failed Transactions | Failure Rate |
| ------------ | -----------------: | ------------------: | -----------: |
| 3G           |             12,471 |                 651 |        5.22% |
| 4G           |            149,813 |               7,464 |        4.98% |
| 5G           |             62,582 |               3,039 |        4.86% |
| WiFi         |             25,134 |               1,222 |        4.86% |

### Observation

3G recorded the highest failure rate at **5.22%**, followed by 4G at **4.98%**. Both 5G and WiFi recorded the lowest failure rate at **4.86%**.

4G generated the highest absolute number of failures, with **7,464 failed transactions**, because it processed approximately 60% of all transactions.

The difference between the highest and lowest network failure rates was **0.36 percentage points**.

### Business Interpretation

3G shows slightly higher relative failure exposure, while 4G represents the greatest operational impact because of its dominant transaction volume.

The lower failure rates observed for 5G and WiFi may indicate a performance association, but the differences are relatively small. Network type alone does not sufficiently explain transaction failures.

These results do not establish that network type caused a transaction to fail.

### Recommendation

- Monitor 3G transactions because their failure rate is above the platform average.
- Prioritize 4G operational monitoring because it generates the largest number of failures.
- Examine network type together with device, state, bank, and transaction hour.
- Validate the differences statistically before treating them as meaningful performance gaps.

## 6.3.8 Amount Band vs Transaction Status

### Business Question

Does transaction performance vary across transaction amount ranges?

### Objective

To compare transaction volume, failure counts, and failure rates across different transaction amount bands.

### Findings

| Amount Band    | Total Transactions | Failed Transactions | Failure Rate |
| -------------- | -----------------: | ------------------: | -----------: |
| Above ₹10,000  |              1,805 |                 104 |        5.76% |
| ₹5,001–₹10,000 |              9,151 |                 481 |        5.26% |
| ₹1,001–₹2,500  |             55,436 |               2,801 |        5.05% |
| ₹2,501–₹5,000  |             25,947 |               1,301 |        5.01% |
| ₹501–₹1,000    |             51,037 |               2,500 |        4.90% |
| ₹0–₹500        |            106,624 |               5,189 |        4.87% |

### Observation

Transactions above ₹10,000 recorded the highest failure rate at **5.76%**, followed by the ₹5,001–₹10,000 band at **5.26%**.

The ₹0–₹500 band recorded the lowest failure rate at **4.87%**, but generated the highest failure count of **5,189** because it contained 106,624 transactions.

The difference between the highest and lowest amount-band failure rates was **0.89 percentage points**.

### Business Interpretation

Higher-value transaction bands show greater relative failure exposure in this dataset. Transaction amount therefore appears more useful for distinguishing failure patterns than several previously examined dimensions.

However, transactions above ₹10,000 contain only 1,805 records. Their higher failure rate should therefore be interpreted cautiously and validated using additional data.

Low-value transactions create the greatest operational workload because of their much larger transaction volume.

The results show an association between amount range and transaction status but do not prove that higher amounts caused the failures.

### Recommendation

- Monitor high-value transactions because their failure rates exceed the platform average.
- Include amount band as a dashboard filter and potential failure-prediction feature.
- Prioritize low-value transactions for operational improvements because they generate the highest failure count.
- Combine amount with bank, network, device, and transaction time to identify more specific patterns.
- Do not reject or block high-value transactions based solely on this analysis.

## 6.3.9 Transaction Amount vs Transaction Status

### Business Question

Do successful and failed transactions have different amount distributions?

### Objective

To compare the central tendency and variability of transaction amounts for successful and failed transactions.

### Findings

| Metric             |    Failed | Successful |
| ------------------ | --------: | ---------: |
| Transaction Count  |    12,376 |    237,624 |
| Mean Amount        | ₹1,354.01 |  ₹1,309.56 |
| Median Amount      |   ₹636.00 |    ₹628.00 |
| Standard Deviation | ₹1,974.50 |  ₹1,841.21 |
| First Quartile     |   ₹287.00 |    ₹288.00 |
| Third Quartile     | ₹1,636.25 |  ₹1,594.00 |
| Maximum Amount     |   ₹42,099 |    ₹41,210 |

### Observation

Failed transactions recorded a mean amount of **₹1,354.01**, compared with **₹1,309.56** for successful transactions. This represents a difference of ₹44.45, or approximately 3.39%.

The median amounts were very similar: ₹636 for failed transactions and ₹628 for successful transactions.

Failed transactions also recorded a slightly higher standard deviation and third quartile, indicating somewhat greater variation in their upper-value transactions.

### Business Interpretation

The successful and failed amount distributions are broadly similar. Failed transactions have slightly higher amounts, particularly in the upper portion of the distribution, but the difference is not large enough to treat transaction amount as a standalone explanation for failure.

This supports the amount-band analysis, where high-value bands showed increased failure rates. However, transaction amount should be combined with other variables such as bank, network, device, state, and transaction time.

### Recommendation

- Retain transaction amount as a potential failure-prediction feature.
- Consider both the original amount and engineered amount bands.
- Apply a logarithmic transformation during modeling because the amount distribution is strongly right-skewed.
- Do not flag transactions solely because they have high amounts.
- Combine amount with operational and time-related variables.

## 6.3 Bivariate Analysis Summary

The bivariate analysis showed that most individual categories have only modest differences in failure rates. Transaction amount bands provided one of the clearest patterns, with higher-value transactions recording greater relative failure exposure.

High-volume segments—including SBI, Maharashtra, Android, 4G, P2P, Grocery, and low-value transactions—generated the largest failure counts primarily because they processed more transactions.

Therefore, subsequent analysis must continue considering both:

- **Failure rate**, which measures relative performance.
- **Failure count**, which measures operational impact.

No individual variable sufficiently explains transaction failures on its own. Time-based and multi-dimensional analysis are required next.

# 6.4 Time-Based Analysis

## 6.4.1 Monthly Transaction Trend

### Business Question

How do transaction volume and value change throughout 2024?

### Objective

To examine monthly transaction patterns and determine whether transaction activity changes significantly over time.

### Observation

May recorded the highest raw transaction volume with **21,333 transactions**, while February recorded the lowest with 19,759 transactions.

However, monthly totals are affected by the number of active days. After normalization:

- May recorded the highest average daily volume at **688.16 transactions**.
- November recorded the lowest average daily volume at **678.87 transactions**.
- The difference between the highest and lowest daily averages was only **9.29 transactions per day**.

Average daily transaction value ranged from approximately **₹885,700 in January** to **₹910,370 in December**.

The average value per transaction was also relatively stable, ranging from ₹1,293.85 in January to ₹1,324.09 in July.

### Business Interpretation

Transaction activity remained highly consistent throughout 2024. No strong upward, downward, or seasonal volume trend is visible in the synthetic dataset.

February’s lower monthly total was primarily associated with its smaller number of calendar days rather than materially weaker daily activity.

December contains only 30 active days because the dataset ends on December 30. This limitation must be considered when comparing its raw total with complete months.

### Recommendation

- Use raw monthly totals for operational workload and reporting.
- Use average daily activity when comparing performance between months.
- Maintain relatively stable transaction-processing capacity throughout the year.
- Avoid claiming seasonal growth or decline from the small differences observed.
- Examine monthly failure rates next to determine whether transaction performance changes even when volume remains stable.

## 6.4.2 Monthly Failure Trend

### Business Question

How do transaction failure counts and failure rates change across months?

### Objective

To identify months with elevated transaction failure performance while accounting for differences in the number of active days.

### Observation

March recorded the highest monthly failure rate at **5.38%**, followed by September at **5.15%**. March also generated the highest average daily failure count at **36.84 failures per day**.

October recorded the lowest failure rate at **4.74%**, followed by January at **4.77%**.

The difference between the highest and lowest monthly failure rates was **0.64 percentage points**.

Monthly transaction volumes remained relatively stable, but failure rates showed more noticeable variation. No continuous upward or downward failure trend was observed.

### Business Interpretation

March represents the clearest monthly performance concern because its failure rate and average daily failure count were both elevated.

September also recorded an above-average failure rate. These increases were not explained solely by higher transaction volume because normalized monthly activity remained stable.

However, the dataset does not provide detailed failure reasons. Therefore, the analysis identifies time periods associated with elevated failures but cannot establish their operational cause.

### Recommendation

- Prioritize March and September for more detailed segment analysis.
- Compare these months by bank, network, device, transaction type, and hour.
- Use the overall failure rate of 4.95% as a dashboard reference line.
- Monitor both failure rate and average daily failure count.
- Avoid interpreting isolated monthly differences as a permanent trend without additional historical data.

## 6.4.3 Day-of-Week Analysis

### Business Question

Does transaction activity and failure performance vary across days of the week?

### Objective

To compare normalized daily transaction volume, average daily failures, and failure rates across weekdays.

### Observation

Sunday recorded the highest average daily transaction volume at **692.37 transactions**, followed by Monday at 688.58. Saturday recorded the lowest average daily volume at 679.50.

Sunday also recorded the highest failure rate at **5.10%** and the highest average daily failure count at 35.29. Saturday followed with a failure rate of **5.09%**.

Friday recorded the lowest failure rate at **4.77%**, followed by Tuesday at 4.79%.

The difference between the highest and lowest weekday failure rates was **0.33 percentage points**.

### Business Interpretation

Transaction activity is distributed relatively evenly throughout the week. The difference between the highest and lowest normalized daily volume is small.

Weekend days show slightly higher failure rates than most weekdays. However, the variation is modest and does not establish that weekend timing caused transaction failures.

A separate weekend-versus-weekday comparison is required to confirm whether the combined weekend pattern remains visible.

### Recommendation

- Maintain consistent transaction-processing capacity throughout the week.
- Monitor Sunday because it combines the highest daily volume and highest failure rate.
- Compare weekend and weekday performance as grouped periods.
- Examine weekend failures by hour, network, bank, and device.
- Avoid making operational decisions based solely on the small weekday differences.

## 6.4.4 Hour-of-Day Analysis

### Business Question

At which hours do transaction activity and failure rates peak?

### Objective

To identify high-traffic hours and determine whether particular hours experience elevated transaction failure rates.

### Observation

Transaction activity was lowest during the early morning and increased substantially from approximately 8 AM.

The highest transaction volume occurred at **7 PM**, with 21,232 transactions and an average of 58.17 transactions per day. Activity was also high between 5 PM and 8 PM.

The highest failure rate occurred at **6 AM (5.40%)**, followed by midnight at 5.37% and 1 AM at 5.35%. These hours contained relatively low transaction volumes.

At 7 PM, the failure rate was **5.15%**, and the hour generated the highest failure count of 1,093 transactions.

The difference between the highest and lowest hourly failure rates was **0.86 percentage points**.

### Business Interpretation

The early-morning hours recorded the highest relative failure rates but produced a limited number of failures because transaction activity was low.

The 7 PM period represents the most important operational priority because it combines the highest transaction volume, the highest failure count, and an above-average failure rate.

This demonstrates why both failure count and failure rate must be considered. A low-volume period may have a high rate, while a peak period may create greater overall customer impact.

The analysis identifies time associations but does not establish why failures occurred during those hours.

### Recommendation

- Prioritize monitoring and system capacity between 5 PM and 8 PM.
- Investigate 7 PM transactions by bank, network, device, state, and amount band.
- Monitor early-morning failure rates, but interpret them cautiously because of their lower volumes.
- Use hourly failure-rate thresholds and failure-count alerts in the dashboard.
- Compare day-and-hour combinations using a heatmap.

## 6.4.5 Weekday vs Weekend Analysis

### Business Question

Does transaction activity and failure performance differ between weekdays and weekends?

### Objective

To compare normalized transaction volume, average daily failures, and failure rates between weekday and weekend periods.

### Findings

| Day Type | Active Days | Average Daily Transactions | Average Daily Failures | Failure Rate |
| -------- | ----------: | -------------------------: | ---------------------: | -----------: |
| Weekday  |         261 |                     684.53 |                  33.50 |        4.89% |
| Weekend  |         104 |                     685.93 |                  34.92 |        5.09% |

### Observation

Weekend average daily transaction volume was **685.93**, compared with 684.53 on weekdays. The difference was only 1.40 transactions per day.

Weekend transactions recorded a failure rate of **5.09%**, compared with **4.89%** for weekdays.

Average daily failures were also higher during weekends: 34.92 compared with 33.50 on weekdays.

### Business Interpretation

Transaction activity remains almost identical between weekdays and weekends. Therefore, weekend failure differences are not explained by substantially higher transaction volume.

The weekend failure rate is 0.20 percentage points above the weekday rate. This supports the earlier finding that Saturday and Sunday recorded slightly elevated failure rates.

However, the difference remains modest and does not prove that weekend timing caused the failures.

### Recommendation

- Maintain similar processing capacity during weekdays and weekends.
- Apply slightly closer transaction-performance monitoring during weekends.
- Investigate weekend performance by hour, network, device, and bank.
- Use a day-and-hour heatmap to identify more specific periods requiring attention.
- Validate the weekend difference statistically before treating it as a persistent operational issue.
