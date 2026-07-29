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
