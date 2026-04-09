with source as (
    select * from {{ ref('raw_billing') }}
)

select
    cast(billing_id as int64)                                           as billing_id,
    cast(visit_id as int64)                                             as visit_id,
    cast(pet_id as int64)                                               as pet_id,
    procedure_code,
    cast(charge_amount as numeric)                                      as charge_amount,
    cast(wellness_plan_covered as numeric)                              as wellness_plan_covered,
    cast(owner_paid as numeric)                                         as owner_paid,
    cast(wellness_plan_covered as numeric) + cast(owner_paid as numeric) as total_collected,
    safe_divide(
        cast(wellness_plan_covered as numeric),
        nullif(cast(charge_amount as numeric), 0)
    )                                                                   as wellness_coverage_pct,
    cast(billing_date as date)                                          as billing_date,
    payment_status,
    current_timestamp()                                                 as _loaded_at
from source
