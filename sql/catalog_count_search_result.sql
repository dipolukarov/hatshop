--
--
CREATE OR REPLACE FUNCTION catalog_count_search_result(
	inWords		text[],		-- is an array with the words from users's search string
	inAllWords	varchar(3)	-- is 'on' for all-words searches and 'off' for any-words searches
) RETURNS int AS $_$
DECLARE
	outSearchResultCount	int;
	query			text;
	search_operator		varchar(1);
BEGIN
	-- Initialize query with an empty string
	query := '';
	-- Establish the operator to be used when preparing the search string
	IF inAllWords = 'on' THEN
		search_operator := '&';
	ELSE
		search_operator := '|';
	END IF;

	-- Compose the search string
	FOR i IN array_lower(inWords, 1)..array_upper(inWords, 1) LOOP
		IF i = array_upper(inWords, 1) THEN
			query := query || inWords[i];
		ELSE
			query := query || inWords[i] || search_operator;
		END IF;
	END LOOP;

	-- Return the number of matches
	SELECT count(*) INTO outSearchResultCount
	FROM product, to_tsquery(query) AS query_string
	WHERE search_vector @@ query_string;
	RETURN outSearchResultCount;
END;
$_$ LANGUAGE $_$plpgsql$_$;

