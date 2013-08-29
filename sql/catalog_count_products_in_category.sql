--
--
CREATE OR REPLACE FUNCTION catalog_count_products_in_category(
	inCategoryID	product_category.category_id	%TYPE
) RETURNS int AS $_$
DECLARE
	outCategoriesCount	int;
BEGIN
	SELECT count(*) INTO outCategoriesCount FROM product AS p
	INNER JOIN product_category AS pc ON p.id = pc.product_id
	WHERE pc.category_id = inCategoryID;
	RETURN outCategoriesCount;
END;
$_$ LANGUAGE $_$plpgsql$_$;

