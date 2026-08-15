# 10. Data Understanding

## 1. Objective

The objective of this phase is to understand the structure, contents, quality, and business relevance of the selected UPI transaction dataset before performing data cleaning, exploratory data analysis (EDA), SQL analysis, dashboard development, and machine learning.

Understanding the dataset helps identify important business attributes, potential data quality issues, and opportunities for generating meaningful insights.

---

# 2. Dataset Information

| Attribute     | Value                                                                                          |
| ------------- | ---------------------------------------------------------------------------------------------- |
| Dataset Name  | upi_transactions_2024.csv                                                                      |
| Dataset Type  | Synthetic UPI Transaction Dataset                                                              |
| Source        | Kaggle                                                                                         |
| Total Records | 250,000                                                                                        |
| Total Columns | 17                                                                                             |
| File Format   | CSV                                                                                            |
| Primary Use   | Transaction Analytics, Fraud Detection, Business Intelligence, SQL, Power BI, Machine Learning |
| Selected As   | Primary Dataset                                                                                |

---

# 3. Dataset Overview

The dataset contains synthetic UPI transaction records representing digital payment activities across multiple Indian states. Each record represents one UPI transaction and includes transaction details, customer demographics, banking information, merchant information, transaction status, device details, network information, and fraud indicators.

The dataset is designed to simulate real-world UPI transactions and is suitable for end-to-end data analytics and machine learning projects.

---

# 4. Column Dictionary

| Column             | Description                                                | Data Type                            | Business Importance |
| ------------------ | ---------------------------------------------------------- | ------------------------------------ | ------------------- |
| transaction id     | Unique identifier for each transaction                     | Object                               | High                |
| timestamp          | Date and time when the transaction occurred                | Object (To be converted to Datetime) | High                |
| transaction type   | Type of UPI transaction (P2P, P2M, etc.)                   | Object                               | High                |
| merchant_category  | Category of merchant receiving the payment                 | Object                               | High                |
| amount (INR)       | Transaction amount in Indian Rupees                        | Integer                              | High                |
| transaction_status | Indicates whether the transaction was successful or failed | Object                               | High                |
| sender_age_group   | Age group of the sender                                    | Object                               | Medium              |
| receiver_age_group | Age group of the receiver                                  | Object                               | Medium              |
| sender_state       | State of the sender                                        | Object                               | High                |
| sender_bank        | Bank used by the sender                                    | Object                               | High                |
| receiver_bank      | Bank used by the receiver                                  | Object                               | High                |
| device_type        | Device used for the transaction                            | Object                               | Medium              |
| network_type       | Internet network used during transaction                   | Object                               | Medium              |
| fraud_flag         | Indicates fraudulent transaction (0 = Normal, 1 = Fraud)   | Integer                              | High                |
| hour_of_day        | Hour in which transaction occurred                         | Integer                              | Medium              |
| day_of_week        | Day on which transaction occurred                          | Object                               | Medium              |
| is_weekend         | Indicates whether transaction occurred during weekend      | Integer                              | Medium              |

---

# 5. Data Categories

## Numerical Columns

- amount (INR)
- fraud_flag
- hour_of_day
- is_weekend

---

## Categorical Columns

- transaction id
- transaction type
- merchant_category
- transaction_status
- sender_age_group
- receiver_age_group
- sender_state
- sender_bank
- receiver_bank
- device_type
- network_type
- day_of_week

---

## Date & Time Columns

- timestamp

---

# 6. Initial Data Inspection

The dataset was initially inspected using the following Pandas functions:

```python
df.head()
df.info()
df.describe(include="all")
df.columns
df.shape
```

### Initial Findings

| Observation         | Result                                               |
| ------------------- | ---------------------------------------------------- |
| Total Records       | 250,000                                              |
| Total Columns       | 17                                                   |
| Missing Values      | No missing values detected during initial inspection |
| Numeric Columns     | 4                                                    |
| Categorical Columns | 13                                                   |
| Timestamp Data Type | Stored as Object                                     |
| Dataset Quality     | Good                                                 |

---

# 7. Business Importance of the Dataset

This dataset enables analysis across multiple business dimensions including:

- UPI transaction volume analysis
- Transaction amount analysis
- Customer demographic analysis
- Merchant category analysis
- Banking transaction analysis
- Device usage analysis
- Network performance analysis
- State-wise transaction trends
- Weekend vs Weekday transaction behavior
- Fraud detection analysis

The availability of these attributes makes the dataset highly suitable for business intelligence and financial analytics.

---

# 8. Strengths

- Large dataset containing 250,000 transaction records.
- No missing values identified during initial inspection.
- Includes fraud indicators for machine learning applications.
- Covers multiple business dimensions including customer, merchant, banking, geography, device, and time.
- Suitable for SQL querying and Power BI dashboard development.
- Supports predictive analytics and fraud detection.

---

# 9. Limitations

- The dataset is synthetic and does not represent actual customer transactions.
- Customer identifiers are anonymized.
- Timestamp is currently stored as an object and requires conversion to datetime format.
- No detailed transaction failure reason is provided.
- Customer financial history is not available.

---

# 10. Planned Preprocessing

The following preprocessing steps will be performed before analysis:

- Convert timestamp to datetime format.
- Verify duplicate records.
- Validate missing values.
- Check data consistency.
- Verify categorical values.
- Validate numerical ranges.
- Prepare data for SQL analysis.
- Prepare data for Power BI dashboard.
- Prepare features for machine learning.

---

# 11. Expected Business Insights

The dataset is expected to answer several important business questions, such as:

- Which transaction type is used most frequently?
- Which merchant category generates the highest transaction volume?
- Which banks process the largest number of transactions?
- Which states perform the highest number of UPI transactions?
- Which age groups use UPI the most?
- What are the peak transaction hours?
- Does transaction behavior differ on weekends?
- Which factors are associated with fraudulent transactions?
- Which device type is most commonly used for digital payments?

---

# 12. Conclusion

The selected UPI Transactions 2024 dataset provides a comprehensive foundation for developing an end-to-end FinTech analytics project. Its large volume of transaction records, clean structure, and diverse business attributes make it highly suitable for transaction analytics, SQL querying, dashboard development, business intelligence reporting, and fraud detection using machine learning.

This dataset aligns well with the objectives of the **UPI Transaction Intelligence Platform** and will serve as the primary data source throughout the project lifecycle.
