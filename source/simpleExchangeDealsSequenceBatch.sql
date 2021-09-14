create table if not exists "simpleExchangeDealsSequenceBatch"
(
	id bigint not null
		constraint "simpleExchangeDealsSequenceBatch_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_d0fle3yeq6hv2dt9weciw39ms
			unique,
	"instrumentGUId" uuid not null,
	"orderGUId" uuid not null,
	"placeCode" varchar(255) not null,
	"planDeliveryDate" date not null,
	"planPaymentDate" date not null,
	price numeric(19,2) not null,
	quantity numeric(19,2) not null,
	"tradeSessionGUId" uuid not null,
	volume numeric(19,2) not null,
	"typeId" integer not null
		constraint fks2a9akkvgs0esi8wldt09c5fv
			references "exchangeDealsTypes"
);

alter table "simpleExchangeDealsSequenceBatch" owner to postgres;

