
update transactions t set stream = 'groceries' where stream is null
and (
    contragent ilike '%EDNO DOBRO%' or
    contragent ilike '%SUPERMARKET 300%' or
    contragent ilike '%LIDL BALGARIYA%' or
    contragent ilike '%GOLDEN FRUT%' or contragent ilike '%GOLDEN FRUIT%' or
    contragent ilike '%RATIO DESIGN%' or contragent ilike '%RATIO DIZAYN%' or
    contragent ilike '%HIT HIPERMARKET%' or
    contragent ilike '%KAUFLAND%' or
    contragent ilike '%BILLA%' or
    contragent ilike '%FANTASTICO%' or
    contragent ilike '%EL BI BULGARIKUM%' or
    description ilike '%EUROLEND%' or
    contragent ilike '%INFINITUM%'
);

update transactions t set stream = 'pharmacy' where stream is null
and (
    contragent ilike '%VIRA 2014%' or
    contragent ilike '%DENIFARM 2000%' or
    contragent ilike '%APTEKA%' or
    contragent ilike '%REMEDIUM%'
);

update transactions t set stream = 'bills' where stream is null
and (
    description ilike '%ePay%' or
    contragent ilike '%ИЗИПЕЙ%' or
    description ilike '%TOPLOFIKACIA%' or
    description ilike '%FAST PAY BIZNES PARK SOFIA%'
);

update transactions t set stream = 'fuel' where stream is null
and (
    contragent ilike '%SHELL%' or
    contragent ilike '%OMV%'
);

update transactions t set stream = 'transport' where stream is null
and (
    contragent ilike '%CityGate Sofia%'
);

update transactions t set stream = 'takeout' where stream is null
and (
    contragent ilike '%pizza%' or
    contragent ilike '%lachoni%' or
    contragent ilike '%happy%' or
    contragent ilike '%GREEN DELI%' or
    contragent ilike '%Honu Hawaiian%' or
    description ilike '%KITCHEN SI%' or contragent like '%KITCHEN 51%' or
    description ilike '%AMREST KOFI%' or -- Starbucks
    contragent ilike '%LGL1 EOOD%' or
    contragent ilike '%SBX508004%' or
    contragent ilike '%ALEGRA 84%' or
    contragent ilike '%FAST FIVE EOOD%' or
    contragent ilike '%PROMI OOD%'
);

update transactions t set stream = 'courier deliveries' where stream is null
and (
    contragent ilike '%speedy%' or
    contragent ilike '%econt%'
);

update transactions t set stream = 'personal care' where stream is null
and (
    contragent ilike '%BARBER%' or
    contragent ilike '%DEKATLON%' or
    contragent ilike '%EYCH END EM%' or
    contragent ilike '%PEPCO%' or
    contragent ilike '%ORENDA BALGARIYA%' or
    description ilike '%www.aboutyou.bg%' or
    concat(contragent, description) ilike '%THE%MALL%' or
    description ilike '%HIPPOLAND%' or
    description ilike '%ORSI%' or
    description ilike '%AMERIMED%' or
    description ilike '%BODY SHOP%' or
    description ilike '%OPTIC GALLERY%' or
    contragent ilike '%AIPPDP D-R TSVETOMIRA%' or
    contragent ilike '%PUZZLE MLADOST%' or
    contragent ilike '%MALKI PRIKAZKI%' or
    contragent ilike '%DM BULGARIA%' or description ilike '%DM BALGARIYA%' or description ilike '%DM BALGARIA%'
);

update transactions t set stream = 'books' where stream is null
and (
    description ilike '%MIRANDA%' or
    description ilike '%PURKO%' or
    description ilike '%CLEVER BOOK%' or
    description ilike '%ROBERTINO%' or
    contragent ilike '%ECO KIDS PUBLISHING%' or
    contragent ilike '%7 STARS OOD%'
);

update transactions t set stream = 'home care' where stream is null
and (
    contragent ilike '%praktiker%' or description ilike '%praktiker%' or
    contragent ilike '%BALKAN YUG%' or description ilike '%BALKAN YUG%' or
    description ilike '%IKEA SOFIA STORE%'
);

update transactions t set stream = 'mortgage' where stream is null
and (
    contragent ilike '%АЛИАНЦ БАНК БЪЛГАРИЯ АД%' or
    description ilike '%Погасяване главница кредит%' or
    description ilike '%Такса поддръжка карта%' or
    description ilike '%Ministry of e-Governanc%' or
    description ilike '%SOFIA MUNICIPALITY%'
);

update transactions t set stream = 'car' where stream is null
and (
    contragent ilike '%АЛИАНЦ ЛИЗИНГ БЪЛГАРИЯ%' or
    contragent ilike '%DIANA OOD%' or
    contragent ilike '%PORSCHE IZTOK%' or
    contragent ilike '%TECH-CO%'
);

update transactions t set stream = 'tech' where stream is null
and (
    description ilike '%TEHNOPOLIS%' or
    description ilike '%CHAIRPRO%'
);

update transactions t set stream = 'cash' where stream is null
and (
    description like 'Теглене на%' or
    description ilike '%Revolut%' or
    description like '%BG54UBBS88881000878308%'
);

update transactions t set stream = 'vacation' where stream is null
and (
    concat(contragent, description) ilike '%AIRBNB%' or
    concat(contragent, description) ilike '%bansko%' or
    concat(contragent, description) ilike '%razlog%' or
    concat(contragent, description) ilike '%Travel%' or
    concat(contragent, description) ilike '%THE OLD BAKERY APART PLOVDIV%' or
    concat(contragent, description) ilike '%ESTIL%' or
    concat(contragent, description) ilike '%UNIQA%'
);

update transactions t set stream = 'gifts' where stream is null
and (
    description ilike '%GIFTTUBE%' or
    description ilike '%STEFKOS MYUZIK%'
);

update transactions t set stream = 'unknown' where stream is null;