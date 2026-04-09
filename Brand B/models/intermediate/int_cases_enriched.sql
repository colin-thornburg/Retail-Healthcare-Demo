with visits as (
    select * from {{ ref('stg_visits') }}
),

patients as (
    select * from {{ ref('stg_patients') }}
),

offices as (
    select * from {{ ref('stg_offices') }}
),

billing as (
    select * from {{ ref('stg_billing') }}
),

-- Roll visits up to the case level
case_visits as (
    select
        case_id,
        patient_id,
        center_id,
        min(case when visit_type = 'Consultation' then visit_date end)     as consultation_date,
        min(case when visit_type = 'Surgery Day' then visit_date end)      as surgery_date,
        min(case when visit_type = 'Final Restoration' then visit_date end) as restoration_date,
        count(*)                                                            as total_visits,
        countif(is_completed)                                               as completed_visits,
        case
            when countif(visit_type = 'Final Restoration' and is_completed) > 0 then 'Completed'
            when countif(visit_status = 'Cancelled') > 0                        then 'Lost'
            else 'Active'
        end                                                                 as case_status
    from visits
    group by 1, 2, 3
),

-- Roll billing up to the case level
case_billing as (
    select
        v.case_id,
        sum(b.charge_amount)            as total_case_revenue,
        sum(b.insurance_paid)           as total_insurance_paid,
        sum(b.patient_paid)             as total_patient_paid,
        max(cast(b.financing_used as boolean)) as financing_used
    from visits v
    left join billing b on v.visit_id = b.visit_id
    group by 1
)

select
    cv.case_id,
    cv.patient_id,
    p.first_name || ' ' || p.last_name  as patient_name,
    p.insurance_type,
    p.referral_source,
    p.age                               as patient_age,

    cv.center_id,
    o.center_name,
    o.city,
    o.state,
    o.region,

    cv.consultation_date,
    cv.surgery_date,
    cv.restoration_date,
    cv.case_status,
    cv.total_visits,
    cv.completed_visits,

    cb.total_case_revenue,
    cb.total_insurance_paid,
    cb.total_patient_paid,
    cb.financing_used,

    date_diff(cv.surgery_date, cv.consultation_date, day)     as days_consultation_to_surgery,
    date_diff(cv.restoration_date, cv.surgery_date, day)      as days_surgery_to_restoration

from case_visits cv
left join patients  p  on cv.patient_id = p.patient_id
left join offices   o  on cv.center_id  = o.center_id
left join case_billing cb on cv.case_id = cb.case_id
