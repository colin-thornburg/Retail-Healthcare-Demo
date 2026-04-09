with source as (
    select * from {{ ref('raw_billing') }}
)

select
    cast(billing_id as int64)                                           as billing_id,
    cast(appointment_id as int64)                                       as appointment_id,
    cast(client_id as int64)                                            as client_id,
    service_code,
    cast(charge_amount as numeric)                                      as charge_amount,
    cast(discount_amount as numeric)                                    as discount_amount,
    cast(amount_paid as numeric)                                        as amount_paid,
    safe_divide(
        cast(discount_amount as numeric),
        nullif(cast(charge_amount as numeric), 0)
    )                                                                   as discount_pct,
    payment_method,
    cast(billing_date as date)                                          as billing_date,
    payment_status,
    current_timestamp()                                                 as _loaded_at
from source
