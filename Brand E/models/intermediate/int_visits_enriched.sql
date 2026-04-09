with visits as (
    select * from {{ ref('stg_visits') }}
),

pets as (
    select * from {{ ref('stg_patients') }}
),

providers as (
    select * from {{ ref('stg_providers') }}
),

offices as (
    select * from {{ ref('stg_offices') }}
),

billing as (
    select * from {{ ref('stg_billing') }}
)

select
    v.visit_id,
    v.visit_date,
    v.visit_type,
    v.visit_status,
    v.is_completed,

    pe.pet_id,
    pe.pet_name,
    pe.species,
    pe.breed,
    pe.age_years                            as pet_age_years,
    pe.wellness_plan,
    pe.owner_name,
    pe.owner_phone,

    pr.provider_id,
    pr.provider_name,
    pr.provider_type,

    o.clinic_id,
    o.clinic_name,
    o.city,
    o.state,
    o.region,
    o.clinic_type,

    b.billing_id,
    b.procedure_code,
    b.charge_amount,
    b.wellness_plan_covered,
    b.owner_paid,
    b.total_collected,
    b.wellness_coverage_pct,
    b.payment_status,
    b.billing_date

from visits v
left join pets      pe on v.pet_id      = pe.pet_id
left join providers pr on v.provider_id = pr.provider_id
left join offices   o  on v.clinic_id   = o.clinic_id
left join billing   b  on v.visit_id    = b.visit_id
