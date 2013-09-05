--
--
CREATE OR REPLACE FUNCTION catalog_add_department(
	inName		department.name		%TYPE,
	inDescription	department.description	%TYPE
) RETURNS void AS $_$
BEGIN
	INSERT INTO department (name, description) VALUES (inName, inDescription);
END;
$_$ LANGUAGE $_$plpgsql$_$;

