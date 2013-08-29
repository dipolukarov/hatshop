--
--
CREATE OR REPLACE FUNCTION catalog_get_department_details(
	inDepartmentID	department.id	%TYPE
) RETURNS department_details AS $_$
DECLARE
	outDepartmentDetailsRow	department_details;
BEGIN
	SELECT name, description INTO outDepartmentDetailsRow FROM department WHERE id = inDepartmentID;
	RETURN outDepartmentDetailsRow;
END;
$_$ LANGUAGE $_$plpgsql$_$;

