create table if not exists "exchangeDealsStatusesTypes"
(
	id char not null
		constraint "exchangeDealsStatusesTypes_pkey"
			primary key,
	code varchar(255)
		constraint uk_hdwouqxarb3ndf7gmflyyclxd
			unique,
	name varchar(255)
);

alter table "exchangeDealsStatusesTypes" owner to postgres;

