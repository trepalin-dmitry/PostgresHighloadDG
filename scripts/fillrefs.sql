CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

insert into persons(guid, name)
SELECT uuid_generate_v4(),
       md5(random()::text)
FROM generate_series(1, 100000) i;

insert INTO "exchangeDealsStatusesTypes"(id, code, name)
SELECT chr(i),
       chr(i) || 'code',
       chr(i) || 'name'
FROM generate_series(65, 75) i;