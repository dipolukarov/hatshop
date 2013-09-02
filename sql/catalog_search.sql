--
--
CREATE OR REPLACE FUNCTION catalog_search(
	inWords				text[],
	inAllWords			varchar(3),
	inShortProductDescriptionLength	int,
	inProductsPerPage		int,
	inStartPage			int
) RETURNS SETOF product_list AS $_$
DECLARE
	outProductListRow	product_list;
	query			text;
	search_operator		varchar(1);
	query_string		tsquery;
BEGIN
	-- Initialize query with an empty string
	query := '';
	-- All-words or Any-words
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
	query_string := to_tsquery(query);

	-- Return the search result
	FOR outProductListRow IN
		SELECT id, name, description, price, discounted_price, thumbnail
		FROM product
		WHERE search_vector @@ query_string
		ORDER BY ts_rank(search_vector, query_string) DESC LIMIT inProductsPerPage OFFSET inStartPage
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

