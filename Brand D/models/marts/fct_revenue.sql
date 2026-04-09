with monthly as (
    select * from {{ ref('int_studio_monthly_summary') }}
)

select
    studio_id,
    studio_name,
    region,
    visit_month                                  as revenue_month,

    total_appointments,
    completed_appointments,
    cancelled_appointments,
    unique_clients,

    total_gross_revenue,
    total_discounts,
    total_net_revenue,
    avg_revenue_per_completed_appt,

    -- Service mix
    botox_appointments,
    filler_appointments,
    chemical_peel_appointments,
    laser_appointments,
    microneedling_appointments,
    hydrafacial_appointments,

    -- Membership breakdown
    vip_client_visits,
    premium_client_visits,
    basic_client_visits,
    non_member_visits,

    safe_divide(
        vip_client_visits + premium_client_visits + basic_client_visits,
        total_appointments
    )                                            as membership_visit_pct,

    -- Retention
    repeat_clients_in_month,
    retention_rate                               as client_retention_rate

from monthly
