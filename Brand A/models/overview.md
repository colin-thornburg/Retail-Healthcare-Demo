{% docs __overview__ %}

# Aspen Dental dbt Project

This project contains the data models for **Aspen Dental**, one of TAG's five consumer
healthcare brands. It covers **general dentistry** across offices.

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
| `net_revenue` | Total collected revenue (insurance + patient) |
| `treatment_acceptance_rate` | % of treatments accepted by patients |
| `avg_revenue_per_visit` | Average revenue per completed visit |
| `visit_completion_rate` | % of scheduled visits completed |

## Data Entities

- **Offices**: Physical locations where services are delivered
- **Patients**: Patients receiving care
- **Providers**: Clinical staff delivering services
- **Visits**: Service delivery events
- **Billing**: Financial transactions per visit

## Data Sources

All data currently loaded via dbt seeds (CSV files) for demo purposes.
In production, these would be sourced from **EHR/PMS systems (Dentrix, Eaglesoft)**.

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
