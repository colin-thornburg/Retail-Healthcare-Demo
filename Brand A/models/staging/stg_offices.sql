with source as (
    select * from {{ ref('raw_offices') }}
)

select
    cast(office_id as int64)    as office_id,
    office_name,
    city,
    state,
    region,
    cast(opened_date as date)   as opened_date,
    office_type,
    cast(is_active as boolean)  as is_active,
    current_timestamp()         as _loaded_at
from source
