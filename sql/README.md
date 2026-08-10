# SQL Analytics Execution Guide

The original numbered Phase 7 scripts remain available as evidence of the completed learning workflow. The dynamic layer is additive and does not invalidate them.

## One-time deployment order

Run these scripts in pgAdmin against `upi_transaction_intelligence`:

1. `schema.sql` — production table, staging table, ingestion audit, indexes
2. `ingestion.sql` — repeatable Transaction-ID upsert function
3. `views.sql` — live analytical views for SQL and Power BI

The existing production table and its 250,000 records are preserved because the schema uses `CREATE TABLE IF NOT EXISTS`.

## Reusable business-query modules

| File | Purpose |
|---|---|
| `transaction_overview.sql` | Executive counts, rates, values, status, and transaction type |
| `bank_performance.sql` | Sender/receiver performance, rankings, and investigation flags |
| `time_analysis.sql` | Daily, monthly, hourly, weekday, weekend, and peak-period analysis |
| `merchant_analysis.sql` | Merchant volume, value, failure rate, and risk screening |
| `device_network_analysis.sql` | Device/network reliability and ranking |
| `operational_intelligence.sql` | Period change, spikes, degrading banks, and abnormal combinations |

## Preserved completed work

The following files are retained unchanged:

- `01_database_setup.sql`
- `02_data_quality_validation.sql`
- `03_core_business_kpis.sql`
- `04_dimensional_analysis.sql`

They document how the original dataset was validated and analysed. New modular scripts query the same stable `public.upi_transactions` table and therefore update when new records are ingested.
