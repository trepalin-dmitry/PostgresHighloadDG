create procedure "exchangeDeals@Save"(data character varying)
	language plpgsql
as $$
DECLARE
    dealsKeys uuid[];
begin

    -- Создание/Изменение "exchangeDeals"
    with changed(guid) as (
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
            RETURNING guid
    )
    SELECT array_agg(guid)
    FROM changed
    INTO dealsKeys;

    -- Создание/Изменение/Удаление "exchangeDealsPersons"
    with changed("exchangeDealId", "personGUId") as (
        INSERT INTO "exchangeDealsPersons" ("personGUId", "comment", "exchangeDealId")
            SELECT P."personGUId",
                   P.comment,
                   D.guid
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (
                                                         guid UUID,
                                                         "persons" JSONB
                )
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."persons" :: JSONB) AS P
                         (
                          "personGUId" UUID,
                          comment CHARACTER VARYING(255)
                             )
                ) P
            ON CONFLICT ("exchangeDealId", "personGUId") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "personGUId"
    )
    delete
    from "exchangeDealsPersons" P2
    where P2."exchangeDealId" = any (dealsKeys)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."personGUId" = P2."personGUId");

    -- Создание/Изменение/Удаление "exchangeDealsStatuses"
    with changed("exchangeDealId", "index") as (
        INSERT INTO "exchangeDealsStatuses" (index, comment, "statusDateTime", "statusTypeCode", "exchangeDealId")
            SELECT P.index,
                   P.comment,
                   P."statusDateTime",
                   P."statusTypeCode",
                   D.guid
            FROM JSONB_TO_RECORDSET(data :: JSONB) AS D (
                                                         guid UUID,
                                                         "statuses" JSONB
                )
                     CROSS JOIN LATERAL
                (
                SELECT P.*
                FROM JSONB_TO_RECORDSET(D."statuses" :: JSONB) AS P
                         (
                          index integer,
                          comment varchar(255),
                          "statusDateTime" timestamp,
                          "statusTypeCode" varchar(255)
                             )
                ) P
            ON CONFLICT ("exchangeDealId", "index") DO UPDATE
                SET comment = EXCLUDED.comment
            RETURNING "exchangeDealId", "index"
    )
    delete
    from "exchangeDealsStatuses" P2
    where P2."exchangeDealId" = any (dealsKeys)
      and not exists(select *
                     from changed C
                     where C."exchangeDealId" = P2."exchangeDealId"
                       AND C."index" = P2."index");
end;
$$;

alter procedure "exchangeDeals@Save"(varchar) owner to postgres;

