--
--
CREATE TABLE product
(
	id			serial,
	name			varchar(50) NOT NULL,
	description		text NOT NULL,
	price			numeric(10,2) NOT NULL,
	discounted_price	numeric(10,2) NOT NULL DEFAULT .00,
	image			varchar(150),
	thumbnail		varchar(150),
	display			int NOT NULL DEFAULT 0,
CONSTRAINT product_pk PRIMARY KEY (id)
);

