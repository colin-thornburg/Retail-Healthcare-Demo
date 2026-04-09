with source as (
    select * from {{ ref('raw_visits') }}
)

select
    cast(visit_id as int64)                                             as visit_id,
    cast(patient_id as int64)                                           as patient_id,
    cast(provider_id as int64)                                          as provider_id,
    cast(clinic_id as int64)                                            as clinic_id,
    cast(visit_date as date)                                            as visit_date,
    visit_type,
    visit_status,
    case when visit_status = 'Completed' then true else false end       as is_completed,
    cast(check_in_time as timestamp)                                    as check_in_time,
    cast(seen_by_provider_time as timestamp)                            as seen_by_provider_time,
    cast(checkout_time as timestamp)                                    as checkout_time,
    timestamp_diff(
        cast(seen_by_provider_time as timestamp),
        cast(check_in_time as timestamp),
        minute
    )                                                                   as wait_time_minutes,
    timestamp_diff(
        cast(checkout_time as timestamp),
        cast(check_in_time as timestamp),
        minute
    )                                                                   as total_visit_minutes,
    current_timestamp()                                                 as _loaded_at
from source
