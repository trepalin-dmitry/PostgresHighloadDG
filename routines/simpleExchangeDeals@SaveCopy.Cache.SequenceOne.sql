create or replace procedure "simpleExchangeDeals@SaveCopy.Cache.SequenceOne"(size integer)
	language plpgsql
as $$
begin
        INSERT INTO "simpleExchangeDealsSequenceOne" (id, guid, "accountGUId", "couponCurrencyGUId", "couponVolume",
                                                "currencyGUId",
                                                "dealDateTime",
                                                "directionCode", "instrumentGUId", "orderGUId", "placeCode",
                                                "planDeliveryDate",
                                                "planPaymentDate", price, quantity, "tradeSessionGUId", "typeId",
                                                volume)
            SELECT nextval('simple_exchange_deals_sequence_one_id_seq'),
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
            FROM "simpleExchangeDealsInternal" D
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
end
$$;

alter procedure "simpleExchangeDeals@SaveCopy.Cache.SequenceOne"(integer) owner to postgres;

