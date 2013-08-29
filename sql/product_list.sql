--
--
CREATE TYPE product_list AS
(
	id			int,
	name			varchar(50),
	description		text,
	price			numeric(10,2),
	discounted_price	numeric(10,2),
	thumbnail		varchar(150)
);

