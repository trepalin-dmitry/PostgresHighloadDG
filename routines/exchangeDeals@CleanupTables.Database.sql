create or replace procedure "exchangeDeals@CleanupTables.Database"()
	language plpgsql
as $$
begin
    truncate table "exchangeDealsSource";
    truncate table "exchangeDealsPersonsSource";
    truncate table "exchangeDealsStatusesSource";
end ;
$$;

alter procedure "exchangeDeals@CleanupTables.Database"() owner to postgres;

