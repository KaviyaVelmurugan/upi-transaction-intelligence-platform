# Dataset Selection Criteria

## Purpose

This document defines the criteria used to evaluate and select a suitable public dataset for the UPI Transaction Intelligence Platform project.

The selected dataset should support analysis of transaction failures, identify transaction failure patterns, and enable anomaly detection.

---

# 1. Must Have (Mandatory)

The dataset must contain the following fields:

| Field              | Purpose                                   |
| ------------------ | ----------------------------------------- |
| Transaction ID     | Unique identification of each transaction |
| Transaction Date   | Trend and time-series analysis            |
| Transaction Status | Success / Failure analysis                |
| Failure Reason     | Root pattern analysis                     |
| Bank               | Bank-wise transaction analysis            |

Datasets that do not contain most of these mandatory fields will not be selected.

---

# 2. Should Have (Recommended)

These fields strengthen the analytical capabilities of the project.

- Transaction Time
- Transaction Amount
- Transaction Type
- Payment Method
- Device Type
- Customer Location

---

# 3. Nice to Have (Optional)

These fields may improve future project enhancements.

- Merchant Information
- Customer Segment
- Device Model
- Operating System
- Geographic Region

---

# 4. Dataset Evaluation Criteria

Each candidate dataset will be evaluated based on:

- Business relevance
- Data completeness
- Availability of mandatory fields
- Data quality
- Historical coverage
- Public availability
- License for educational and portfolio use

---

# 5. Dataset Selection Principle

The selected dataset should best support the business problem defined in the BRD rather than simply containing the highest number of fields.

Datasets will be compared systematically before the final dataset is selected.

---

# 6. Future Enhancements

If suitable complementary datasets are available and can be reliably integrated using common identifiers, they may be considered for future versions of the project after evaluating data compatibility and quality.
