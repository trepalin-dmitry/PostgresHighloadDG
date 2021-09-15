create or replace procedure "exchangeDeals@Save.Database.SequenceBatch"(data character varying, size integer)
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
                   T.id,
                   D.volume
            FROM (
                     SELECT row_number() over (ORDER BY (SELECT NULL)) as "rowNumber",
                            D.*
                     FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (
                                                                  guid UUID,
                                                                  "accountGUId" UUID,
                                                                  "couponCurrencyGUId" UUID,
                                                                  "couponVolume" NUMERIC(19, 2),
                                                                  "currencyGUId" UUID,
                                                                  "dealDateTime" TIMESTAMP,
                                                                  "directionCode" VARCHAR(255),
                                                                  "instrumentGUId" UUID,
                                                                  "orderGUId" UUID,
                                                                  "placeCode" VARCHAR(255),
                                                                  "planDeliveryDate" DATE,
                                                                  "planPaymentDate" DATE,
                                                                  price NUMERIC(19, 2),
                                                                  quantity NUMERIC(19, 2),
                                                                  "tradeSessionGUId" UUID,
                                                                  "typeCode" VARCHAR(255),
                                                                  volume NUMERIC(19, 2)
                         )
                 ) D
                     LEFT JOIN (
                SELECT NV."rowNumber",
                       NV."nextVal"
                FROM next_val_table('exchange_deals_sequence_batch_id_seq', size) NV
            ) NV ON NV."rowNumber" = D."rowNumber"
                     LEFT JOIN "exchangeDealsTypes" T ON T.code = D."typeCode"
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
            SELECT P.comment,
                   DK.id,
                   PPP.id
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (guid UUID, "persons" JSONB)
                     LEFT JOIN "exchangeDealsSequenceBatch" AS DK ON DK.guid = D.guid
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."persons" :: JSONB) AS P
                         (
                          "personGUId" uuid,
                          comment CHARACTER VARYING(255)
                             )
                ) P
                     LEFT JOIN "persons" AS PPP ON PPP.guid = P."personGUId"
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
            SELECT P.index,
                   P.comment,
                   P."dateTime",
                   DK.id,
                   PPP.id
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (
                                                         guid UUID,
                                                         "statuses" JSONB
                )
                     LEFT JOIN "exchangeDealsSequenceBatch" AS DK ON DK.guid = D.guid
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."statuses" :: JSONB) AS P
                         (
                          "index" integer,
                          "comment" varchar(255),
                          "dateTime" timestamp,
                          "typeCode" varchar(255)
                             )
                ) P
                     LEFT JOIN "exchangeDealsStatusesTypes" AS PPP ON PPP.code = P."typeCode"
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

alter procedure "exchangeDeals@Save.Database.SequenceBatch"(varchar, integer) owner to postgres;

