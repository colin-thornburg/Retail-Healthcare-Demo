with source as (
    select * from {{ ref('raw_visits') }}
)

select
    cast(visit_id as int64)                                             as visit_id,
    cast(patient_id as int64)                                           as patient_id,
    cast(provider_id as int64)                                          as provider_id,
    cast(center_id as int64)                                            as center_id,
    cast(visit_date as date)                                            as visit_date,
    visit_type,
    visit_status,
    cast(case_id as int64)                                              as case_id,
    case when visit_status = 'Completed' then true else false end       as is_completed,
    current_timestamp()                                                 as _loaded_at
from source
