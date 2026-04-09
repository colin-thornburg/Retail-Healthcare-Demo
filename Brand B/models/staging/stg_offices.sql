with source as (
    select * from {{ ref('raw_offices') }}
)

select
    cast(center_id as int64)    as center_id,
    center_name,
    city,
    state,
    region,
    cast(opened_date as date)   as opened_date,
    center_type,
    cast(is_active as boolean)  as is_active,
    current_timestamp()         as _loaded_at
from source
