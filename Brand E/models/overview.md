{% docs __overview__ %}

# Lovet Pet Health Care dbt Project

This project contains the data models for **Lovet Pet Health Care**, one of TAG's five consumer
healthcare brands. It covers **veterinary care** across clinics.

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
| `avg_revenue_per_visit` | Average charge per completed visit |
| `wellness_coverage_rate` | % of charges covered by wellness plans |
| `wellness_enrollment_rate` | % of registered pets on a wellness plan |
| `dog_visit_pct` / `cat_visit_pct` | Species mix of visits |
| `net_revenue` | Total owner-collected revenue |

## Data Entities

- **Clinics**: Physical locations where services are delivered
- **Pets (with associated owner data)**: Pets (with associated owner data) receiving care
- **Providers**: Clinical staff delivering services
- **Visits**: Service delivery events
- **Billing**: Financial transactions per visit

## Data Sources

All data currently loaded via dbt seeds (CSV files) for demo purposes.
In production, these would be sourced from **Veterinary management system (Cornerstone, ezyVet)**.

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
