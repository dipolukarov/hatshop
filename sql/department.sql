--
--
CREATE TABLE department
(
	id		serial,
	name		varchar(50) NOT NULL,
	description	text,
CONSTRAINT department_pk PRIMARY KEY (id)
);

