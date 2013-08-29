--
--
CREATE OR REPLACE FUNCTION catalog_count_products_on_catalog(
) RETURNS int AS $_$
DECLARE
	outProductsOnCatalogCount	int;
BEGIN
	SELECT count(*) INTO outProductsOnCatalogCount FROM product
	WHERE display = 1 OR display = 3;
	RETURN outProductsOnCatalogCount;
END;
$_$ LANGUAGE $_$plpgsql$_$;

