create or replace function next_val_table(sequence_name character varying, size bigint) returns TABLE("rowNumber" bigint, "nextVal" bigint)
	language plpgsql
as $$
DECLARE
    lastVal   bigint;
    increment bigint;
    nextVal   bigint;
BEGIN
    increment := (SELECT seqincrement
                  FROM pg_sequence
                  WHERE seqrelid = sequence_name::regclass::oid
                  LIMIT 1);

    nextVal := nextVal(sequence_name);
    lastVal := nextVal + increment - 1;

    FOR rowNumber IN 1..size
        LOOP
            nextVal := nextVal + 1;

            IF nextVal > lastVal THEN
                nextVal := nextVal(sequence_name);
                lastVal := nextVal + increment - 1;
            END IF;

            SELECT INTO "nextVal" nextVal;
            SELECT INTO "rowNumber" rowNumber;
            RETURN NEXT;
        END LOOP;

    RETURN;
END;
$$;

alter function next_val_table(varchar, bigint) owner to postgres;

