with
ibans_param as (
    select regexp_split_to_table(?1, ',')
),
streams_param as (
    select regexp_split_to_table(?2, ',')
),
monthly_spends as (
select
    date_trunc('month', datetime) as date,
    sum(outflow) as outflow,
    sum(inflow) as inflow,
    (
        select sum(inflow) - sum(outflow) from transactions t where t.datetime + interval '1 month' < date
    ) as total
    from transactions t
where datetime >= '2022-01-06'
and ((select count(*) from ibans_param) = 0 or t.iban in (SELECT * FROM ibans_param))
and ((select count(*) from streams_param) = 0 or t.stream in (SELECT * FROM streams_param))
and not exists (select * from ibans i where i.iban = t.counterparty_iban)
group by date order by date asc
),
major_events_monthly as (
select
    date_trunc('month', datetime) as date,
    sum(outflow) as outflow
from major_events group by date
)
select
    strftime(ms.date, '%Y-%m-%d') as date,
    (ms.outflow - coalesce(case when ?3 then mem.outflow else 0 end, 0)) as outflow,
    ms.inflow,
    ms.total,
    coalesce(mem.outflow, 0) as events_outflow
from monthly_spends ms left join major_events_monthly mem on ms.date = mem.date
order by date asc;