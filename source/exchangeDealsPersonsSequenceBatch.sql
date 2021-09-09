create table if not exists "exchangeDealsPersonsSequenceBatch"
(
	comment varchar(255),
	"exchangeDealId" bigint not null
		constraint fk1t2j4sl4hune29eqengff3qko
			references "exchangeDealsSequenceBatch",
	"personId" integer not null
		constraint fkchggaheq6wc0my3ymxjw5kdw0
			references persons,
	constraint "exchangeDealsPersonsSequenceBatch_pkey"
		primary key ("exchangeDealId", "personId")
);

alter table "exchangeDealsPersonsSequenceBatch" owner to postgres;

