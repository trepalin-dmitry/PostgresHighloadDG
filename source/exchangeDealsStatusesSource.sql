create table if not exists "exchangeDealsStatusesSource"
(
	id bigserial
		constraint "exchangeDealsStatusesSource_pkey"
			primary key,
	"uploadKey" uuid not null,
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealGuid" uuid not null,
	"typeCode" varchar(255) not null
);

alter table "exchangeDealsStatusesSource" owner to postgres;

create index if not exists exchangedealsstatusessource_uploadkey_index
	on "exchangeDealsStatusesSource" ("uploadKey");

