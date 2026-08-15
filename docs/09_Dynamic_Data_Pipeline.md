# 15. Dynamic Data Pipeline

## 1. Purpose

The original 250,000-row dataset remains the validated baseline, but it is no longer treated as the platform's permanent final state. This architecture allows later transaction batches to enter PostgreSQL without recreating notebooks, tables, SQL analytics, or Power BI visuals.

## 2. Architecture

```text
Validated incoming CSV
        |
        v
scripts/ingest_transactions.py
        |
        v
public.upi_transactions_staging
        |
        v
merge_upi_transactions_from_staging()
        |
        +--> New Transaction ID ----> INSERT
        +--> Changed existing ID ---> UPDATE
        +--> Unchanged existing ID -> SKIP
        |
        v
public.upi_transactions
        |
        v
Reusable PostgreSQL views
        |
        v
Power BI Import refresh or DirectQuery
```

## 3. Stable Production Schema

The production table remains `public.upi_transactions` and retains exactly the 17 columns in the cleaned dataset. No invented business fields were added.

`transaction_id` remains the primary key. It prevents the same transaction from being stored more than once.

Supporting pipeline metadata is stored separately in:

- `public.upi_transactions_staging`
- `public.ingestion_batches`
- `public.vw_ingestion_history`

## 4. One-Time Upgrade Setup

Start Docker and connect pgAdmin to the existing database:

```powershell
docker start upi-postgres
```

In pgAdmin, run the following files once and in this order:

```text
sql/schema.sql
sql/ingestion.sql
sql/views.sql
```

These scripts do not remove or rebuild the existing production table. The validated 250,000 records remain available.

Install the ingestion dependency from the project root:

```powershell
python -m pip install -r requirements.txt
```

## 5. Incoming File Contract

Every new CSV must use this exact header and order:

```text
transaction_id,timestamp,transaction_type,merchant_category,amount_inr,transaction_status,sender_age_group,receiver_age_group,sender_state,sender_bank,receiver_bank,device_type,network_type,fraud_flag,hour_of_day,day_of_week,is_weekend
```

Place new files in:

```text
data/incoming/
```

Incoming data files are intentionally excluded from Git. Only `.gitkeep` is committed.

## 6. Repeatable Ingestion

From the project root, run:

```powershell
python scripts/ingest_transactions.py --file "data/incoming/new_transactions.csv"
```

The script asks for the local PostgreSQL password if `UPI_DB_PASSWORD` is not already defined.

For a non-database header check:

```powershell
python scripts/ingest_transactions.py --file "data/incoming/new_transactions.csv" --dry-run
```

For scheduled or unattended operation, provide database settings through environment variables described in `.env.example`. Never commit the real password.

## 7. Upsert Behaviour

The merge performs the following decisions using `transaction_id`:

| Incoming condition | Database action |
|---|---|
| New ID | Insert transaction |
| Existing ID with changed values | Update transaction |
| Existing ID with identical values | Skip as unchanged |
| Repeated ID within one incoming file | Keep the latest timestamp/row |

The pipeline does not delete production transactions.

Re-loading the original processed CSV is a useful idempotency test. The expected result is approximately:

```text
inserted_rows  : 0
updated_rows   : 0
unchanged_rows : 250,000
```

## 8. Ingestion Verification

After each batch, run:

```sql
SELECT *
FROM public.vw_ingestion_history
ORDER BY processed_at DESC;
```

Then verify current platform totals:

```sql
SELECT *
FROM public.vw_transaction_overview;
```

Only after successful verification should the source file be moved from `data/incoming/` to the local `data/archive/` folder.

## 9. Reusable Power BI Views

| View | Power BI purpose |
|---|---|
| `vw_transaction_overview` | KPI cards |
| `vw_bank_performance` | Sender/receiver bank comparisons |
| `vw_daily_transaction_health` | Daily volume, value, success, and failure trend |
| `vw_hourly_failure_analysis` | Peak-hour and hourly-failure visuals |
| `vw_merchant_performance` | Merchant category intelligence |
| `vw_device_network_performance` | Device and network comparisons |
| `vw_daily_failure_alerts` | Operational trend and spike monitoring |
| `vw_ingestion_history` | Pipeline audit and data freshness |

Regular PostgreSQL views are not static exports. Their queries run against current production data whenever they are selected.

## 10. Power BI Refresh Behaviour

### Import mode

Power BI stores a copy of view results in its model. After a new batch is ingested, refresh the model to retrieve current PostgreSQL results.

### DirectQuery mode

Power BI sends queries to PostgreSQL when report visuals are used or refreshed. The PostgreSQL container must be running and reachable.

For a report published to Power BI Service while PostgreSQL remains on this local computer, an on-premises data gateway is required. Credentials and gateway configuration must remain outside GitHub.

## 11. Operational Runbook

```text
1. Start Docker container
2. Place validated CSV in data/incoming
3. Run ingestion script
4. Review vw_ingestion_history
5. Review vw_transaction_overview
6. Move successful source file to local archive
7. Refresh Power BI Import model, or open the DirectQuery report
```

## 12. Compatibility with Completed Work

Phases 1–6 were not rewritten. The completed EDA notebooks remain the baseline study of the original dataset.

The original Phase 7 files `01` through `04` were preserved. The new SQL layer reorganises future operational analytics around the same real 17-column schema and adds repeatable ingestion and reusable views.
