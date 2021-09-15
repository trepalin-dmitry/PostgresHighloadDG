create or replace procedure "simpleExchangeDeals@CleanupTables.Cache"()
	language plpgsql
as $$
begin
    truncate table "simpleExchangeDealsInternal";
end ;
$$;

alter procedure "simpleExchangeDeals@CleanupTables.Cache"() owner to postgres;

