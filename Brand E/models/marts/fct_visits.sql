with source as (
    select * from {{ ref('int_visits_enriched') }}
)

select
    visit_id,
    visit_date,
    visit_type,
    visit_status,
    is_completed,

    pet_id,
    provider_id,
    clinic_id,

    species,
    breed,
    wellness_plan,
    pet_age_years,

    procedure_code,
    charge_amount,
    wellness_plan_covered,
    owner_paid,
    total_collected,
    wellness_coverage_pct,
    payment_status,
    billing_date,

    case
        when is_completed then coalesce(total_collected, 0)
        else 0
    end                                          as net_revenue

from source
