with
streams_param as (
    select regexp_split_to_table(?2, ',')
),
iban_descriptions as (
    select regexp_split_to_table(?3, ',')
),
ibans_param as (
    select iban from ibans where description in (select * from iban_descriptions)
)
select
sum(outflow) as outflow,
stream
from transactions t
where datetime >= COALESCE(?1::DATE, datetime) AND datetime <= COALESCE(?2::DATE, datetime)
and not exists (select * from ibans i where i.iban = t.counterparty_iban)
and stream not in ('ignored')
and ((select count(*) from ibans_param) = 0 or t.iban in (SELECT * FROM ibans_param))
group by stream;