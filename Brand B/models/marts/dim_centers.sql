with source as (
    select * from {{ ref('stg_offices') }}
)

select
    center_id,
    center_name,
    city,
    state,
    region,
    opened_date,
    center_type,
    is_active,
    date_diff(current_date(), opened_date, year)   as center_age_years
from source
