create or replace procedure "simpleExchangeDeals@SaveCopy.Database.Identity"(size integer)
	language plpgsql
as $$
begin
        INSERT INTO "simpleExchangeDealsIdentity" (guid, "accountGUId", "couponCurrencyGUId", "couponVolume", "currencyGUId",
                                             "dealDateTime",
                                             "directionCode", "instrumentGUId", "orderGUId", "placeCode",
                                             "planDeliveryDate",
                                             "planPaymentDate", price, quantity, "tradeSessionGUId", "typeId", volume)
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
                   T.id,
                   D.volume
            FROM "simpleExchangeDealsSource" D
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

alter procedure "simpleExchangeDeals@SaveCopy.Database.Identity"(integer) owner to postgres;

