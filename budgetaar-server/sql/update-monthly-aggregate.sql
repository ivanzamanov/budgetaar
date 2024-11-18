create or replace table monthly_aggregate as
select
    date_trunc('month', datetime) as date,
    sum(outflow) as outflow,
    sum(inflow) as inflow,
    sum(inflow) - sum(outflow) as net_gain,
    (
        select sum(inflow) - sum(outflow) from transactions t where t.datetime + interval '1 month' < date
    ) as total
from transactions t
where datetime >= '2022-09-06'
and not exists (select * from ibans i where i.iban = t.counterparty_iban)
and not exists (select * from excluded_transactions et where et.reference = t.reference)
group by date order by date asc;