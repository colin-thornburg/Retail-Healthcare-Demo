with source as (
    select * from {{ ref('stg_providers') }}
)

select
    provider_id,
    provider_name,
    provider_type,
    clinic_id,
    hire_date,
    is_active,
    date_diff(current_date(), hire_date, year)   as tenure_years
from source
