--
--
CREATE OR REPLACE FUNCTION catalog_update_department(
	inDepartmentId	department.id		%TYPE,
	inName		department.name		%TYPE,
	inDescription	department.description	%TYPE
) RETURNS void AS $_$
BEGIN
	UPDATE department SET name = inName, description = inDescription WHERE id = inDepartmentId;
END;
$_$ LANGUAGE $_$plpgsql$_$;

