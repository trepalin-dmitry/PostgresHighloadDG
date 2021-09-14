create table if not exists "simpleExchangeDealsSequenceOne"
(
	id bigint not null
		constraint "simpleExchangeDealsSequenceOne_pkey"
			primary key,
	"accountGUId" uuid not null,
	"couponCurrencyGUId" uuid not null,
	"couponVolume" numeric(19,2) not null,
	"currencyGUId" uuid not null,
	"dealDateTime" timestamp not null,
	"directionCode" varchar(255) not null,
	guid uuid not null
		constraint uk_9e159ir62px6n355vm0bfsyev
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
		constraint fk374pfjahj19m9f6xgxhoamxoa
			references "exchangeDealsTypes"
);

alter table "simpleExchangeDealsSequenceOne" owner to postgres;

