with source as (
    select * from {{ ref('stg_patients') }}
)

select
    client_id,
    first_name || ' ' || last_name              as full_name,
    first_name,
    last_name,
    date_of_birth,
    age,
    gender,
    studio_id,
    membership_type,
    first_visit_date,
    is_active,
    date_diff(current_date(), first_visit_date, month) as tenure_months
from source
