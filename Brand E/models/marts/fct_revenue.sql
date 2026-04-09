with monthly as (
    select * from {{ ref('int_clinic_monthly_summary') }}
)

select
    clinic_id,
    clinic_name,
    region,
    visit_month                                  as revenue_month,

    total_visits,
    completed_visits,
    unique_pets,

    total_charges                                as gross_charges,
    total_wellness_covered,
    total_owner_paid,
    avg_revenue_per_visit,

    -- Species mix
    dog_visits,
    cat_visits,
    bird_visits,
    rabbit_visits,
    reptile_visits,

    safe_divide(dog_visits, total_visits)        as dog_visit_pct,
    safe_divide(cat_visits, total_visits)        as cat_visit_pct,

    -- Visit type mix
    wellness_exam_visits,
    vaccination_visits,
    sick_visits,
    surgery_visits,
    emergency_visits,

    -- Wellness plan metrics
    wellness_coverage_rate,
    wellness_enrollment_rate,
    total_enrolled_pets,
    pets_with_wellness_plan,

    safe_divide(total_wellness_covered, total_charges) as wellness_revenue_pct

from monthly
