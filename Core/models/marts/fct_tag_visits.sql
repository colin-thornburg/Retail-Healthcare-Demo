{{
    config(
        materialized = 'table'
    )
}}

with aspen_dental as (
    select
        'Aspen Dental'                      as brand,
        'Brand A'                           as brand_code,
        cast(visit_id as string)            as visit_id,
        cast(office_id as string)           as location_id,
        visit_date                          as activity_date,
        visit_type                          as activity_type,
        visit_status                        as status,
        cast(is_completed as boolean)       as is_completed,
        charge_amount,
        insurance_paid,
        patient_paid,
        net_revenue
    from {{ ref('aspen_dental', 'fct_visits') }}
),

clearchoice as (
    select
        'ClearChoice'                       as brand,
        'Brand B'                           as brand_code,
        cast(case_id as string)             as visit_id,
        cast(center_id as string)           as location_id,
        consultation_date                   as activity_date,
        'Implant Case'                      as activity_type,
        case_status                         as status,
        case
            when case_status = 'Completed' then true
            else false
        end                                 as is_completed,
        total_case_revenue                  as charge_amount,
        cast(0 as numeric)                  as insurance_paid,
        total_patient_paid                  as patient_paid,
        total_case_revenue                  as net_revenue
    from {{ ref('clearchoice', 'fct_cases') }}
),

wellnow as (
    select
        'WellNow'                           as brand,
        'Brand C'                           as brand_code,
        cast(visit_id as string)            as visit_id,
        cast(clinic_id as string)           as location_id,
        visit_date                          as activity_date,
        visit_type                          as activity_type,
        visit_status                        as status,
        cast(is_completed as boolean)       as is_completed,
        charge_amount,
        insurance_paid,
        patient_paid,
        net_revenue
    from {{ ref('wellnow', 'fct_visits') }}
),

chapter as (
    select
        'Chapter'                           as brand,
        'Brand D'                           as brand_code,
        cast(appointment_id as string)      as visit_id,
        cast(studio_id as string)           as location_id,
        appointment_date                    as activity_date,
        service_type                        as activity_type,
        appointment_status                  as status,
        cast(is_completed as boolean)       as is_completed,
        charge_amount,
        cast(0 as numeric)                  as insurance_paid,
        ifnull(charge_amount - discount_amount, charge_amount) as patient_paid,
        net_revenue
    from {{ ref('chapter', 'fct_appointments') }}
),

lovet as (
    select
        'Lovet'                             as brand,
        'Brand E'                           as brand_code,
        cast(visit_id as string)            as visit_id,
        cast(clinic_id as string)           as location_id,
        visit_date                          as activity_date,
        visit_type                          as activity_type,
        visit_status                        as status,
        cast(is_completed as boolean)       as is_completed,
        charge_amount,
        wellness_plan_covered               as insurance_paid,
        owner_paid                          as patient_paid,
        net_revenue
    from {{ ref('lovet', 'fct_visits') }}
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
