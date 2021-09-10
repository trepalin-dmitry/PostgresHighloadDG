create table if not exists "exchangeDealsStatusesSequenceBatch"
(
	index integer not null,
	comment varchar(255),
	"dateTime" timestamp not null,
	"exchangeDealId" bigint not null
		constraint fkm1bs91sopesricchnl1yvfgei
			references "exchangeDealsSequenceBatch",
	"typeId" char not null
		constraint fk9pyyyj38mbdn078ukd2kjok49
			references "exchangeDealsStatusesTypes",
	constraint "exchangeDealsStatusesSequenceBatch_pkey"
		primary key ("exchangeDealId", index)
);

alter table "exchangeDealsStatusesSequenceBatch" owner to postgres;

