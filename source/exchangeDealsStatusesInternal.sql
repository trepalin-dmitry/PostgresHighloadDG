create table if not exists "exchangeDealsStatusesInternal"
(
	id bigserial
		constraint "exchangeDealsStatusesInternal_pkey"
			primary key,
	"uploadKey" uuid not null,
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealGuid" uuid not null,
	"typeId" char not null
);

alter table "exchangeDealsStatusesInternal" owner to postgres;

create index if not exists exchangedealsstatusesinternal_uploadkey_index
	on "exchangeDealsStatusesInternal" ("uploadKey");

