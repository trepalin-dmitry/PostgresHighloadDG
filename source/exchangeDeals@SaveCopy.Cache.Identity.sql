create or replace procedure "exchangeDeals@SaveCopy.Cache.Identity"(uploadkey uuid, size integer)
	language plpgsql
as $$
DECLARE
    dealsIds bigint[];
begin

    -- Создание/Изменение "exchangeDeals"
    with changed(id, guid) as (
        INSERT INTO "exchangeDealsIdentity" (guid, "accountGUId", "couponCurrencyGUId", "couponVolume", "currencyGUId",
                                             "dealDateTime",
                                             "directionCode", "instrumentGUId", "orderGUId", "placeCode",
                                             "planDeliveryDate",
                                             "planPaymentDate", price, quantity, "tradeSessionGUId", "typeCode", volume)
            SELECT D.guid,
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
                     WHERE D."uploadKey" = uploadKey
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
        INSERT INTO "exchangeDealsPersonsIdentity" (comment, "exchangeDealId", "personId")
            SELECT D.comment,
                   DK.id,
                   D."personId"
            FROM (SELECT * FROM "exchangeDealsPersonsInternal" D WHERE D."uploadKey" = uploadKey) D
                     LEFT JOIN "exchangeDealsIdentity" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "personId") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "personId"
    )
    delete
    from "exchangeDealsPersonsIdentity" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."personId" = P2."personId");

    -- Создание/Изменение/Удаление "exchangeDealsStatuses"
    with changed("exchangeDealId", "index") as (
        INSERT INTO "exchangeDealsStatusesIdentity" (index, comment, "dateTime", "exchangeDealId", "typeId")
            SELECT D.index,
                   D.comment,
                   D."dateTime",
                   DK.id,
                   D."typeId"
            FROM (SELECT * FROM "exchangeDealsStatusesInternal" D WHERE D."uploadKey" = uploadKey) D
                     LEFT JOIN "exchangeDealsIdentity" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "index") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "index"
    )
    delete
    from "exchangeDealsStatusesIdentity" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."index" = P2."index");
end ;
$$;

alter procedure "exchangeDeals@SaveCopy.Cache.Identity"(uuid, integer) owner to postgres;

