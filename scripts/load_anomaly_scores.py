"""Load anomaly scores into PostgreSQL using repeatable upsert logic."""

from __future__ import annotations

import argparse
import csv
import getpass
import os
from pathlib import Path


EXPECTED_COLUMNS = [
    "transaction_id",
    "anomaly_score",
    "anomaly_risk_band",
    "is_anomaly",
    "model_version",
    "scored_at",
]


COPY_SQL = """
COPY anomaly_scores_staging (
    transaction_id,
    anomaly_score,
    anomaly_risk_band,
    is_anomaly,
    model_version,
    scored_at
)
FROM STDIN
WITH (
    FORMAT CSV,
    HEADER TRUE
)
"""


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Load or update transaction anomaly scores "
            "in PostgreSQL."
        )
    )

    parser.add_argument(
        "--file",
        required=True,
        type=Path,
        help="Path to anomaly_scores.csv",
    )

    return parser.parse_args()


def validate_csv(csv_path: Path) -> None:
    if not csv_path.is_file():
        raise FileNotFoundError(
            f"Anomaly-score CSV not found: {csv_path}"
        )

    with csv_path.open(
        "r",
        encoding="utf-8-sig",
        newline=""
    ) as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader, None)

    if header != EXPECTED_COLUMNS:
        raise ValueError(
            "CSV columns do not match the expected schema.\n"
            f"Expected: {EXPECTED_COLUMNS}\n"
            f"Observed: {header}"
        )


def database_settings() -> dict[str, object]:
    password = os.getenv("UPI_DB_PASSWORD")

    if not password:
        password = getpass.getpass(
            "PostgreSQL password for upi_admin: "
        )

    return {
        "host": os.getenv(
            "UPI_DB_HOST",
            "127.0.0.1"
        ),
        "port": int(
            os.getenv(
                "UPI_DB_PORT",
                "5433"
            )
        ),
        "dbname": os.getenv(
            "UPI_DB_NAME",
            "upi_transaction_intelligence"
        ),
        "user": os.getenv(
            "UPI_DB_USER",
            "upi_admin"
        ),
        "password": password,
    }


def load_scores(csv_path: Path) -> dict[str, int]:
    try:
        import psycopg
    except ModuleNotFoundError as error:
        raise RuntimeError(
            "PostgreSQL driver is missing. Run: "
            "python -m pip install -r requirements.txt"
        ) from error

    with psycopg.connect(
        **database_settings()
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                CREATE TEMP TABLE anomaly_scores_staging (
                    transaction_id TEXT,
                    anomaly_score DOUBLE PRECISION,
                    anomaly_risk_band TEXT,
                    is_anomaly SMALLINT,
                    model_version TEXT,
                    scored_at TIMESTAMPTZ
                )
                ON COMMIT DROP
                """
            )

            with csv_path.open(
                "r",
                encoding="utf-8-sig",
                newline=""
            ) as csv_file:
                with cursor.copy(COPY_SQL) as copy:
                    while chunk := csv_file.read(
                        1024 * 1024
                    ):
                        copy.write(chunk)

            cursor.execute(
                """
                SELECT COUNT(*)
                FROM anomaly_scores_staging
                """
            )

            staged_rows = cursor.fetchone()[0]

            cursor.execute(
                """
                SELECT COUNT(*)
                FROM (
                    SELECT transaction_id
                    FROM anomaly_scores_staging
                    GROUP BY transaction_id
                    HAVING COUNT(*) > 1
                ) duplicate_ids
                """
            )

            duplicate_ids = cursor.fetchone()[0]

            cursor.execute(
                """
                SELECT COUNT(*)
                FROM anomaly_scores_staging scores
                LEFT JOIN public.upi_transactions transactions
                    ON transactions.transaction_id =
                       scores.transaction_id
                WHERE transactions.transaction_id IS NULL
                """
            )

            missing_transactions = cursor.fetchone()[0]

            if duplicate_ids > 0:
                raise ValueError(
                    f"Duplicate transaction IDs found: "
                    f"{duplicate_ids:,}"
                )

            if missing_transactions > 0:
                raise ValueError(
                    f"Scores without matching transactions: "
                    f"{missing_transactions:,}"
                )

            cursor.execute(
                """
                INSERT INTO public.transaction_anomaly_scores (
                    transaction_id,
                    anomaly_score,
                    anomaly_risk_band,
                    is_anomaly,
                    model_version,
                    scored_at
                )
                SELECT
                    transaction_id,
                    anomaly_score,
                    anomaly_risk_band,
                    is_anomaly,
                    model_version,
                    scored_at
                FROM anomaly_scores_staging
                ON CONFLICT (transaction_id)
                DO UPDATE SET
                    anomaly_score =
                        EXCLUDED.anomaly_score,
                    anomaly_risk_band =
                        EXCLUDED.anomaly_risk_band,
                    is_anomaly =
                        EXCLUDED.is_anomaly,
                    model_version =
                        EXCLUDED.model_version,
                    scored_at =
                        EXCLUDED.scored_at,
                    updated_at =
                        CURRENT_TIMESTAMP
                """
            )

            upserted_rows = cursor.rowcount

            cursor.execute(
                """
                SELECT COUNT(*)
                FROM public.transaction_anomaly_scores
                """
            )

            target_rows = cursor.fetchone()[0]

        connection.commit()

    return {
        "staged_rows": staged_rows,
        "duplicate_transaction_ids": duplicate_ids,
        "missing_transactions": missing_transactions,
        "upserted_rows": upserted_rows,
        "target_rows_after": target_rows,
    }


def main() -> None:
    arguments = parse_arguments()

    csv_path = (
        arguments.file
        .expanduser()
        .resolve()
    )

    validate_csv(csv_path)

    summary = load_scores(csv_path)

    print("Anomaly-score loading completed successfully")

    for metric, value in summary.items():
        print(f"{metric:30}: {value:,}")


if __name__ == "__main__":
    main()