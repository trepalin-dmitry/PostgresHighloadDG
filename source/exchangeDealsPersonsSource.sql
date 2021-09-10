create table if not exists "exchangeDealsPersonsSource"
(
	id bigserial
		constraint "exchangeDealsPersonsSource_pkey"
			primary key,
	"uploadKey" uuid not null,
	comment varchar(255),
	"exchangeDealGuid" uuid not null,
	"personGuid" uuid not null
);

alter table "exchangeDealsPersonsSource" owner to postgres;

create index if not exists exchangedealspersonssource_uploadkey_index
	on "exchangeDealsPersonsSource" ("uploadKey");

