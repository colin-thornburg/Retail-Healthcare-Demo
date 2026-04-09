with monthly as (
    select * from {{ ref('int_center_monthly_summary') }}
)

select
    center_id,
    center_name,
    region,
    visit_month                              as revenue_month,

    total_consultations,
    total_surgeries,
    total_restorations,
    unique_patients,

    total_revenue                            as gross_revenue,
    safe_divide(total_revenue, total_surgeries) as avg_case_value,

    consultation_to_surgery_rate,
    financing_pct

from monthly
