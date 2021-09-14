create or replace procedure "exchangeDeals@SaveCopy.Cache.SequenceBatch"(size integer)
	language plpgsql
as $$
DECLARE
    dealsIds bigint[];
begin

    -- Создание/Изменение "exchangeDeals"
    with changed(id) as (
        INSERT INTO "exchangeDealsSequenceBatch" (id, guid, "accountGUId", "couponCurrencyGUId", "couponVolume",
                                                  "currencyGUId",
                                                  "dealDateTime",
                                                  "directionCode", "instrumentGUId", "orderGUId", "placeCode",
                                                  "planDeliveryDate",
                                                  "planPaymentDate", price, quantity, "tradeSessionGUId", "typeId",
                                                  volume)
            SELECT NV."nextVal",
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
                   D."typeId",
                   D.volume
            FROM (
                     SELECT row_number() over (ORDER BY (SELECT NULL)) as "rowNumber",
                            D.*
                     FROM "exchangeDealsInternal" D
                 ) D
                     LEFT JOIN (
                SELECT NV."rowNumber",
                       NV."nextVal"
                FROM next_val_table('exchange_deals_sequence_batch_id_seq', size) NV
            ) NV ON NV."rowNumber" = D."rowNumber"
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
                    "typeId" = EXCLUDED."typeId",
                    volume = EXCLUDED.volume
            RETURNING id
    )
    select array_agg(id)
    FROM changed
    INTO dealsIds;

    -- Создание/Изменение/Удаление "exchangeDealsPersons"
    WITH changed("exchangeDealId", "personId") as (
        INSERT INTO "exchangeDealsPersonsSequenceBatch" (comment, "exchangeDealId", "personId")
            SELECT D.comment,
                   DK.id,
                   D."personId"
            FROM "exchangeDealsPersonsInternal" D
                     LEFT JOIN "exchangeDealsSequenceBatch" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "personId") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "personId"
    )
    delete
    from "exchangeDealsPersonsSequenceBatch" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."personId" = P2."personId");

    -- Создание/Изменение/Удаление "exchangeDealsStatuses"
    with changed("exchangeDealId", "index") as (
        INSERT INTO "exchangeDealsStatusesSequenceBatch" (index, comment, "dateTime", "exchangeDealId", "typeId")
            SELECT D.index,
                   D.comment,
                   D."dateTime",
                   DK.id,
                   D."typeId"
            FROM "exchangeDealsStatusesInternal" D
                     LEFT JOIN "exchangeDealsSequenceBatch" AS DK ON DK.guid = D."exchangeDealGuid"
            ON CONFLICT ("exchangeDealId", "index") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "index"
    )
    delete
    from "exchangeDealsStatusesSequenceBatch" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."index" = P2."index");
end ;
$$;

alter procedure "exchangeDeals@SaveCopy.Cache.SequenceBatch"(integer) owner to postgres;

