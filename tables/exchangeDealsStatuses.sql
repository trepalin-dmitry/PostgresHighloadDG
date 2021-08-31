create table "exchangeDealsStatuses"
(
	index integer not null,
	comment varchar(255),
	"statusDateTime" timestamp,
	"statusTypeCode" varchar(255),
	"exchangeDealId" uuid not null
		constraint fkimcbymq12pubqunm8n5554e9g
			references "exchangeDeals",
	constraint "exchangeDealsStatuses_pkey"
		primary key ("exchangeDealId", index)
);

alter table "exchangeDealsStatuses" owner to postgres;

