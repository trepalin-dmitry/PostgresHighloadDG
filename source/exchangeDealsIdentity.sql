create table if not exists "exchangeDealsIdentity"
(
	id bigserial
		constraint "exchangeDealsIdentity_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_7qchffs1v16pfgwgyqh8ltrbu
			unique,
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

alter table "exchangeDealsIdentity" owner to postgres;

