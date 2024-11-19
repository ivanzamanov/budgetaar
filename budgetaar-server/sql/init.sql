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
    stream varchar,

    unique (datetime, reference)
);

create table if not exists ibans (
    iban varchar not null primary key,
    description varchar
);

create table if not exists major_events (
    datetime timestamp not null,
    outflow decimal,
    description varchar,

    unique (datetime, description)
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

insert or replace into major_events (datetime, outflow, description) values
('2024-07-01', 1000, 'Банско'),
('2024-07-01', 2100, 'Застраховки кола'),
('2024-08-01', 8000, 'Мебели Транш 1'),
('2024-09-01', 2000, 'Почивка Гърция'),
('2024-10-01', 4000, 'Мебели Транш 2');
