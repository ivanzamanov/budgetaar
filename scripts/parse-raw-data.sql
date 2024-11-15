drop sequence if exists raw_transaction_id;
create sequence raw_transaction_id;

drop table if exists raw_transactions;
create table raw_transactions (
    id int not null primary key default nextval('raw_transaction_id'),
    datetime timestamp not null,
    inflow decimal,
    outflow decimal,
    reference varchar not null,
    contragent varchar,
    transaction_name varchar,
    description varchar
);

drop sequence if exists transaction_id;
create sequence transaction_id;

drop table if exists transactions;
create table transactions (
    id int not null primary key default nextval('transaction_id'),
    datetime timestamp not null,
    reference varchar not null,
    inflow decimal,
    outflow decimal,
    contragent varchar,
    transaction_name varchar,
    description varchar,

    unique (datetime, reference)
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

insert into transactions (datetime, reference, inflow, outflow, contragent, transaction_name, description)
select
    datetime,
    reference,
    sum(rt.inflow) as inflow,
    sum(rt.outflow) as outflow,
    first(rt.contragent) as contragent,
    string_agg(rt.transaction_name, '|' order by rt.id) as transaction_name,
    string_agg(rt.description, '|') as description
from raw_transactions rt
group by datetime, reference;

drop table if exists monthly_aggregate;
create table monthly_aggregate as
select
    date_trunc('month', datetime) as date,
    sum(outflow) as outflow,
    sum(inflow) as inflow,
    sum(inflow) - sum(outflow) as net_gain,
    (
        select sum(inflow) - sum(outflow) from transactions t where t.datetime + interval '1 month' < date
    ) as total
from transactions group by date order by date asc;
