create or replace procedure "simpleExchangeDeals@CleanupTables.Database"()
	language plpgsql
as $$
begin
    truncate table "simpleExchangeDealsSource";
end ;
$$;

alter procedure "simpleExchangeDeals@CleanupTables.Database"() owner to postgres;

