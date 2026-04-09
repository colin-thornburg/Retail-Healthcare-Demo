with source as (
    select * from {{ ref('raw_patients') }}
)

select
    cast(pet_id as int64)                                              as pet_id,
    pet_name,
    species,
    breed,
    cast(date_of_birth as date)                                        as date_of_birth,
    date_diff(current_date(), cast(date_of_birth as date), year)       as age_years,
    owner_name,
    owner_phone,
    cast(clinic_id as int64)                                           as clinic_id,
    wellness_plan,
    cast(registration_date as date)                                    as registration_date,
    cast(is_active as boolean)                                         as is_active,
    current_timestamp()                                                as _loaded_at
from source
