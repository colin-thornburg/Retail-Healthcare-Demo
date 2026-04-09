with source as (
    select * from {{ ref('raw_offices') }}
)

select
    cast(studio_id as int64)    as studio_id,
    studio_name,
    city,
    state,
    region,
    cast(opened_date as date)   as opened_date,
    cast(is_active as boolean)  as is_active,
    current_timestamp()         as _loaded_at
from source
