with source as (
    select * from {{ ref('raw_visits') }}
)

select
    cast(visit_id as int64)                                             as visit_id,
    cast(patient_id as int64)                                           as patient_id,
    cast(provider_id as int64)                                          as provider_id,
    cast(office_id as int64)                                            as office_id,
    cast(visit_date as date)                                            as visit_date,
    visit_type,
    visit_status,
    cast(treatment_accepted as boolean)                                 as treatment_accepted,
    case when visit_status = 'Completed' then true else false end       as is_completed,
    current_timestamp()                                                 as _loaded_at
from source
