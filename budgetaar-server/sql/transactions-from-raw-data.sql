create temp table raw_transactions (
    datetime timestamp not null,
    inflow decimal,
    outflow decimal,
    reference varchar not null,
    contragent varchar,
    transaction_name varchar,
    description varchar
);

insert into raw_transactions (datetime, reference, contragent, transaction_name, description, inflow, outflow)
select
    datetime,
    reference,
    contragent,
    trname as transaction_name,
    concat_ws(' ', rem_i, rem_ii, rem_iii) as description,
    (case when dtkt = 'K' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as inflow,
    (case when dtkt = 'D' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as outflow
from raw_data;

insert or ignore into transactions (datetime, reference, inflow, outflow, contragent, transaction_name, description)
select
    datetime,
    reference,
    sum(rt.inflow) as inflow,
    sum(rt.outflow) as outflow,
    first(rt.contragent) as contragent,
    string_agg(rt.transaction_name, '|') as transaction_name,
    string_agg(rt.description, '|') as description
from raw_transactions rt
group by datetime, reference;

drop table raw_transactions;