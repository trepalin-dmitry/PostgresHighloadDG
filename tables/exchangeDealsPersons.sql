create table "exchangeDealsPersons"
(
	"personGUId" uuid not null,
	comment varchar(255),
	"exchangeDealId" uuid not null
		constraint fk6mlcvg5scxe382hlauv947nch
			references "exchangeDeals",
	constraint "exchangeDealsPersons_pkey"
		primary key ("exchangeDealId", "personGUId")
);

alter table "exchangeDealsPersons" owner to postgres;

