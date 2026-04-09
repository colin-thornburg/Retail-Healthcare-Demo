with source as (
    select * from {{ ref('int_cases_enriched') }}
)

select
    case_id,
    patient_id,
    center_id,

    consultation_date,
    surgery_date,
    restoration_date,
    case_status,

    referral_source,
    financing_used,
    total_visits,
    completed_visits,

    total_case_revenue,
    total_insurance_paid,
    total_patient_paid,
    days_consultation_to_surgery,
    days_surgery_to_restoration,

    case when surgery_date is not null then true else false end   as is_converted

from source
