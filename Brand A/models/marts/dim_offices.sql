with source as (
    select * from {{ ref('stg_offices') }}
)

select
    office_id,
    office_name,
    city,
    state,
    region,
    opened_date,
    office_type,
    is_active,
    date_diff(current_date(), opened_date, year)   as office_age_years
from source
