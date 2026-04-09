with enriched as (
    select * from {{ ref('int_visits_enriched') }}
)

select
    office_id,
    office_name,
    city,
    state,
    region,
    visit_date,

    count(*)                                                        as total_visits,
    countif(is_completed)                                           as completed_visits,
    countif(visit_status = 'Cancelled')                             as cancelled_visits,
    countif(visit_status = 'No-Show')                               as no_shows,
    count(distinct patient_id)                                      as unique_patients,

    sum(charge_amount)                                              as total_charges,
    sum(insurance_paid)                                             as total_insurance_collected,
    sum(patient_paid)                                               as total_patient_collected,

    safe_divide(
        countif(treatment_accepted and is_completed),
        countif(is_completed)
    )                                                               as treatment_acceptance_rate

from enriched
group by 1, 2, 3, 4, 5, 6
