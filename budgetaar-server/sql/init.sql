create sequence if not exists transaction_id;
create table if not exists transactions (
    id int not null primary key default nextval('transaction_id'),
    iban varchar not null,
    counterparty_iban varchar,
    datetime timestamp not null,
    reference varchar not null,
    inflow decimal,
    outflow decimal,
    contragent varchar,
    description varchar,

    unique (datetime, reference)
);

create table if not exists ibans (
    iban varchar not null primary key,
    description varchar
);

create table if not exists excluded_transactions (
    reference varchar not null primary key,
    description varchar
);

insert or ignore into ibans (iban, description) values
('BG78BUIN95611000608425', 'Иван разплащателна'),
('BG21FINV91501004361513', 'Марина ПИБ'),
('BG92BUIN95611000695279', 'Обща разплащателна'),
('BG44BUIN95614000720097', 'Обща спестовна'),
('BG20STSA93000004099823', 'Доброволен Пенсионен Фонд Алианц България'),
('SK6111000000002945045506', 'Wealth Effect Management'),
('DE43501108006161538126', 'Interactive Brokers'),
('DE72501108006231412815', 'Interactive Brokers'),
('BG03FINV91502016974616', 'Гараж - Лъчезар Чамбов'),
('BG76STSA93000021268009', 'Николай Дойчинов');
