create or replace procedure "simpleExchangeDeals@Save.Cache.SequenceBatch"(data character varying, size integer)
	language plpgsql
as $$
begin
    INSERT INTO "simpleExchangeDealsSequenceBatch" (id, guid, "accountGUId", "couponCurrencyGUId", "couponVolume",
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
                                                          "typeId" INTEGER,
                                                          volume NUMERIC(19, 2)
                 )
         ) D
             LEFT JOIN (
        SELECT NV."rowNumber",
               NV."nextVal"
        FROM next_val_table('simple_exchange_deals_sequence_batch_id_seq', size) NV
    ) NV ON NV."rowNumber" = D."rowNumber"
    ON CONFLICT (guid) DO UPDATE
        SET "accountGUId"        = EXCLUDED."accountGUId",
            "couponCurrencyGUId" = EXCLUDED."couponCurrencyGUId",
            "couponVolume"       = EXCLUDED."couponVolume",
            "currencyGUId"       = EXCLUDED."currencyGUId",
            "dealDateTime"       = EXCLUDED."dealDateTime",
            "directionCode"      = EXCLUDED."directionCode",
            "instrumentGUId"     = EXCLUDED."instrumentGUId",
            "orderGUId"          = EXCLUDED."orderGUId",
            "placeCode"          = EXCLUDED."placeCode",
            "planDeliveryDate"   = EXCLUDED."planDeliveryDate",
            "planPaymentDate"    = EXCLUDED."planPaymentDate",
            price                = EXCLUDED.price,
            quantity             = EXCLUDED.quantity,
            "tradeSessionGUId"   = EXCLUDED."tradeSessionGUId",
            "typeId"             = EXCLUDED."typeId",
            volume               = EXCLUDED.volume;
end ;
$$;

alter procedure "simpleExchangeDeals@Save.Cache.SequenceBatch"(varchar, integer) owner to postgres;

