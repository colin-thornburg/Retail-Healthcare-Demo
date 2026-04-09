with source as (
    select * from {{ ref('raw_visits') }}
)

select
    cast(appointment_id as int64)                                       as appointment_id,
    cast(client_id as int64)                                            as client_id,
    cast(provider_id as int64)                                          as provider_id,
    cast(studio_id as int64)                                            as studio_id,
    cast(appointment_date as date)                                      as appointment_date,
    service_type,
    appointment_status,
    case when appointment_status = 'Completed' then true else false end as is_completed,
    current_timestamp()                                                 as _loaded_at
from source
