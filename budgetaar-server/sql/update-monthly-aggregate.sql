create or replace table monthly_aggregate (
    date varchar,
    outflow decimal,
    inflow decimal,
    total decimal,
    events_outflow decimal
);

with
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
and not exists (select * from ibans i where i.iban = t.counterparty_iban)
group by date order by date asc
),
major_events_monthly as (
select
date_trunc('month', datetime) as date,
sum(outflow) as outflow
from major_events group by date
)
insert into monthly_aggregate
select
    strftime(ms.date, '%Y-%m-%d') as date,
    (ms.outflow - coalesce(mem.outflow, 0)) as outflow,
    ms.inflow,
    ms.total,
    coalesce(mem.outflow, 0) as events_outflow
from monthly_spends ms left join major_events_monthly mem on ms.date = mem.date
order by date asc;