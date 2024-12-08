with
iban_descriptions as (
    select regexp_split_to_table(?3, ',')
),
ibans_param as (
    select iban from ibans where description in (select * from iban_descriptions)
),
streams_param as (
    select regexp_split_to_table(?4, ',')
)
select
*
from transactions t
where datetime >= COALESCE(?1::DATE, datetime) AND datetime <= COALESCE(?2::DATE, datetime)
and not exists (select * from ibans i where i.iban = t.counterparty_iban)
and (stream in (select * from streams_param) or (select count(*) from streams_param) = 0)
and ((select count(*) from ibans_param) = 0 or t.iban in (SELECT * FROM ibans_param))
and outflow > 0
order by datetime desc;