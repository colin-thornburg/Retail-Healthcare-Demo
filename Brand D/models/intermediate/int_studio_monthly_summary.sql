with appointments as (
    select * from {{ ref('stg_visits') }}
),

studios as (
    select * from {{ ref('stg_offices') }}
),

billing as (
    select * from {{ ref('stg_billing') }}
),

clients as (
    select * from {{ ref('stg_patients') }}
),

monthly as (
    select
        a.studio_id,
        s.studio_name,
        s.region,
        date_trunc(a.appointment_date, MONTH)           as visit_month,

        count(*)                                        as total_appointments,
        countif(a.is_completed)                         as completed_appointments,
        countif(a.appointment_status = 'Cancelled')     as cancelled_appointments,
        count(distinct a.client_id)                     as unique_clients,

        -- Revenue
        sum(b.charge_amount)                            as total_gross_revenue,
        sum(b.discount_amount)                          as total_discounts,
        sum(b.amount_paid)                              as total_net_revenue,
        safe_divide(sum(b.amount_paid), countif(a.is_completed)) as avg_revenue_per_completed_appt,

        -- Service mix
        countif(a.service_type = 'Botox')               as botox_appointments,
        countif(a.service_type = 'Filler')              as filler_appointments,
        countif(a.service_type = 'Chemical Peel')       as chemical_peel_appointments,
        countif(a.service_type = 'Laser Treatment')     as laser_appointments,
        countif(a.service_type = 'Microneedling')       as microneedling_appointments,
        countif(a.service_type = 'HydraFacial')         as hydrafacial_appointments,
        countif(a.service_type = 'Consultation')        as consultation_appointments,

        -- Membership breakdown
        countif(c.membership_type = 'VIP')              as vip_client_visits,
        countif(c.membership_type = 'Premium')          as premium_client_visits,
        countif(c.membership_type = 'Basic')            as basic_client_visits,
        countif(c.membership_type = 'None')             as non_member_visits

    from appointments a
    left join studios  s on a.studio_id   = s.studio_id
    left join billing  b on a.appointment_id = b.appointment_id
    left join clients  c on a.client_id   = c.client_id
    group by 1, 2, 3, 4
),

-- Retention: clients with more than 1 completed visit in the month
client_visit_counts as (
    select
        studio_id,
        date_trunc(appointment_date, MONTH) as visit_month,
        client_id,
        countif(is_completed) as completed_count
    from appointments
    group by 1, 2, 3
)

select
    m.*,
    count(distinct case when cvc.completed_count > 1 then cvc.client_id end)   as repeat_clients_in_month,
    safe_divide(
        count(distinct case when cvc.completed_count > 1 then cvc.client_id end),
        count(distinct cvc.client_id)
    )                                                                           as retention_rate

from monthly m
left join client_visit_counts cvc
    on m.studio_id   = cvc.studio_id
    and m.visit_month = cvc.visit_month
group by
    m.studio_id, m.studio_name, m.region, m.visit_month,
    m.total_appointments, m.completed_appointments, m.cancelled_appointments,
    m.unique_clients, m.total_gross_revenue, m.total_discounts, m.total_net_revenue,
    m.avg_revenue_per_completed_appt, m.botox_appointments, m.filler_appointments,
    m.chemical_peel_appointments, m.laser_appointments, m.microneedling_appointments,
    m.hydrafacial_appointments, m.consultation_appointments,
    m.vip_client_visits, m.premium_client_visits, m.basic_client_visits, m.non_member_visits
