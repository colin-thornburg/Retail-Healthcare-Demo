with daily as (
    select * from {{ ref('int_clinic_daily_summary') }}
)

select
    clinic_id,
    clinic_name,
    city,
    state,
    region,
    visit_date                                   as revenue_date,

    total_visits,
    completed_visits,
    cancelled_visits,
    no_shows,
    unique_patients,
    new_patient_visits,
    returning_patient_visits,

    avg_wait_time_minutes,
    max_wait_time_minutes,
    avg_total_visit_minutes,

    total_charges                                as gross_charges,
    total_insurance_collected                    as insurance_collected,
    total_patient_collected                      as patient_collected,
    total_insurance_collected
        + total_patient_collected                as net_revenue,

    -- Payer mix visit counts
    aetna_visits,
    uhc_visits,
    bcbs_visits,
    cigna_visits,
    medicaid_visits,
    workers_comp_visits,
    self_pay_visits,

    -- Payer mix percentages
    safe_divide(aetna_visits, total_visits)      as payer_mix_aetna_pct,
    safe_divide(uhc_visits, total_visits)        as payer_mix_uhc_pct,
    safe_divide(bcbs_visits, total_visits)       as payer_mix_bcbs_pct,
    safe_divide(medicaid_visits, total_visits)   as payer_mix_medicaid_pct,
    safe_divide(self_pay_visits, total_visits)   as payer_mix_self_pay_pct

from daily
