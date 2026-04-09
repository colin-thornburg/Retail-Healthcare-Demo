with source as (
    select * from {{ ref('int_visits_enriched') }}
)

select
    visit_id,
    visit_date,
    visit_type,
    visit_status,
    is_completed,
    treatment_accepted,

    patient_id,
    provider_id,
    office_id,

    procedure_code,
    charge_amount,
    insurance_paid,
    patient_paid,
    total_collected,
    insurance_coverage_pct,
    payment_status,
    billing_date,

    case
        when is_completed then coalesce(total_collected, 0)
        else 0
    end                                          as net_revenue

from source
