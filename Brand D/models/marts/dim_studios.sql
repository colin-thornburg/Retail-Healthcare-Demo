with source as (
    select * from {{ ref('stg_offices') }}
)

select
    studio_id,
    studio_name,
    city,
    state,
    region,
    opened_date,
    is_active,
    date_diff(current_date(), opened_date, year)   as studio_age_years
from source
