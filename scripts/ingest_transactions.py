"""Load a UPI transaction CSV into PostgreSQL through staging and upsert.

The script never deletes production transactions. It truncates only the staging
table, copies the incoming batch, and calls the PostgreSQL merge function.
"""

from __future__ import annotations

import argparse
import csv
import getpass
import os
from pathlib import Path

EXPECTED_COLUMNS = [
    "transaction_id",
    "timestamp",
    "transaction_type",
    "merchant_category",
    "amount_inr",
    "transaction_status",
    "sender_age_group",
    "receiver_age_group",
    "sender_state",
    "sender_bank",
    "receiver_bank",
    "device_type",
    "network_type",
    "fraud_flag",
    "hour_of_day",
    "day_of_week",
    "is_weekend",
]


COPY_SQL = """
COPY public.upi_transactions_staging (
    transaction_id,
    timestamp,
    transaction_type,
    merchant_category,
    amount_inr,
    transaction_status,
    sender_age_group,
    receiver_age_group,
    sender_state,
    sender_bank,
    receiver_bank,
    device_type,
    network_type,
    fraud_flag,
    hour_of_day,
    day_of_week,
    is_weekend
)
FROM STDIN
WITH (FORMAT CSV, HEADER TRUE)
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Append or update UPI transactions in PostgreSQL."
    )
    parser.add_argument("--file", required=True, type=Path, help="Incoming CSV path")
    parser.add_argument(
        "--source-label",
        help="Optional label stored in ingestion history; defaults to filename",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Validate the file header without connecting to PostgreSQL",
    )
    return parser.parse_args()


def validate_csv(csv_path: Path) -> None:
    if not csv_path.is_file():
        raise FileNotFoundError(f"Incoming CSV not found: {csv_path}")

    with csv_path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.reader(handle)
        header = next(reader, None)

    if header != EXPECTED_COLUMNS:
        raise ValueError(
            "CSV columns do not match the production schema.\n"
            f"Expected: {EXPECTED_COLUMNS}\n"
            f"Observed: {header}"
        )


def database_settings() -> dict[str, object]:
    password = os.getenv("UPI_DB_PASSWORD")
    if not password:
        password = getpass.getpass("PostgreSQL password for upi_admin: ")

    return {
        "host": os.getenv("UPI_DB_HOST", "127.0.0.1"),
        "port": int(os.getenv("UPI_DB_PORT", "5433")),
        "dbname": os.getenv("UPI_DB_NAME", "upi_transaction_intelligence"),
        "user": os.getenv("UPI_DB_USER", "upi_admin"),
        "password": password,
    }


def load_batch(csv_path: Path, source_label: str) -> dict[str, int]:
    try:
        import psycopg
        from psycopg.rows import dict_row
    except ModuleNotFoundError as exc:
        raise RuntimeError(
            "PostgreSQL driver not installed. Run: "
            "python -m pip install -r requirements.txt"
        ) from exc

    with psycopg.connect(**database_settings(), row_factory=dict_row) as connection:
        with connection.cursor() as cursor:
            # Staging is disposable; production data is never truncated.
            cursor.execute(
                "TRUNCATE TABLE public.upi_transactions_staging RESTART IDENTITY"
            )

            with csv_path.open("r", encoding="utf-8-sig", newline="") as handle:
                with cursor.copy(COPY_SQL) as copy:
                    while chunk := handle.read(1024 * 1024):
                        copy.write(chunk)

            cursor.execute(
                "SELECT * FROM public.merge_upi_transactions_from_staging(%s)",
                (source_label,),
            )
            result = cursor.fetchone()

        connection.commit()

    if result is None:
        raise RuntimeError("The merge function returned no ingestion summary.")

    return dict(result)


def main() -> None:
    args = parse_args()
    csv_path = args.file.expanduser().resolve()
    validate_csv(csv_path)

    if args.dry_run:
        print(f"Validation passed: {csv_path}")
        return

    source_label = args.source_label or csv_path.name
    summary = load_batch(csv_path, source_label)

    print("Ingestion completed successfully")
    for metric, value in summary.items():
        print(f"{metric:28}: {value:,}")


if __name__ == "__main__":
    main()
