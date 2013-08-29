--
--
CREATE OR REPLACE FUNCTION catalog_get_products_in_category(
	inCategoryID			category.id	%TYPE,
	inShortProductDescriptionLength	int,
	inProductsPerPage		int,
	inStartItem			product.id	%TYPE
) RETURNS SETOF product_list AS $_$
DECLARE
	outProductListRow	product_list;
BEGIN
	FOR outProductListRow IN
		SELECT p.id, p.name, p.description, p.price, p.discounted_price, p.thumbnail
		FROM product AS p
		INNER JOIN product_category AS pc ON p.id = pc.product_id
		WHERE pc.category_id = inCategoryID ORDER BY p.id LIMIT inProductsPerPage OFFSET inStartItem
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

