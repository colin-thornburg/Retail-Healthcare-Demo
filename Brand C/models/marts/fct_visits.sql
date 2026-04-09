with source as (
    select * from {{ ref('int_visits_enriched') }}
)

select
    visit_id,
    visit_date,
    visit_type,
    visit_status,
    is_completed,
    is_new_patient,

    patient_id,
    provider_id,
    clinic_id,

    wait_time_minutes,
    total_visit_minutes                          as total_visit_duration_minutes,

    procedure_code,
    charge_amount,
    insurance_paid,
    patient_paid,
    total_collected,
    insurance_coverage_pct,
    payment_status,
    payer_name,
    billing_date,

    case
        when is_completed then coalesce(total_collected, 0)
        else 0
    end                                          as net_revenue

from source
