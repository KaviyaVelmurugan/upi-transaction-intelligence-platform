# Power BI Dashboard Requirements

## 8.1 Dashboard Requirements and Page Planning

### Project

**UPI Transaction Operational Intelligence Platform**

### Purpose

The purpose of the Power BI dashboard is to provide management and operational teams with a dynamic view of UPI transaction performance, failure behaviour, fraud indicators and operational risks.

The dashboard will connect directly to the PostgreSQL analytical views created during Phase 7.

---

## Target Users

| User               | Requirement                                     |
| ------------------ | ----------------------------------------------- |
| Management         | Monitor high-level business KPIs                |
| Product Manager    | Understand transaction adoption and performance |
| Operations Team    | Identify failure spikes and service issues      |
| Banking Operations | Compare sender and receiver-bank performance    |
| Fraud Team         | Monitor fraud volume and fraud rates            |
| Business Analyst   | Investigate trends and recommend improvements   |

---

## Connection Architecture

| Component        | Selection                      |
| ---------------- | ------------------------------ |
| Data source      | PostgreSQL                     |
| Database         | `upi_transaction_intelligence` |
| Server           | `127.0.0.1:5433`               |
| Connection mode  | DirectQuery                    |
| Data preparation | PostgreSQL SQL views           |
| Dashboard tool   | Microsoft Power BI Desktop     |

---

## Power BI Data Sources

| SQL View                        | Dashboard Purpose                       |
| ------------------------------- | --------------------------------------- |
| `vw_transaction_overview`       | Executive KPI cards                     |
| `vw_daily_transaction_health`   | Daily transaction and failure trends    |
| `vw_hourly_failure_analysis`    | Hourly performance analysis             |
| `vw_bank_performance`           | Sender and receiver-bank comparison     |
| `vw_merchant_performance`       | Merchant category performance           |
| `vw_device_network_performance` | Device and network analysis             |
| `vw_daily_failure_alerts`       | Operational failure-spike monitoring    |
| `vw_ingestion_history`          | Data ingestion and freshness monitoring |

---

## Dashboard Pages

### Page 1 – Executive Overview

Displays:

- Total transactions
- Successful transactions
- Failed transactions
- Success rate
- Failure rate
- Total transaction value
- Average transaction value
- Fraud transactions
- Fraud rate
- Latest available transaction timestamp

### Page 2 – Transaction Health

Displays:

- Daily transaction trend
- Daily failure-rate trend
- Hourly transaction volume
- Hourly failure rate
- Peak transaction periods
- Failure-spike dates

### Page 3 – Bank Performance

Displays:

- Sender-bank transaction volume
- Receiver-bank transaction volume
- Bank-wise success and failure rates
- Bank operational performance comparison
- Highest-failure-rate banks
- Fraud rate by bank

### Page 4 – Merchant and Channel Intelligence

Displays:

- Merchant category volume
- Merchant category failure rate
- Merchant category fraud rate
- Device-wise performance
- Network-wise performance
- Highest-risk merchant and channel categories

### Page 5 – Operational Monitoring

Displays:

- Daily failure alerts
- Rolling average failure rate
- Upper control limit
- Weekly failure-rate change
- Ingestion batch status
- Inserted, updated and unchanged transaction counts
- Latest successful data ingestion

---

## Dashboard Filters

Where supported by the selected SQL view, users should be able to filter by:

- Date
- Bank role
- Bank name
- Merchant category
- Device or network dimension
- Failure-spike status

---

## Design Requirements

- Use a clean financial-services visual style.
- Display percentages consistently to two decimal places.
- Display transaction values using Indian currency formatting.
- Use green for successful performance.
- Use red for failures and operational alerts.
- Use amber for warnings.
- Keep the number of visuals on each page manageable.
- Include clear chart titles and business-friendly labels.
- Avoid decorative charts that do not answer a business question.

---

## Success Criteria

Phase 8 will be considered successful when:

- Power BI connects successfully to PostgreSQL.
- All required SQL views are accessible.
- Dashboard KPIs match the validated SQL results.
- New database records can appear after report refresh.
- Failure spikes are clearly highlighted.
- Dashboard pages support operational decision-making.
- The final PBIX file and dashboard screenshots are stored in the GitHub repository.
