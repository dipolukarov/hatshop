--
--
CREATE OR REPLACE FUNCTION catalog_count_products_in_department(
	inDepartmentID	category.department_id	%TYPE
) RETURNS int AS $_$
DECLARE
	outProductsOnDepartmentCount	int;
BEGIN
	SELECT DISTINCT count(*) INTO outProductsOnDepartmentCount FROM product AS p
	INNER JOIN product_category AS pc ON p.id = pc.product_id
	INNER JOIN category AS c ON pc.category_id = c.id
	WHERE (p.display = 2 OR p.display = 3)
	AND c.department_id = inDepartmentID;
	RETURN outProductsOnDepartmentCount;
END;
$_$ LANGUAGE $_$plpgsql$_$;

