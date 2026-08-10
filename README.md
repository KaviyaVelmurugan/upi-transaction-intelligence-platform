# UPI Transaction Operational Intelligence Platform

## Project Overview

A FinTech Operational Intelligence Platform that helps business and operations teams monitor transaction health, analyze failure trends, evaluate bank performance, and support operational decision-making using SQL, Power BI, and Machine Learning.

The platform analyzes transaction success and failure patterns, bank-wise performance, time-based trends, merchant categories, device usage, and network-related behaviour.

The main purpose of the project is not only to report transaction failures, but also to provide operational insights that can support faster and more informed decision-making.

---

## Business Problem

UPI platforms process a large number of transactions every day. When transaction failures increase, business and operations teams may not have enough visibility to identify the affected banks, time periods, transaction categories, or possible operational causes.

This project addresses that problem by creating an analytics and intelligence layer that helps stakeholders monitor transaction health and investigate unusual failure patterns.

## Project Objective

The objective of this project is to build a UPI operational intelligence solution that can:

- Monitor transaction success and failure rates
- Analyze bank-wise transaction performance
- Identify peak transaction and failure periods
- Compare merchant, device, and network behaviour
- Detect unusual transaction patterns
- Generate actionable insights for business and operations teams

## Current Phase

- ✅ Phase 1 – Business Understanding
- ✅ Phase 2 – UPI Domain Research
- ✅ Phase 3 – Business Requirement Document
- ✅ Phase 4 – Data Collection
- ✅ Phase 5 – Data Quality & Cleaning
- ✅ Phase 6 – Exploratory Data Analysis
- 🟡 Phase 7 – SQL Analytics (In Progress)
- ⬜ Phase 8 – Power BI Dashboard
- ⬜ Phase 9 – Machine Learning
- ⬜ Phase 10 – Final Documentation

---

## How This Project Is Different

Many transaction analytics projects mainly focus on displaying transaction counts, success rates, and failure rates.

This project is positioned as an operational intelligence platform. It focuses on helping stakeholders understand:

- Which banks require investigation
- When transaction failures increase
- Which transaction segments are affected
- How transaction health changes over time
- What operational patterns should be prioritised

The project combines business understanding, Python-based analysis, SQL analytics, Power BI visualisation, and machine learning into one structured FinTech solution.

## Dynamic Analytics Architecture

The platform is designed to accept additional transaction batches without rebuilding the analysis. New CSV records are validated, copied into a PostgreSQL staging table, and merged into the stable transaction table using `transaction_id` as the unique key.

```text
New transaction CSV
        -> Python ingestion command
        -> PostgreSQL staging table
        -> Transaction-ID upsert
        -> Stable production table
        -> Reusable SQL views
        -> Power BI refresh or DirectQuery
```

Existing Transaction IDs are updated only when their stored values change. New IDs are appended, unchanged IDs are skipped, and every ingestion run is recorded in an audit table.

See [`docs/15_Dynamic_Data_Pipeline.md`](docs/15_Dynamic_Data_Pipeline.md) for setup and operating instructions.

## Project Structure

```text
docs/         -> Business documentation
data/         -> Raw and processed datasets
notebooks/    -> Jupyter notebooks
src/          -> Python source code
scripts/      -> Repeatable transaction ingestion
sql/          -> Schema, upsert logic, views, and business analytics
dashboard/    -> Power BI files
diagrams/     -> Architecture and process diagrams
images/       -> Screenshots and visuals
linkedin/     -> LinkedIn article drafts
```
