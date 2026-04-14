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
    case
        when age < 18 then 'Pediatric'
        when age between 18 and 34 then 'Young Adult'
        when age between 35 and 54 then 'Adult'
        when age between 55 and 64 then 'Senior'
        else 'Medicare Age'
    end                                         as age_group,
    office_id,
    insurance_type,
    patient_since,
    is_active,
    date_diff(current_date(), patient_since, month) as tenure_months
from source
