--
--
CREATE OR REPLACE FUNCTION catalog_get_products_on_catalog(
	inShortProductDescriptionLength	int,
	inProductsPerPage		int,
	inStartItem			product.id	%TYPE
) RETURNS SETOF product_list AS $_$
DECLARE
	outProductListRow	product_list;
BEGIN
	FOR outProductListRow IN
		SELECT id, name, description, price, discounted_price, thumbnail
		FROM product
		WHERE display = 1 OR display = 3 ORDER BY id LIMIT inProductsPerPage OFFSET inStartItem
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

