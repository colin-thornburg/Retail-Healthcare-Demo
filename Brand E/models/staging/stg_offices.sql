with source as (
    select * from {{ ref('raw_offices') }}
)

select
    cast(clinic_id as int64)    as clinic_id,
    clinic_name,
    city,
    state,
    region,
    cast(opened_date as date)   as opened_date,
    clinic_type,
    cast(is_active as boolean)  as is_active,
    current_timestamp()         as _loaded_at
from source
