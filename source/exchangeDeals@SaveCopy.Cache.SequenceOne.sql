create or replace procedure "exchangeDeals@SaveCopy.Cache.SequenceOne"(size integer)
	language plpgsql
as $$
DECLARE
    dealsIds bigint[];
begin

    -- Создание/Изменение "exchangeDeals"
    with changed(id, guid) as (
        INSERT INTO "exchangeDealsSequenceOne" (id, guid, "accountGUId", "couponCurrencyGUId", "couponVolume",
                                                "currencyGUId",
                                                "dealDateTime",
                                                "directionCode", "instrumentGUId", "orderGUId", "placeCode",
                                                "planDeliveryDate",
                                                "planPaymentDate", price, quantity, "tradeSessionGUId", "typeCode",
                                                volume)
            SELECT nextval('exchange_deals_sequence_one_id_seq'),
                   D.guid,
                   D."accountGUId",
                   D."couponCurrencyGUId",
                   D."couponVolume",
                   D."currencyGUId",
                   D."dealDateTime",
                   D."directionCode",
                   D."instrumentGUId",
                   D."orderGUId",
                   D."placeCode",
                   D."planDeliveryDate",
                   D."planPaymentDate",
                   D.price,
                   D.quantity,
                   D."tradeSessionGUId",
                   D."typeCode",
                   D.volume
            FROM (
                     select D.*
                     from "exchangeDealsInternal" D
                 ) D
            ON CONFLICT (guid) DO UPDATE
                SET "accountGUId" = EXCLUDED."accountGUId",
                    "couponCurrencyGUId" = EXCLUDED."couponCurrencyGUId",
                    "couponVolume" = EXCLUDED."couponVolume",
                    "currencyGUId" = EXCLUDED."currencyGUId",
                    "dealDateTime" = EXCLUDED."dealDateTime",
                    "directionCode" = EXCLUDED."directionCode",
                    "instrumentGUId" = EXCLUDED."instrumentGUId",
                    "orderGUId" = EXCLUDED."orderGUId",
                    "placeCode" = EXCLUDED."placeCode",
                    "planDeliveryDate" = EXCLUDED."planDeliveryDate",
                    "planPaymentDate" = EXCLUDED."planPaymentDate",
                    price = EXCLUDED.price,
                    quantity = EXCLUDED.quantity,
                    "tradeSessionGUId" = EXCLUDED."tradeSessionGUId",
                    "typeCode" = EXCLUDED."typeCode",
                    volume = EXCLUDED.volume
            RETURNING id, guid
    )
    select array_agg(id)
    FROM changed
    INTO dealsIds;

    -- Создание/Изменение/Удаление "exchangeDealsPersons"
    WITH changed("exchangeDealId", "personId") as (
        INSERT INTO "exchangeDealsPersonsSequenceOne" (comment, "exchangeDealId", "personId")
            SELECT D.comment,
                   DK.id,
                   D."personId"
            FROM (
                     SELECT *
                     FROM "exchangeDealsPersonsInternal" D
                 ) D
                     LEFT JOIN "exchangeDealsSequenceOne" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "personId") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "personId"
    )
    delete
    from "exchangeDealsPersonsSequenceOne" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."personId" = P2."personId");

    -- Создание/Изменение/Удаление "exchangeDealsStatuses"
    with changed("exchangeDealId", "index") as (
        INSERT INTO "exchangeDealsStatusesSequenceOne" (index, comment, "dateTime", "exchangeDealId", "typeId")
            SELECT D.index,
                   D.comment,
                   D."dateTime",
                   DK.id,
                   D."typeId"
            FROM (
                     SELECT *
                     FROM "exchangeDealsStatusesInternal" D
                 ) D
                     LEFT JOIN "exchangeDealsSequenceOne" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "index") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "index"
    )
    delete
    from "exchangeDealsStatusesSequenceOne" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."index" = P2."index");
end
$$;

alter procedure "exchangeDeals@SaveCopy.Cache.SequenceOne"(integer) owner to postgres;

