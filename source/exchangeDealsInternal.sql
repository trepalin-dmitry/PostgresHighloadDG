create table if not exists "exchangeDealsInternal"
(
	id bigserial
		constraint "exchangeDealsInternal_pkey"
			primary key,
	"uploadKey" uuid not null,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null,
	"instrumentGUId" uuid not null,
	"orderGUId" uuid not null,
	"placeCode" varchar(255) not null,
	"planDeliveryDate" date not null,
	"planPaymentDate" date not null,
	price numeric(19,2) not null,
	quantity numeric(19,2) not null,
	"tradeSessionGUId" uuid not null,
	"typeCode" varchar(255) not null,
	volume numeric(19,2) not null
);

alter table "exchangeDealsInternal" owner to postgres;

create index if not exists exchangedealsinternal_uploadkey_index
	on "exchangeDealsInternal" ("uploadKey");

