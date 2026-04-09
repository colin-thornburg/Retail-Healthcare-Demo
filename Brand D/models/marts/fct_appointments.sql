with source as (
    select * from {{ ref('int_appointments_enriched') }}
)

select
    appointment_id,
    appointment_date,
    service_type,
    appointment_status,
    is_completed,

    client_id,
    provider_id,
    studio_id,

    membership_type,
    is_repeat_client,
    prior_appointment_count,

    service_code,
    charge_amount,
    discount_amount,
    amount_paid                                  as net_revenue,
    discount_pct,
    payment_method,
    payment_status,
    billing_date

from source
