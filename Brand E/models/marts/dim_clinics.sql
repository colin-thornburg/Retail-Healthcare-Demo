with source as (
    select * from {{ ref('stg_offices') }}
)

select
    clinic_id,
    clinic_name,
    city,
    state,
    region,
    opened_date,
    clinic_type,
    is_active,
    date_diff(current_date(), opened_date, year)   as clinic_age_years
from source
