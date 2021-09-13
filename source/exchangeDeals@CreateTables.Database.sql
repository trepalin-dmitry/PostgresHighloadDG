create or replace procedure "exchangeDeals@CreateTables.Database"()
	language plpgsql
as $$
begin
    create temp table if not exists "exchangeDealsSource"
    (
        id                   bigserial
            constraint "exchangeDealsSource_pkey"
                primary key,
        "accountGUId"        uuid           not null,
        "couponCurrencyGUId" uuid           not null,
        "couponVolume"       numeric(19, 2) not null,
        "currencyGUId"       uuid           not null,
        "dealDateTime"       timestamp      not null,
        "directionCode"      varchar(255)   not null,
        guid                 uuid           not null,
        "instrumentGUId"     uuid           not null,
        "orderGUId"          uuid           not null,
        "placeCode"          varchar(255)   not null,
        "planDeliveryDate"   date           not null,
        "planPaymentDate"    date           not null,
        price                numeric(19, 2) not null,
        quantity             numeric(19, 2) not null,
        "tradeSessionGUId"   uuid           not null,
        "typeCode"           varchar(255)   not null,
        volume               numeric(19, 2) not null
    );

    create temp table if not exists "exchangeDealsPersonsSource"
    (
        id                 bigserial
            constraint "exchangeDealsPersonsSource_pkey"
                primary key,
        comment            varchar(255),
        "exchangeDealGuid" uuid not null,
        "personGuid"       uuid not null
    );

    create temp table if not exists "exchangeDealsStatusesSource"
    (
        id                 bigserial
            constraint "exchangeDealsStatusesSource_pkey"
                primary key,
        index              integer      not null,
        comment            varchar(255),
        "dateTime"         timestamp    not null,
        "exchangeDealGuid" uuid         not null,
        "typeCode"         varchar(255) not null
    );
end ;
$$;

alter procedure "exchangeDeals@CreateTables.Database"() owner to postgres;

