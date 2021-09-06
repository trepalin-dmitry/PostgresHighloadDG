create table "exchangeDealsStatuses"
(
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealId" bigint not null
		constraint fkimcbymq12pubqunm8n5554e9g
			references "exchangeDeals",
	"typeId" char not null
		constraint fklocmh2wr0vewp4q79go1uqwp0
			references "exchangeDealsStatusesTypes",
	constraint "exchangeDealsStatuses_pkey"
		primary key ("exchangeDealId", index)
);

alter table "exchangeDealsStatuses" owner to postgres;

