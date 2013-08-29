--
--
CREATE TABLE product_category
(
	product_id	int NOT NULL,
	category_id	int NOT NULL,
CONSTRAINT product_category_pk PRIMARY KEY (product_id, category_id),
CONSTRAINT product_category_f0 FOREIGN KEY (product_id) REFERENCES product (id) ON UPDATE RESTRICT ON DELETE RESTRICT,
CONSTRAINT product_category_f1 FOREIGN KEY (category_id) REFERENCES category (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

