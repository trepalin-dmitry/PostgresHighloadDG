create table if not exists persons
(
	id serial
		constraint persons_pkey
			primary key,
	guid uuid
		constraint uk_2wacmqx51ru2xqiymb7459uj3
			unique,
	name varchar(255)
);

alter table persons owner to postgres;

