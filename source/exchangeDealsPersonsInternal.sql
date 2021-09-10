create table if not exists "exchangeDealsPersonsInternal"
(
	id bigserial
		constraint "exchangeDealsPersonsInternal_pkey"
			primary key,
	"uploadKey" uuid not null,
	comment varchar(255),
	"exchangeDealGuid" uuid not null,
	"personId" integer not null
);

alter table "exchangeDealsPersonsInternal" owner to postgres;

create index if not exists exchangedealspersonsinternal_uploadkey_index
	on "exchangeDealsPersonsInternal" ("uploadKey");

