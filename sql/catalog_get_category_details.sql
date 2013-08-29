--
--
CREATE OR REPLACE FUNCTION catalog_get_category_details(
	inCategoryID	category.id	%TYPE
) RETURNS category_details AS $_$
DECLARE
	outCategoryDetailsRow	category_details;
BEGIN
	SELECT name, description INTO outCategoryDetailsRow FROM category WHERE id = inCategoryID;
	RETURN outCategoryDetailsRow;
END;
$_$ LANGUAGE $_$plpgsql$_$;

