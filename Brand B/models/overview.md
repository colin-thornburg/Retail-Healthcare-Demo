{% docs __overview__ %}

# ClearChoice dbt Project

This project contains the data models for **ClearChoice**, one of TAG's five consumer
healthcare brands. It covers **dental implants** across implant centers.

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
| `total_case_revenue` | Total revenue per implant case |
| `consultation_to_surgery_rate` | % of consultations that convert to surgery |
| `avg_case_value` | Average revenue per completed surgery |
| `days_consultation_to_surgery` | Lead time from first contact to surgery |
| `financing_pct` | % of cases using patient financing |

## Data Entities

- **Implant centers**: Physical locations where services are delivered
- **Patients**: Patients receiving care
- **Providers**: Clinical staff delivering services
- **Cases (multi-visit implant journeys)**: Service delivery events
- **Billing**: Financial transactions per visit

## Data Sources

All data currently loaded via dbt seeds (CSV files) for demo purposes.
In production, these would be sourced from **Practice management system (Implant-specific PMS)**.

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
