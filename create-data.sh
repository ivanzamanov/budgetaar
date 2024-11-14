#!/bin/bash
set -eu
INPUT_FILE=${1:-statement.txt}
DATABASE=data/data.db

echo "Loading $INPUT_FILE into $DATABASE"

mkdir -p `dirname $DATABASE`
duckdb $DATABASE <<EOF
drop table if exists raw_data;
create table raw_data as select * from read_csv('$INPUT_FILE', header = true);

drop sequence if exists transaction_id;
create sequence transaction_id;

drop table if exists data;
create table data (
id int not null primary key default nextval('transaction_id'),
datetime timestamp not null,
amount decimal,
debit_credit char,
debit decimal,
credit decimal,
reference varchar not null,
contragent varchar,
description varchar
);

insert into data (datetime, reference, contragent, description, amount, debit_credit, debit, credit)
select datetime, reference, contragent, concat(trname, ' ', rem_i, ' ', rem_ii, ' ', rem_iii) as description,
REPLACE(amount, ',', '') as amount,
dtkt as debit_credit,
(case when dtkt = 'K' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as credit,
(case when dtkt = 'D' then CAST (REPLACE(amount, ',', '') as decimal) else 0 end) as debit
from raw_data;

EOF

