with source as (
    select * from {{ ref('raw_patients') }}
)

select
    cast(patient_id as int64)                                          as patient_id,
    first_name,
    last_name,
    cast(date_of_birth as date)                                        as date_of_birth,
    date_diff(current_date(), cast(date_of_birth as date), year)       as age,
    gender,
    cast(office_id as int64)                                           as office_id,
    upper(insurance_type)                                              as insurance_type,
    cast(patient_since as date)                                        as patient_since,
    cast(is_active as boolean)                                         as is_active,
    current_timestamp()                                                as _loaded_at
from source
