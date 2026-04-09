with daily as (
    select * from {{ ref('int_office_daily_summary') }}
)

select
    office_id,
    office_name,
    city,
    state,
    region,
    visit_date                                   as revenue_date,

    total_visits,
    completed_visits,
    cancelled_visits,
    no_shows,
    unique_patients,

    total_charges                                as gross_charges,
    total_insurance_collected                    as insurance_collected,
    total_patient_collected                      as patient_collected,
    total_insurance_collected
        + total_patient_collected                as net_revenue,

    safe_divide(
        total_insurance_collected + total_patient_collected,
        completed_visits
    )                                            as avg_revenue_per_visit,

    treatment_acceptance_rate

from daily
