with source as (
    select * from {{ ref('raw_providers') }}
)

select
    cast(provider_id as int64)  as provider_id,
    provider_name,
    provider_type,
    cast(office_id as int64)    as office_id,
    cast(hire_date as date)     as hire_date,
    cast(is_active as boolean)  as is_active,
    current_timestamp()         as _loaded_at
from source
