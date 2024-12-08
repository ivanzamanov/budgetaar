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
    description varchar,
    is_family boolean default false
);

insert or ignore into ibans (iban, description, is_family) values
('BG78BUIN95611000608425', 'Иван разплащателна', true),
('BG21FINV91501004361513', 'Марина ПИБ', true),
('BG92BUIN95611000695279', 'Обща разплащателна', true),
('BG44BUIN95614000720097', 'Обща спестовна', true),
('BG20STSA93000004099823', 'Доброволен Пенсионен Фонд Алианц България', false),
('SK6111000000002945045506', 'Wealth Effect Management', false),
('DE43501108006161538126', 'Interactive Brokers', false),
('DE72501108006231412815', 'Interactive Brokers', false),
('BG03FINV91502016974616', 'Гараж - Лъчезар Чамбов', false),
('BG76STSA93000021268009', 'Николай Дойчинов', false),
('BG17STSA93000024995035', 'Адвокат', false);

create table if not exists major_events (
    datetime timestamp not null,
    outflow decimal,
    description varchar,

    unique (datetime, description)
);

insert or replace into major_events (datetime, outflow, description) values
('2024-07-01', 1000, 'Банско'),
('2024-07-01', 2100, 'Застраховки кола'),
('2024-08-01', 8000, 'Мебели Транш 1'),
('2024-09-01', 2000, 'Почивка Гърция'),
('2024-10-01', 4000, 'Мебели Транш 2');

create sequence if not exists stream_heuristic_patterns_priority_sequence;
create table stream_heuristic_patterns (
    priority int not null primary key default nextval('stream_heuristic_patterns_priority_sequence'),
    pattern varchar not null unique,
    stream varchar not null
);

insert into stream_heuristic_patterns (stream, pattern) values
('groceries', '%EDNO DOBRO%'),
('groceries', '%SUPERMARKET 300%'),
('groceries', '%GOLDEN FRUT%'),
('groceries', '%GOLDEN FRUIT%'),
('groceries', '%RATIO DESIGN%'),
('groceries', '%RATIO DIZAYN%'),
('groceries', '%LIDL BALGARIYA%'),
('groceries', '%HIT HIPERMARKET%'),
('groceries', '%HIPPO%'),
('groceries', '%KAUFLAND%'),
('groceries', '%BILLA%'),
('groceries', '%FANTASTICO%'),
('groceries', '%EL BI BULGARIKUM%'),
('groceries', '%EUROLEND%'),
('groceries', '%INFINITUM%'),
('groceries', '%PERFEKTA MARKET%'),
('groceries', '%T MARKET%'),
('groceries', '%METRO SOFIA%'),

('pharmacy', '%VIRA 2014%'),
('pharmacy', '%DENIFARM 2000%'),
('pharmacy', '%APTEKA%'),
('pharmacy', '%APTEKI%'),
('pharmacy', '%REMEDIUM%'),

('bills', '%ePay%'),
('bills', '%ИЗИПЕЙ%'),
('bills', '%Easypay%'),
('bills', '%TOPLOFIKACIA%'),
('bills', '%FAST PAY BIZNES PARK SOFIA%'),
('bills', '%SOFIISKA VODA AD%'),
('bills', '%Годишна такса за дебитна карта%'),

('fuel', '%SHELL%'),
('fuel', '%OMV%'),
('fuel', '%PETROL%'),

('transport', '%CityGate Sofia%'),

('takeout', '%pizza%'),
('takeout', '%lachoni%'),
('takeout', '%LUCHONI%'),
('takeout', '%DJORDJOVAS%'),
('takeout', '%happy%'),
('takeout', '%GREEN DELI%'),
('takeout', '%Honu Hawaiian%'),
('takeout', '%KITCHEN SI%'),
('takeout', '%KITCHEN 51%'),
('takeout', '%AMREST KOFI%'),
('takeout', '%LGL1 EOOD%'),
('takeout', '%SBX508004%'),
('takeout', '%ALEGRA 84%'),
('takeout', '%FAST FIVE EOOD%'),
('takeout', '%PROMI OOD%'),
('takeout', '%SIRENE I VINO%'),
('takeout', '%JE T AIME%'),
('takeout', '%SOFIISKA BANICA%'),
('takeout', '%BREAD & WINE%'),
('takeout', '%COTEFFEE%'),
('takeout', '%BAR RESTAURANT%'),
('takeout', '%DZHEYELPI%'),
('takeout', '%METRO BALAN 1%'),
('takeout', '%BARZO HRANENE%'),
('takeout', '%PCHELA%'),
('takeout', '%Eddies%'),

('personal care', '%BARBER%'),
('personal care', '%DEKATLON%'),
('personal care', '%DECATHLON%'),
('personal care', '%EYCH END EM%'),
('personal care', '%PEPCO%'),
('personal care', '%ORENDA BALGARIYA%'),
('personal care', '%www.aboutyou.bg%'),
('personal care', '%THE%MALL%'),
('personal care', '%HIPPOLAND%'),
('personal care', '%ORSI%'),
('personal care', '%AMERIMED%'),
('personal care', '%BODY SHOP%'),
('personal care', '%OPTIC GALLERY%'),
('personal care', '%AIPPDP D-R TSVETOMIRA%'),
('personal care', '%PUZZLE MLADOST%'),
('personal care', '%MALKI PRIKAZKI%'),
('personal care', '%DM BULGARIA%'),
('personal care', '%DM BALGARIYA%'),
('personal care', '%DM BALGARIA%'),
('personal care', '% DM %'),
('personal care', '%MAGAZIN DINO%'),
('personal care', '%PULS%'),
('personal care', '%TAKE-A-CAKE%'),

('books', '%MIRANDA%'),
('books', '%PURKO%'),
('books', '%CLEVER BOOK%'),
('books', '%ROBERTINO%'),
('books', '%ECO KIDS PUBLISHING%'),
('books', '%7 STARS OOD%'),
('books', '%KNIJARNICA%'),

('home care', '%praktiker%'),
('home care', '%BALKAN YUG%'),
('home care', '%IKEA SOFIA STORE%'),
('home care', '%SIMA%'),

('mortgage', '%АЛИАНЦ БАНК БЪЛГАРИЯ АД%'),
('mortgage', '%Погасяване главница кредит%'),
('mortgage', '%Такса поддръжка карта%'),
('mortgage', '%Ministry of e-Governanc%'),
('mortgage', '%SOFIA MUNICIPALITY%'),

('car', '%АЛИАНЦ ЛИЗИНГ БЪЛГАРИЯ%'),
('car', '%DIANA%'),
('car', '%PORSCHE%'),
('car', '%TECH-CO%'),

('tech', '%TECHNOPOLIS%'),
('tech', '%TEHNOPOLIS%'),
('tech', '%CHAIRPRO%'),
('tech', '%TECHMART%'),
('tech', '%ARDES%'),
('tech', '%Поръчка 0269262%'),

('cash', '%Теглене на%'),
('cash', '%Revolut%'),
('cash', '%BG54UBBS88881000878308%'),
('cash', '%REVO*IvanZaman%'),

('vacation', '%AIRBNB%'),
('vacation', '%bansko%'),
('vacation', '%razlog%'),
('vacation', '%Travel%'),
('vacation', '%THE OLD BAKERY APART PLOVDIV%'),
('vacation', '%ESTIL%'),
('vacation', '%UNIQA%'),
('vacation', '%Gabbys villa%'),
('vacation', '%SMOLYAN%'),
('vacation', '%BG501100000%'),

('gifts', '%GIFTTUBE%'),
('gifts', '%STEFKOS MYUZIK%'),

('courier deliveries', '%speedy%'),
('courier deliveries', '%econt%'),

('unknown', '%')
;