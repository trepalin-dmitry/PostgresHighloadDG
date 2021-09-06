create table "exchangeDealsPersons"
(
	comment varchar(255),
	"exchangeDealId" bigint not null
		constraint fk6mlcvg5scxe382hlauv947nch
			references "exchangeDeals",
	"personId" integer not null
		constraint fkko3j0xwesgn746akjvsmyege8
			references persons,
	constraint "exchangeDealsPersons_pkey"
		primary key ("exchangeDealId", "personId")
);

alter table "exchangeDealsPersons" owner to postgres;

