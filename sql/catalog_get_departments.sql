--
--
CREATE OR REPLACE FUNCTION catalog_get_departments(
) RETURNS SETOF department AS $_$
DECLARE
	outDepartmentRow	department;
BEGIN
	FOR outDepartmentRow IN SELECT id, name, description FROM department ORDER BY id LOOP
		RETURN NEXT outDepartmentRow;
	END LOOP;
END;
$_$ LANGUAGE $_$plpgsql$_$;

