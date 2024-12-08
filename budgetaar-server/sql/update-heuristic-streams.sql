delete from transactions t where datetime < '2022-06-01';

update transactions t set stream = 'ignored' where t.counterparty_iban in (select iban from ibans);

update transactions set stream = (
    select first(stream ORDER BY priority) from stream_heuristic_patterns s
    where
    concat(contragent, description) ilike s.pattern
)
where stream is null;
