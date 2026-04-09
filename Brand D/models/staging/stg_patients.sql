with source as (
    select * from {{ ref('raw_patients') }}
)

select
    cast(client_id as int64)                                           as client_id,
    first_name,
    last_name,
    cast(date_of_birth as date)                                        as date_of_birth,
    date_diff(current_date(), cast(date_of_birth as date), year)       as age,
    gender,
    cast(studio_id as int64)                                           as studio_id,
    membership_type,
    cast(first_visit_date as date)                                     as first_visit_date,
    cast(is_active as boolean)                                         as is_active,
    current_timestamp()                                                as _loaded_at
from source
