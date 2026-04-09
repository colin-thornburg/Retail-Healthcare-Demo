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
    cast(clinic_id as int64)                                           as clinic_id,
    upper(insurance_type)                                              as insurance_type,
    cast(is_new_patient as boolean)                                    as is_new_patient,
    cast(registration_date as date)                                    as registration_date,
    current_timestamp()                                                as _loaded_at
from source
