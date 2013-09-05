--
--
CREATE OR REPLACE FUNCTION catalog_delete_department(
	inDepartmentId	department.id		%TYPE
) RETURNS int AS $_$
DECLARE
	categoryRowsCount	int;
BEGIN
	SELECT count(*) INTO categoryRowsCount FROM category WHERE department_id = inDepartmentId;
	IF categoryRowsCount = 0 THEN
		DELETE FROM department WHERE id = inDepartmentId;
		RETURN 1;
	END IF;
	RETURN -1;
END;
$_$ LANGUAGE $_$plpgsql$_$;

