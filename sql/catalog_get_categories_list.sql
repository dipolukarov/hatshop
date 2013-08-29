--
--
CREATE OR REPLACE FUNCTION catalog_get_categories_list(
	inDepartmentID	category.department_id	%TYPE
) RETURNS SETOF category_list AS $_$
DECLARE
	outCategoryListRow	category_list;
BEGIN
	FOR outCategoryListRow IN SELECT id, name FROM category WHERE department_id = inDepartmentID ORDER BY id LOOP
		RETURN NEXT outCategoryListRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

