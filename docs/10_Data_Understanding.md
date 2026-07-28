# 10. Data Understanding

## 1. Objective

The objective of this phase is to understand the structure, contents, and business relevance of the selected dataset before performing any data cleaning or analysis.

---

## 2. Dataset Information

| Attribute     | Value                                                                         |
| ------------- | ----------------------------------------------------------------------------- |
| Dataset Name  | Github dataset_1.xlsx                                                         |
| Dataset Type  | Synthetic UPI Transaction Dataset                                             |
| Total Records | 20,000                                                                        |
| Total Columns | 20                                                                            |
| Primary Use   | Transaction Analytics, Business Intelligence, SQL, Power BI, Machine Learning |
| Selected As   | Primary Dataset                                                               |

---

## 3. Column Dictionary

| Column           | Description                            | Data Type   | Business Importance |
| ---------------- | -------------------------------------- | ----------- | ------------------- |
| TransactionID    | Unique identifier for each transaction | String      | High                |
| TransactionDate  | Date of transaction                    | Date        | High                |
| Amount           | Transaction amount                     | Numeric     | High                |
| BankNameSent     | Sender bank                            | Categorical | High                |
| BankNameReceived | Receiver bank                          | Categorical | High                |
| RemainingBalance | Account balance after transaction      | Numeric     | Medium              |
| ...              | ...                                    | ...         | ...                 |

---

## 4. Data Categories

### Numerical Columns

- Amount
- RemainingBalance
- CustomerAge

### Categorical Columns

- Status
- PaymentMethod
- TransactionType
- DeviceType
- Gender
- City
- BankNameSent
- BankNameReceived
- MerchantName
- Purpose
- PaymentMode
- Currency

### Date & Time Columns

- TransactionDate
- TransactionTime

---

## 5. Initial Observations

### Strengths

- Contains rich transaction-level information.
- Suitable for SQL queries and dashboard development.
- Includes customer, bank, merchant, payment, and time dimensions.
- Large enough (20,000 records) for meaningful analysis.

### Limitations

- No explicit failure reason column.
- Synthetic dataset.
- Contains account numbers that will not be used for business analysis.
- Currency values should be verified for consistency.

---

## 6. Conclusion

The dataset provides sufficient information for transaction analytics, business intelligence, SQL analysis, and visualization. Although it lacks detailed failure reasons, it is suitable for identifying transaction patterns and generating business insights.
