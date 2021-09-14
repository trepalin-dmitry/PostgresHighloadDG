-- DELETE FROM "exchangeDealsPersonsSequenceOne";
-- DELETE FROM "exchangeDealsPersonsSequenceBatch";
-- DELETE FROM "exchangeDealsPersonsIdentity";
--
-- DELETE FROM "exchangeDealsStatusesSequenceOne";
-- DELETE FROM "exchangeDealsStatusesSequenceBatch";
-- DELETE FROM "exchangeDealsStatusesIdentity";
--
-- DELETE FROM "exchangeDealsIdentity";
-- DELETE FROM "exchangeDealsSequenceBatch";
-- DELETE FROM "exchangeDealsSequenceOne";

SELECT (SELECT count(*) FROM "exchangeDealsIdentity"),
       (SELECT count(*) FROM "exchangeDealsSequenceOne"),
       (SELECT count(*) FROM "exchangeDealsSequenceBatch");

SELECT * FROM "exchangeDealsTypes" T WHERE T.code = 'qxJeApM'