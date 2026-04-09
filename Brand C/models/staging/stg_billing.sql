with source as (
    select * from {{ ref('raw_billing') }}
)

select
    cast(billing_id as int64)                                           as billing_id,
    cast(visit_id as int64)                                             as visit_id,
    cast(patient_id as int64)                                           as patient_id,
    procedure_code,
    cast(charge_amount as numeric)                                      as charge_amount,
    cast(insurance_paid as numeric)                                     as insurance_paid,
    cast(patient_paid as numeric)                                       as patient_paid,
    cast(insurance_paid as numeric) + cast(patient_paid as numeric)     as total_collected,
    safe_divide(
        cast(insurance_paid as numeric),
        nullif(cast(charge_amount as numeric), 0)
    )                                                                   as insurance_coverage_pct,
    cast(billing_date as date)                                          as billing_date,
    payment_status,
    payer_name,
    current_timestamp()                                                 as _loaded_at
from source
