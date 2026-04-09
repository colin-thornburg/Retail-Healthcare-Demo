with source as (
    select * from {{ ref('stg_patients') }}
)

select
    patient_id,
    first_name || ' ' || last_name              as full_name,
    first_name,
    last_name,
    date_of_birth,
    age,
    gender,
    clinic_id,
    insurance_type,
    is_new_patient,
    registration_date,
    date_diff(current_date(), registration_date, month) as tenure_months
from source
