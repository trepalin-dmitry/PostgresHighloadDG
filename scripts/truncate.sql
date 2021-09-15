truncate table "exchangeDealsPersonsIdentity";
truncate table "exchangeDealsStatusesIdentity";
DELETE FROM "exchangeDealsIdentity";

truncate table "exchangeDealsPersonsSequenceOne";
truncate table "exchangeDealsStatusesSequenceOne";
DELETE FROM "exchangeDealsSequenceOne";

truncate table "exchangeDealsPersonsSequenceBatch";
truncate table "exchangeDealsStatusesSequenceBatch";
DELETE FROM "exchangeDealsSequenceBatch";

truncate table "simpleExchangeDealsIdentity";
truncate table "simpleExchangeDealsSequenceOne";
truncate table "simpleExchangeDealsSequenceBatch";