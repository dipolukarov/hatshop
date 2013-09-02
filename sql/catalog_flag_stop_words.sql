--
--
CREATE OR REPLACE FUNCTION catalog_flag_stop_words(
	inWords	text[]
) RETURNS SETOF int AS $_$
DECLARE
	outFlag	int;
	query	text;
BEGIN
	FOR i IN array_lower(inWords, 1)..array_upper(inWords, 1) LOOP
		SELECT to_tsquery(inWords[i]) INTO query;
		IF query = '' THEN
			outFlag := 1;
		ELSE
			outFlag := 0;
		END IF;
		RETURN NEXT outFlag;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

