create table if not exists "exchangeDealsStatusesSequenceOne"
(
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealId" bigint not null
		constraint fkrlcuuklqlnwdsvy3ke8tyfbcs
			references "exchangeDealsSequenceOne",
	"typeId" char not null
		constraint fkhcekeo9yrhwksdsjb2esa6c7y
			references "exchangeDealsStatusesTypes",
	constraint "exchangeDealsStatusesSequenceOne_pkey"
		primary key ("exchangeDealId", index)
);

alter table "exchangeDealsStatusesSequenceOne" owner to postgres;

