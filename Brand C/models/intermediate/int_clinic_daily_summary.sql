with enriched as (
    select * from {{ ref('int_visits_enriched') }}
)

select
    clinic_id,
    clinic_name,
    city,
    state,
    region,
    visit_date,

    count(*)                                as total_visits,
    countif(is_completed)                   as completed_visits,
    countif(visit_status = 'Cancelled')     as cancelled_visits,
    countif(visit_status = 'No-Show')       as no_shows,
    count(distinct patient_id)              as unique_patients,
    countif(is_new_patient)                 as new_patient_visits,
    countif(not is_new_patient)             as returning_patient_visits,

    avg(case when is_completed then wait_time_minutes end)          as avg_wait_time_minutes,
    max(case when is_completed then wait_time_minutes end)          as max_wait_time_minutes,
    avg(case when is_completed then total_visit_minutes end)        as avg_total_visit_minutes,

    sum(charge_amount)                      as total_charges,
    sum(insurance_paid)                     as total_insurance_collected,
    sum(patient_paid)                       as total_patient_collected,

    -- Payer mix counts
    countif(payer_name = 'Aetna')           as aetna_visits,
    countif(payer_name = 'UnitedHealthcare') as uhc_visits,
    countif(payer_name = 'BlueCross')       as bcbs_visits,
    countif(payer_name = 'Cigna')           as cigna_visits,
    countif(payer_name = 'Medicaid')        as medicaid_visits,
    countif(payer_name = 'Workers Comp')    as workers_comp_visits,
    countif(payer_name = 'Self-Pay')        as self_pay_visits

from enriched
group by 1, 2, 3, 4, 5, 6
