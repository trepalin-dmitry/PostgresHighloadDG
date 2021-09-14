create table if not exists "exchangeDealsSequenceOne"
(
	id bigint not null
		constraint "exchangeDealsSequenceOne_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_rgmwmx01w9dcqpx5xql6vulcd
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
		constraint fkgmypklymu2eyqpj85m1jgfauk
			references "exchangeDealsTypes"
);

alter table "exchangeDealsSequenceOne" owner to postgres;

