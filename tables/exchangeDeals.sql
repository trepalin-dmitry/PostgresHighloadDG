create table "exchangeDeals"
(
	guid uuid not null
		constraint "exchangeDeals_pkey"
			primary key,
	"accountGUId" uuid,
	"couponCurrencyGUId" uuid,
	"couponVolume" numeric(19,2),
	"currencyGUId" uuid,
	"dealDateTime" timestamp,
	"directionCode" varchar(255),
	"instrumentGUId" uuid,
	"orderGUId" uuid,
	"placeCode" varchar(255),
	"planDeliveryDate" date,
	"planPaymentDate" date,
	price numeric(19,2),
	quantity numeric(19,2),
	"tradeSessionGUId" uuid,
	"typeCode" varchar(255),
	volume numeric(19,2)
);

alter table "exchangeDeals" owner to postgres;

