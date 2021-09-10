create table if not exists "exchangeDealsPersonsSequenceOne"
(
	comment varchar(255),
	"personId" integer not null
		constraint fkmi6npoinuga4vqwh7ae93d0ci
			references persons,
	"exchangeDealId" bigint not null
		constraint fk9iowyk68gxfc5geusge5emnr6
			references "exchangeDealsSequenceOne",
	constraint "exchangeDealsPersonsSequenceOne_pkey"
		primary key ("exchangeDealId", "personId")
);

alter table "exchangeDealsPersonsSequenceOne" owner to postgres;

