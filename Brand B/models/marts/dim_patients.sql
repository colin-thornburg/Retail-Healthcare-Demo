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
    center_id,
    insurance_type,
    referral_source,
    consultation_date,
    is_active
from source
