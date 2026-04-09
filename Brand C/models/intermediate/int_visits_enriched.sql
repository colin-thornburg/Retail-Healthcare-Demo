with visits as (
    select * from {{ ref('stg_visits') }}
),

patients as (
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
    v.check_in_time,
    v.seen_by_provider_time,
    v.checkout_time,
    v.wait_time_minutes,
    v.total_visit_minutes,

    p.patient_id,
    p.first_name || ' ' || p.last_name  as patient_name,
    p.age                               as patient_age,
    p.insurance_type,
    p.is_new_patient,

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
    b.insurance_paid,
    b.patient_paid,
    b.total_collected,
    b.insurance_coverage_pct,
    b.payment_status,
    b.payer_name,
    b.billing_date

from visits v
left join patients  p  on v.patient_id  = p.patient_id
left join providers pr on v.provider_id = pr.provider_id
left join offices   o  on v.clinic_id   = o.clinic_id
left join billing   b  on v.visit_id    = b.visit_id
