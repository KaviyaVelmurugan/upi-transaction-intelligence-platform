# 13. Exploratory Data Analysis (EDA)

## 1. Objective

The objective of Exploratory Data Analysis (EDA) is to understand the characteristics of the UPI transaction dataset by identifying patterns, trends, relationships, and anomalies. The insights obtained from this phase will support business decision-making, SQL analytics, Power BI dashboard development, and fraud detection modeling.

---

# 2. Dataset Overview

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
