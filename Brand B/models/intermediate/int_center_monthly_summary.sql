with visits as (
    select * from {{ ref('stg_visits') }}
),

offices as (
    select * from {{ ref('stg_offices') }}
),

billing as (
    select * from {{ ref('stg_billing') }}
),

monthly as (
    select
        v.center_id,
        o.center_name,
        o.region,
        date_trunc(v.visit_date, MONTH)                             as visit_month,

        count(*)                                                    as total_visits,
        countif(v.visit_type = 'Consultation')                      as total_consultations,
        countif(v.visit_type = 'Surgery Day' and v.is_completed)    as total_surgeries,
        countif(v.visit_type = 'Final Restoration' and v.is_completed) as total_restorations,
        count(distinct v.patient_id)                                as unique_patients,

        sum(b.charge_amount)                                        as total_revenue,
        avg(b.charge_amount)                                        as avg_visit_value,
        countif(b.financing_used)                                   as financing_visits,

        safe_divide(
            countif(b.financing_used),
            count(*)
        )                                                           as financing_pct

    from visits v
    left join offices o  on v.center_id = o.center_id
    left join billing b  on v.visit_id  = b.visit_id
    group by 1, 2, 3, 4
)

select
    *,
    safe_divide(total_surgeries, total_consultations)   as consultation_to_surgery_rate
from monthly
