create table if not exists "exchangeDealsStatusesIdentity"
(
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealId" bigint not null
		constraint fk2vcvvleg4f6kchk58mois2nlw
			references "exchangeDealsIdentity",
	"typeId" char not null
		constraint fkt1tikqyje717gqkde7iktc2ti
			references "exchangeDealsStatusesTypes",
	constraint "exchangeDealsStatusesIdentity_pkey"
		primary key ("exchangeDealId", index)
);

alter table "exchangeDealsStatusesIdentity" owner to postgres;

