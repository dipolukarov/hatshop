--
--
CREATE OR REPLACE FUNCTION catalog_get_product_details(
	inProductID	product.id	%TYPE
) RETURNS product_details AS $_$
DECLARE
	outProductDetailsRow	product_details;
BEGIN
	SELECT id, name, description, price, discounted_price, image INTO outProductDetailsRow FROM product WHERE id = inProductID;
	RETURN outProductDetailsRow;
END;
$_$ LANGUAGE $_$plpgsql$_$;

