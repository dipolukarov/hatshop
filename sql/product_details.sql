--
--
CREATE TYPE product_details AS
(
	id			int,
	name			varchar(50),
	description		text,
	price			numeric(10,2),
	discounted_price	numeric(10,2),
	image			varchar(150)
);

