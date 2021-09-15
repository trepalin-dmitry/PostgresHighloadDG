create or replace procedure "simpleExchangeDeals@SaveCopy.Database.SequenceBatch"(size integer)
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
                   T.id,
                   D.volume
            FROM (
                     SELECT row_number() over (ORDER BY (SELECT NULL)) as "rowNumber",
                            D.*
                     FROM "simpleExchangeDealsSource" D
                 ) D
                     LEFT JOIN (
                SELECT NV."rowNumber",
                       NV."nextVal"
                FROM next_val_table('simple_exchange_deals_sequence_batch_id_seq', size) NV
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
                    volume = EXCLUDED.volume;
end ;
$$;

alter procedure "simpleExchangeDeals@SaveCopy.Database.SequenceBatch"(integer) owner to postgres;

