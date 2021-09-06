create procedure "exchangeDeals@Save.Ids"(data character varying)
	language plpgsql
as $$
DECLARE
    dealsIds bigint[];
begin

    -- Создание/Изменение "exchangeDeals"
    with changed(id, guid) as (
        INSERT INTO "exchangeDeals" (guid, "accountGUId", "couponCurrencyGUId", "couponVolume", "currencyGUId",
                                     "dealDateTime",
                                     "directionCode", "instrumentGUId", "orderGUId", "placeCode", "planDeliveryDate",
                                     "planPaymentDate", price, quantity, "tradeSessionGUId", "typeCode", volume)
            SELECT D.*
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
        INSERT INTO "exchangeDealsPersons" (comment, "exchangeDealId", "personId")
            SELECT P.comment,
                   DK.id,
                   P."personId"
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (guid UUID, "persons" JSONB)
                     LEFT JOIN "exchangeDeals" AS DK ON DK.guid = D.guid
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."persons" :: JSONB) AS P
                         (
                          "personId" integer,
                          comment CHARACTER VARYING(255)
                             )
                ) P
            ON CONFLICT ("exchangeDealId", "personId") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "personId"
    )
    delete
    from "exchangeDealsPersons" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."personId" = P2."personId");

    -- Создание/Изменение/Удаление "exchangeDealsStatuses"
    with changed("exchangeDealId", "index") as (
        INSERT INTO "exchangeDealsStatuses" (index, comment, "dateTime", "exchangeDealId", "typeId")
            SELECT P.index,
                   P.comment,
                   P."dateTime",
                   DK.id,
                   P."typeId"
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (
                                                         guid UUID,
                                                         "statuses" JSONB
                )
                     LEFT JOIN "exchangeDeals" AS DK ON DK.guid = D.guid
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."statuses" :: JSONB) AS P
                         (
                          "index" integer,
                          "comment" varchar(255),
                          "dateTime" timestamp,
                          "typeId" char
                             )
                ) P
            ON CONFLICT ("exchangeDealId", "index") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "index"
    )
    delete
    from "exchangeDealsStatuses" P2
    where P2."exchangeDealId" = any (dealsIds)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."index" = P2."index");
end ;
$$;

alter procedure "exchangeDeals@Save.Ids"(varchar) owner to postgres;

