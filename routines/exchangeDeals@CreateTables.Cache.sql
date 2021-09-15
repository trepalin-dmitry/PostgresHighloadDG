create or replace procedure "exchangeDeals@CreateTables.Cache"()
	language plpgsql
as $$
begin
    create temp table if not exists "exchangeDealsInternal"
    (
        id                   bigserial
            constraint "exchangeDealsInternal_pkey"
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
        "typeId"             integer        not null,
        volume               numeric(19, 2) not null
    );

    create temp table if not exists "exchangeDealsPersonsInternal"
    (
        id                 bigserial
            constraint "exchangeDealsPersonsInternal_pkey"
                primary key,
        comment            varchar(255),
        "exchangeDealGuid" uuid    not null,
        "personId"         integer not null
    );

    create temp table if not exists "exchangeDealsStatusesInternal"
    (
        id                 bigserial
            constraint "exchangeDealsStatusesInternal_pkey"
                primary key,
        index              integer   not null,
        comment            varchar(255),
        "dateTime"         timestamp not null,
        "exchangeDealGuid" uuid      not null,
        "typeId"           char      not null
    );
end ;
$$;

alter procedure "exchangeDeals@CreateTables.Cache"() owner to postgres;

