with appointments as (
    select * from {{ ref('stg_visits') }}
),

clients as (
    select * from {{ ref('stg_patients') }}
),

providers as (
    select * from {{ ref('stg_providers') }}
),

studios as (
    select * from {{ ref('stg_offices') }}
),

billing as (
    select * from {{ ref('stg_billing') }}
),

-- Count prior appointments per client to derive repeat-client flag
client_appointment_counts as (
    select
        appointment_id,
        client_id,
        appointment_date,
        count(*) over (
            partition by client_id
            order by appointment_date
            rows between unbounded preceding and 1 preceding
        ) as prior_appointment_count
    from appointments
)

select
    a.appointment_id,
    a.appointment_date,
    a.service_type,
    a.appointment_status,
    a.is_completed,

    c.client_id,
    c.first_name || ' ' || c.last_name  as client_name,
    c.age                               as client_age,
    c.gender,
    c.membership_type,
    c.first_visit_date,

    pr.provider_id,
    pr.provider_name,
    pr.provider_type,

    s.studio_id,
    s.studio_name,
    s.city,
    s.state,
    s.region,

    b.billing_id,
    b.service_code,
    b.charge_amount,
    b.discount_amount,
    b.amount_paid,
    b.discount_pct,
    b.payment_method,
    b.payment_status,
    b.billing_date,

    -- Net revenue after membership discounts
    b.amount_paid                                   as net_revenue,

    -- Repeat client flag
    coalesce(cac.prior_appointment_count, 0)        as prior_appointment_count,
    (coalesce(cac.prior_appointment_count, 0) > 0)  as is_repeat_client

from appointments a
left join clients  c   on a.client_id   = c.client_id
left join providers pr  on a.provider_id = pr.provider_id
left join studios   s   on a.studio_id   = s.studio_id
left join billing   b   on a.appointment_id = b.appointment_id
left join client_appointment_counts cac on a.appointment_id = cac.appointment_id
