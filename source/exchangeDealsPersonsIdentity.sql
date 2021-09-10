create table if not exists "exchangeDealsPersonsIdentity"
(
	comment varchar(255),
	"exchangeDealId" bigint not null
		constraint fkgjtpkg7ruvjs08v3un0qp5b2d
			references "exchangeDealsIdentity",
	"personId" integer not null
		constraint fkrffv427gxcj976p65naxr7nwb
			references persons,
	constraint "exchangeDealsPersonsIdentity_pkey"
		primary key ("exchangeDealId", "personId")
);

alter table "exchangeDealsPersonsIdentity" owner to postgres;

