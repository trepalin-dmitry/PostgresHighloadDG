create table if not exists "simpleExchangeDealsIdentity"
(
	id bigserial
		constraint "simpleExchangeDealsIdentity_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_rdtmibo4ckifti210779n4ln7
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
		constraint fk6sgb5j9yayasan37pbrg9xj1v
			references "exchangeDealsTypes"
);

alter table "simpleExchangeDealsIdentity" owner to postgres;
