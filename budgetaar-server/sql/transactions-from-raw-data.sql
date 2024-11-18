with
raw_data as (select * from read_csv($1, header = true)),
raw_transactions as (
select
    datetime,
    reference,
    contragent,
    concat_ws(' ', trname, rem_i, rem_ii, rem_iii) as description,
    (case when dtkt = 'K' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as inflow,
    (case when dtkt = 'D' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as outflow
from raw_data
)
insert or ignore into transactions (datetime, iban, reference, inflow, outflow, contragent, description)
select
    datetime,
    $2 as iban,
    reference,
    sum(rt.inflow) as inflow,
    sum(rt.outflow) as outflow,
    first(rt.contragent) as contragent,
    string_agg(rt.description, '|') as description
from raw_transactions rt
group by datetime, reference;
