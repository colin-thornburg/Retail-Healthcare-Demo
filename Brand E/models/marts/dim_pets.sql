with source as (
    select * from {{ ref('stg_patients') }}
)

select
    pet_id,
    pet_name,
    species,
    breed,
    date_of_birth,
    age_years,
    owner_name,
    owner_phone,
    clinic_id,
    wellness_plan,
    registration_date,
    is_active,
    date_diff(current_date(), registration_date, month) as tenure_months
from source
