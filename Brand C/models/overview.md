{% docs __overview__ %}

# WellNow Urgent Care dbt Project

This project contains the data models for **WellNow Urgent Care**, one of TAG's five consumer
healthcare brands. It covers **urgent care and occupational health** across clinics.

## Architecture

```
seeds/          → Raw CSV data (simulating EHR/PMS source systems)
    ↓
models/staging/ → Cleaned, typed views (1:1 with seeds)
    ↓
models/intermediate/ → Business logic joins and calculations
    ↓
models/marts/   → Final fact and dimension tables for analytics
```

### Layer Summary

| Layer | Prefix | Materialization | Purpose |
|---|---|---|---|
| Staging | `stg_` | View | Clean and type-cast raw data |
| Intermediate | `int_` | View | Join and apply business logic |
| Marts (Fact) | `fct_` | Table | Transactional metrics for analytics |
| Marts (Dimension) | `dim_` | Table | Entity attributes for slicing/dicing |

## Key Metrics

| Metric | Description |
|---|---|
| `avg_wait_time_minutes` | Average time from check-in to provider |
| `net_revenue` | Total collected revenue |
| `payer_mix_medicaid_pct` | % of visits covered by Medicaid |
| `new_patient_rate` | % of visits from new patients |
| `visit_completion_rate` | % of visits completed (not cancelled/no-show) |

## Data Entities

- **Clinics**: Physical locations where services are delivered
- **Patients**: Patients receiving care
- **Providers**: Clinical staff delivering services
- **Visits**: Service delivery events
- **Billing**: Financial transactions per visit

## Data Sources

All data currently loaded via dbt seeds (CSV files) for demo purposes.
In production, these would be sourced from **EMR system (Experity/Clockwise.MD)**.

## Schema Layout (Dev)

| Dataset | Contents |
|---|---|
| `dbt_cthornburg_raw` | Seed tables (raw source data) |
| `dbt_cthornburg_staging` | Staging views |
| `dbt_cthornburg_intermediate` | Intermediate views |
| `dbt_cthornburg_marts` | Fact and dimension tables |

## dbt Mesh

Mart models are configured with `access: public`, enabling cross-project references
from a future `tag_core` project that aggregates metrics across all five brands.

{% enddocs %}
