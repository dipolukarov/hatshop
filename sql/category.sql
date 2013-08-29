--
--
CREATE TABLE category
(
	id		serial,
	department_id	int NOT NULL,
	name		varchar(50) NOT NULL,
	description	text,
CONSTRAINT category_pk PRIMARY KEY (id),
CONSTRAINT category_f0 FOREIGN KEY (department_id) REFERENCES department (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

