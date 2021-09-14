create table if not exists "exchangeDealsSequenceBatch"
(
	id bigint not null
		constraint "exchangeDealsSequenceBatch_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_oe4m9pn5697xowiiglt772icm
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
		constraint fk5acaq6c1ikl5w0rdvua34p3bm
			references "exchangeDealsTypes"
);

alter table "exchangeDealsSequenceBatch" owner to postgres;

