{% docs __overview__ %}

# Chapter Aesthetic Studio dbt Project

This project contains the data models for **Chapter Aesthetic Studio**, one of TAG's five consumer
healthcare brands. It covers **medical aesthetics** across studios.

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
| `total_net_revenue` | Revenue after membership discounts |
| `avg_revenue_per_completed_appt` | Average net revenue per appointment |
| `client_retention_rate` | % of clients with repeat visits in a month |
| `membership_visit_pct` | % of visits from members |
| `discount_pct` | Average discount applied per visit |

## Data Entities

- **Studios**: Physical locations where services are delivered
- **Clients**: Clients receiving care
- **Providers**: Clinical staff delivering services
- **Appointments**: Service delivery events
- **Billing**: Financial transactions per visit

## Data Sources

All data currently loaded via dbt seeds (CSV files) for demo purposes.
In production, these would be sourced from **Practice management system (Boulevard, Mindbody)**.

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
