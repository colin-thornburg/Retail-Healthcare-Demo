with enriched as (
    select * from {{ ref('int_visits_enriched') }}
),

-- Wellness plan enrollment per clinic
clinic_pets as (
    select
        clinic_id,
        count(distinct pet_id)                                          as total_enrolled_pets,
        countif(wellness_plan != 'None')                                as pets_with_wellness_plan
    from {{ ref('stg_patients') }}
    group by 1
)

select
    e.clinic_id,
    e.clinic_name,
    e.region,
    date_trunc(e.visit_date, MONTH)                                     as visit_month,

    count(*)                                                            as total_visits,
    countif(e.is_completed)                                             as completed_visits,
    count(distinct e.pet_id)                                            as unique_pets,

    -- Revenue
    sum(e.charge_amount)                                                as total_charges,
    sum(e.wellness_plan_covered)                                        as total_wellness_covered,
    sum(e.owner_paid)                                                   as total_owner_paid,
    safe_divide(sum(e.charge_amount), countif(e.is_completed))          as avg_revenue_per_visit,

    -- Species breakdown
    countif(e.species = 'Dog')                                          as dog_visits,
    countif(e.species = 'Cat')                                          as cat_visits,
    countif(e.species = 'Bird')                                         as bird_visits,
    countif(e.species = 'Rabbit')                                       as rabbit_visits,
    countif(e.species = 'Reptile')                                      as reptile_visits,

    -- Visit type mix
    countif(e.visit_type = 'Wellness Exam')                             as wellness_exam_visits,
    countif(e.visit_type = 'Vaccination')                               as vaccination_visits,
    countif(e.visit_type = 'Sick Visit')                                as sick_visits,
    countif(e.visit_type = 'Surgery')                                   as surgery_visits,
    countif(e.visit_type = 'Emergency')                                 as emergency_visits,

    -- Wellness plan coverage rate
    safe_divide(sum(e.wellness_plan_covered), sum(e.charge_amount))     as wellness_coverage_rate,

    -- Enrollment rate (from snapshot of enrolled pets)
    cp.total_enrolled_pets,
    cp.pets_with_wellness_plan,
    safe_divide(cp.pets_with_wellness_plan, cp.total_enrolled_pets)     as wellness_enrollment_rate

from enriched e
left join clinic_pets cp on e.clinic_id = cp.clinic_id
group by
    e.clinic_id, e.clinic_name, e.region,
    date_trunc(e.visit_date, MONTH),
    cp.total_enrolled_pets, cp.pets_with_wellness_plan
