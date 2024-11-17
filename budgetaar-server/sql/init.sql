create sequence if not exists transaction_id;
create table if not exists transactions (
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

create table if not exists non_spend_transactions (
    reference varchar not null primary key,
    description varchar
);
