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
    office_id,
    insurance_type,
    patient_since,
    is_active,
    date_diff(current_date(), patient_since, month) as tenure_months
from source
