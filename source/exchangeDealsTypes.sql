create table if not exists "exchangeDealsTypes"
(
	id serial
		constraint "exchangeDealsTypes_pkey"
			primary key,
	code varchar(255)
		constraint uk_6ijf2b1m1e95yjpb86ti0270k
			unique,
	name varchar(255)
);

alter table "exchangeDealsTypes" owner to postgres;

