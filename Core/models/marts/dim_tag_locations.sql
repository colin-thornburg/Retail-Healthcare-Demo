{{
    config(
        materialized = 'table'
    )
}}

with aspen_dental as (
    select
        'Aspen Dental'                      as brand,
        'Brand A'                           as brand_code,
        cast(office_id as string)           as location_id,
        office_name                         as location_name,
        city,
        state,
        region,
        office_type                         as location_type,
        opened_date,
        is_active,
        office_age_years                    as location_age_years
    from {{ ref('aspen_dental', 'dim_offices') }}
),

clearchoice as (
    select
        'ClearChoice'                       as brand,
        'Brand B'                           as brand_code,
        cast(center_id as string)           as location_id,
        center_name                         as location_name,
        city,
        state,
        region,
        center_type                         as location_type,
        opened_date,
        is_active,
        center_age_years                    as location_age_years
    from {{ ref('clearchoice', 'dim_centers') }}
),

wellnow as (
    select
        'WellNow'                           as brand,
        'Brand C'                           as brand_code,
        cast(clinic_id as string)           as location_id,
        clinic_name                         as location_name,
        city,
        state,
        region,
        clinic_type                         as location_type,
        opened_date,
        is_active,
        clinic_age_years                    as location_age_years
    from {{ ref('wellnow', 'dim_clinics') }}
),

chapter as (
    select
        'Chapter'                           as brand,
        'Brand D'                           as brand_code,
        cast(studio_id as string)           as location_id,
        studio_name                         as location_name,
        city,
        state,
        region,
        'Aesthetic Studio'                  as location_type,
        opened_date,
        is_active,
        studio_age_years                    as location_age_years
    from {{ ref('chapter', 'dim_studios') }}
),

lovet as (
    select
        'Lovet'                             as brand,
        'Brand E'                           as brand_code,
        cast(clinic_id as string)           as location_id,
        clinic_name                         as location_name,
        city,
        state,
        region,
        clinic_type                         as location_type,
        opened_date,
        is_active,
        clinic_age_years                    as location_age_years
    from {{ ref('lovet', 'dim_clinics') }}
)

select * from aspen_dental
union all
select * from clearchoice
union all
select * from wellnow
union all
select * from chapter
union all
select * from lovet
