create or replace procedure "simpleExchangeDeals@CreateTables.Cache"()
	language plpgsql
as $$
begin
    create temp table if not exists "simpleExchangeDealsInternal"
    (
        id                   bigserial
            constraint "simpleExchangeDealsInternal_pkey"
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
end ;
$$;

alter procedure "simpleExchangeDeals@CreateTables.Cache"() owner to postgres;

