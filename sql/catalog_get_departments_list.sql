--
--
CREATE OR REPLACE FUNCTION catalog_get_departments_list(
) RETURNS SETOF department_list AS $_$
DECLARE
	outDepartmentListRow	department_list;
BEGIN
	FOR outDepartmentListRow IN SELECT id, name FROM department ORDER BY id LOOP
		RETURN NEXT outDepartmentListRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

