{{
    config(
        materialized = 'table'
    )
}}

select
    brand,
    brand_code,
    date_trunc(activity_date, MONTH)                                as revenue_month,

    count(*)                                                        as total_activities,
    countif(is_completed)                                           as completed_activities,

    sum(charge_amount)                                              as gross_charges,
    sum(insurance_paid)                                             as total_insurance_collected,
    sum(patient_paid)                                               as total_patient_collected,
    sum(net_revenue)                                                as net_revenue,

    safe_divide(sum(net_revenue), countif(is_completed))            as avg_revenue_per_activity,

    safe_divide(countif(is_completed), count(*))                    as completion_rate

from {{ ref('fct_tag_visits') }}
group by 1, 2, 3
