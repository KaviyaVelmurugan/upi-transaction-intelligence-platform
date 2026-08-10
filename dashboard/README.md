# Power BI Connection Guide

## PostgreSQL connection

In Power BI Desktop:

1. Select **Get data**.
2. Choose **PostgreSQL database**.
3. Enter server `127.0.0.1:5433`.
4. Enter database `upi_transaction_intelligence`.
5. Choose **Import** or **DirectQuery**.
6. Authenticate with the local PostgreSQL database user.
7. Select the `vw_...` views from the `public` schema.

Do not connect Power BI to manually exported SQL-result CSV files. The PostgreSQL views are the refreshable reporting layer.

## Recommended starting model

- KPI cards: `vw_transaction_overview`
- Bank page: `vw_bank_performance`
- Time page: `vw_daily_transaction_health`, `vw_hourly_failure_analysis`
- Merchant page: `vw_merchant_performance`
- Device/network page: `vw_device_network_performance`
- Operations page: `vw_daily_failure_alerts`
- Data freshness card: `vw_ingestion_history`

## Refresh choice

- **Import** is simpler and faster for this portfolio-sized dataset. Refresh after ingestion.
- **DirectQuery** demonstrates current-source querying and is appropriate for an operational monitoring version of the report.

When publishing a report that connects to PostgreSQL running locally in Docker, configure an on-premises data gateway in Power BI Service.
