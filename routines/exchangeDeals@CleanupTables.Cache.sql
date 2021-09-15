create or replace procedure "exchangeDeals@CleanupTables.Cache"()
	language plpgsql
as $$
begin
    truncate table "exchangeDealsInternal";
    truncate table "exchangeDealsPersonsInternal";
    truncate table "exchangeDealsStatusesInternal";
end ;
$$;

alter procedure "exchangeDeals@CleanupTables.Cache"() owner to postgres;

