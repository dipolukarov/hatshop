--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: category_details; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE category_details AS (
	name character varying(50),
	description text
);


ALTER TYPE public.category_details OWNER TO hatshopadmin;

--
-- Name: category_list; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE category_list AS (
	id integer,
	name character varying(50)
);


ALTER TYPE public.category_list OWNER TO hatshopadmin;

--
-- Name: department_details; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE department_details AS (
	name character varying(50),
	description text
);


ALTER TYPE public.department_details OWNER TO hatshopadmin;

--
-- Name: department_list; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE department_list AS (
	id integer,
	name character varying(50)
);


ALTER TYPE public.department_list OWNER TO hatshopadmin;

--
-- Name: product_details; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE product_details AS (
	id integer,
	name character varying(50),
	description text,
	price numeric(10,2),
	discounted_price numeric(10,2),
	image character varying(150)
);


ALTER TYPE public.product_details OWNER TO hatshopadmin;

--
-- Name: product_list; Type: TYPE; Schema: public; Owner: hatshopadmin
--

CREATE TYPE product_list AS (
	id integer,
	name character varying(50),
	description text,
	price numeric(10,2),
	discounted_price numeric(10,2),
	thumbnail character varying(150)
);


ALTER TYPE public.product_list OWNER TO hatshopadmin;

--
-- Name: catalog_count_products_in_category(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_count_products_in_category(incategoryid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	outCategoriesCount	int;
BEGIN
	SELECT count(*) INTO outCategoriesCount FROM product AS p
	INNER JOIN product_category AS pc ON p.id = pc.product_id
	WHERE pc.category_id = inCategoryID;
	RETURN outCategoriesCount;
END;
$$;


ALTER FUNCTION public.catalog_count_products_in_category(incategoryid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_count_products_on_catalog(); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_count_products_on_catalog() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductsOnCatalogCount	int;
BEGIN
	SELECT count(*) INTO outProductsOnCatalogCount FROM product
	WHERE display = 1 OR display = 3;
	RETURN outProductsOnCatalogCount;
END;
$$;


ALTER FUNCTION public.catalog_count_products_on_catalog() OWNER TO hatshopadmin;

--
-- Name: catalog_count_products_on_department(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_count_products_on_department(indepartmentid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductsOnDepartmentCount	int;
BEGIN
	SELECT DISTINCT count(*) INTO outProductsOnDepartmentCount FROM product AS p
	INNER JOIN product_category AS pc ON p.id = pc.product_id
	INNER JOIN category AS c ON pc.category_id = c.id
	WHERE (p.display = 2 OR p.display = 3)
	AND c.department_id = inDepartmentID;
	RETURN outProductsOnDepartmentCount;
END;
$$;


ALTER FUNCTION public.catalog_count_products_on_department(indepartmentid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_categories_list(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_categories_list(indepartmentid integer) RETURNS SETOF category_list
    LANGUAGE plpgsql
    AS $$
DECLARE
	outCategoryListRow	category_list;
BEGIN
	FOR outCategoryListRow IN SELECT id, name FROM category WHERE department_id = inDepartmentID ORDER BY id LOOP
		RETURN NEXT outCategoryListRow;
	END LOOP;
END;
$$;


ALTER FUNCTION public.catalog_get_categories_list(indepartmentid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_category_details(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_category_details(incategoryid integer) RETURNS category_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	outCategoryDetailsRow	category_details;
BEGIN
	SELECT name, description INTO outCategoryDetailsRow FROM category WHERE id = inCategoryID;
	RETURN outCategoryDetailsRow;
END;
$$;


ALTER FUNCTION public.catalog_get_category_details(incategoryid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_department_details(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_department_details(indepartmentid integer) RETURNS department_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	outDepartmentDetailsRow	department_details;
BEGIN
	SELECT name, description INTO outDepartmentDetailsRow FROM department WHERE id = inDepartmentID;
	RETURN outDepartmentDetailsRow;
END;
$$;


ALTER FUNCTION public.catalog_get_department_details(indepartmentid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_departments_list(); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_departments_list() RETURNS SETOF department_list
    LANGUAGE plpgsql
    AS $$
DECLARE
	outDepartmentListRow	department_list;
BEGIN
	FOR outDepartmentListRow IN SELECT id, name FROM department ORDER BY id LOOP
		RETURN NEXT outDepartmentListRow;
	END LOOP;
END;
$$;


ALTER FUNCTION public.catalog_get_departments_list() OWNER TO hatshopadmin;

--
-- Name: catalog_get_product_details(integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_product_details(inproductid integer) RETURNS product_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductDetailsRow	product_details;
BEGIN
	SELECT id, name, description, price, discounted_price, image INTO outProductDetailsRow FROM product WHERE id = inProductID;
	RETURN outProductDetailsRow;
END;
$$;


ALTER FUNCTION public.catalog_get_product_details(inproductid integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_products_in_category(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_products_in_category(incategoryid integer, inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) RETURNS SETOF product_list
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductListRow	product_list;
BEGIN
	FOR outProductListRow IN
		SELECT p.id, p.name, p.description, p.price, p.discounted_price, p.thumbnail
		FROM product AS p
		INNER JOIN product_category AS pc ON p.id = pc.product_id
		WHERE pc.category_id = inCategoryID ORDER BY p.id LIMIT inProductsPerPage OFFSET inStartItem
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$$;


ALTER FUNCTION public.catalog_get_products_in_category(incategoryid integer, inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_products_on_catalog(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_products_on_catalog(inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) RETURNS SETOF product_list
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductListRow	product_list;
BEGIN
	FOR outProductListRow IN
		SELECT id, name, description, price, discounted_price, thumbnail
		FROM product
		WHERE display = 1 OR display = 3 ORDER BY id LIMIT inProductsPerPage OFFSET inStartItem
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$$;


ALTER FUNCTION public.catalog_get_products_on_catalog(inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) OWNER TO hatshopadmin;

--
-- Name: catalog_get_products_on_department(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: hatshopadmin
--

CREATE FUNCTION catalog_get_products_on_department(indepartmentid integer, inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) RETURNS SETOF product_list
    LANGUAGE plpgsql
    AS $$
DECLARE
	outProductListRow	product_list;
BEGIN
	FOR outProductListRow IN
		SELECT DISTINCT p.id, p.name, p.description, p.price, p.discounted_price, p.thumbnail
		FROM product AS p
		INNER JOIN product_category AS pc ON p.id = pc.product_id
		INNER JOIN category AS c ON pc.category_id = c.id
		WHERE (p.display = 2 OR p.display = 3)
		AND c.department_id = inDepartmentID ORDER BY p.id LIMIT inProductsPerPage OFFSET inStartItem
	LOOP
		IF char_length(outProductListRow.description) > inShortProductDescriptionLength THEN
			outProductListRow.description := substring(outProductListRow.description, 1, inShortProductDescriptionLength) || '...';
		END IF;
		RETURN NEXT outProductListRow;
	END LOOP;
END;
$$;


ALTER FUNCTION public.catalog_get_products_on_department(indepartmentid integer, inshortproductdescriptionlength integer, inproductsperpage integer, instartitem integer) OWNER TO hatshopadmin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: category; Type: TABLE; Schema: public; Owner: hatshopadmin; Tablespace: 
--

CREATE TABLE category (
    id integer NOT NULL,
    department_id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.category OWNER TO hatshopadmin;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: hatshopadmin
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_id_seq OWNER TO hatshopadmin;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hatshopadmin
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: hatshopadmin; Tablespace: 
--

CREATE TABLE department (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.department OWNER TO hatshopadmin;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: hatshopadmin
--

CREATE SEQUENCE department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_id_seq OWNER TO hatshopadmin;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hatshopadmin
--

ALTER SEQUENCE department_id_seq OWNED BY department.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: hatshopadmin; Tablespace: 
--

CREATE TABLE product (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    discounted_price numeric(10,2) DEFAULT 0.00 NOT NULL,
    image character varying(150),
    thumbnail character varying(150),
    display integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.product OWNER TO hatshopadmin;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: hatshopadmin; Tablespace: 
--

CREATE TABLE product_category (
    product_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.product_category OWNER TO hatshopadmin;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: hatshopadmin
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO hatshopadmin;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hatshopadmin
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY department ALTER COLUMN id SET DEFAULT nextval('department_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: hatshopadmin
--

COPY category (id, department_id, name, description) FROM stdin;
1	1	Christmas Hats	Enjoy browsing our collection of Christmas hats!
2	1	Halloween Hats	Find the hat you'll wear this Halloween!
3	1	St. Patrick's Day Hats	Try one of these beautiful hats on St. Patrick's Day!
4	2	Berets	An amazing collection of berets from all around the world!
5	2	Driving Caps	Be an original driver! Buy a driver's hat today!
6	3	Theatrical Hats	Going to a costume party? Try one of these hats to complete your costume!
7	3	Military Hats	This collection contains the most realistic replicas om military hats!
\.


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hatshopadmin
--

SELECT pg_catalog.setval('category_id_seq', 7, true);


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: hatshopadmin
--

COPY department (id, name, description) FROM stdin;
1	Holiday	Prepare for the holidays with our special collection of seasonal hats!
2	Caps and Berets	The perfect hats to wear at work and costume parties!
3	Costume Hats	Find the matching hat for your new costume!
\.


--
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hatshopadmin
--

SELECT pg_catalog.setval('department_id_seq', 3, true);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: hatshopadmin
--

COPY product (id, name, description, price, discounted_price, image, thumbnail, display) FROM stdin;
1	Christmas Candy Hat	Be everyone's "sweetie" while wearing this fun and festive peppermint candy hat. The Christmas Candy hat, made by Elope, stands about 15 inches tall and has a sizing adjustment on the inside.	24.99	0.00	ChristmasCandyHat.jpg	ChristmasCandyHat.thumb.jpg	0
2	Hanukah Hat	The Hanukah hat is a fun and festive way for you to enjoy yourself during the holiday. Made by Elope and adorned with 9 candles, this menorah is sure to brighten the winter celebration.	24.99	21.99	HanukahHat.jpg	HanukahHat.thumb.jpg	2
3	Springy Santa Hat	Santa Hat - Boing-Boing-Boing. Santa will be springing into town with this outrageous cap! If your children are whiney and clingy ... and your head's going ping-pong-pingy ... and you feel like just rowing away in your rubber dinghy ... Take heart! You'll bounce bounce back ... if you just put on our Santa hat that's Springy!	19.99	0.00	SpringySantaHat.jpg	SpringySantaHat.thumb.jpg	0
4	Plush Santa Hat	Get into the spirit of the season with this plush, velvet-like, Santa hat. Comes in a beautiful crimson red color with a faux-fur trim.	12.99	0.00	PlushSantaHat.jpg	PlushSantaHat.thumb.jpg	0
5	Red Santa Cowboy Hat	This velvet Cowboy Santa Hat is one size fits all and has white faux-fur trim all around. Here comes Santa Claus ... Here comes Santa Claus ... right down Cowboy Lane!	24.99	0.00	RedSantaCowboyHat.jpg	RedSantaCowboyHat.thumb.jpg	0
6	Santa Jester Hat	This three-prong velvet jester is one size fits all and has an adjustable touch fastener back for perfect fitting.	24.99	0.00	SantaJesterHat.jpg	SantaJesterHat.thumb.jpg	0
7	Santa's Elf Hat	Be Santa's best looking helper with this velvet hat, complete with attached ears. So, if you don't wanna be yourself ... don't worry ... this Christmas, just be Santa's elf! Happy Holidays!	24.99	16.95	Santa'sElfHat.jpg	Santa'sElfHat.thumb.jpg	1
8	Chauffeur Hat	Uniform Chauffeur Cap. This cap is the real thing. Well-made and professional looking, our Chauffeur hat gets so many compliments from our customers who buy (and wear) them. It's absolutely amazing how many of these we sell. One thing's for sure, this authentic professional cap will let everyone know exactly who's in the driver's seat. So ... whether you're driving Miss Daisy ... or driving yourself crazy ... I'll bet your wife will coo and purr ... when she sees you in our authentic chauffer!	69.99	0.00	ChauffeurHat.jpg	ChauffeurHat.thumb.jpg	0
9	The Pope Hat	We're not sure what the Vatican's official position is on this hat, but we do know your friends will love you in this soft velour hat with gold lame accents. If you're somewhat lacking in religion ... if you're looking for some hope ... you might acquire just a smidgeon ... by faithfully wearing our Pope!	29.99	0.00	ThePopeHat.jpg	ThePopeHat.thumb.jpg	0
10	Vinyl Policeman Cop Hat	A hat that channels the 70s. This oversized vinyl cap with silver badge will make you a charter member of the disco era ... or is that disco error?	29.99	0.00	VinylPolicemanCopHat.jpg	VinylPolicemanCopHat.thumb.jpg	0
11	Burgundy Kings Crown	Our burgundy Kings Crown is one size fits all. This crown is adorned with gold ribbon, gems, and a faux-fur headband. Be King for a Day ... Finally get your say ... Put your foot down ... and do it with humor, wearing our Elegant Burgundy King's Crown!	34.99	25.95	BurgandyKingsCrown.jpg	BurgandyKingsCrown.thumb.jpg	2
12	454 Black Pirate Hat	Our wool felt Pirate Hat comes with the front and back brims turned upward. This sized hat has the pirate emblem on the front. So, ho, ho, ho and a bottle of rum ... if you're about as crazy as they come ... wear our Pirate hat this coming Halloween ... and with an eyepatch to boot, you'll be lusty, lean and mean!	39.99	0.00	454BlackPirateHat.jpg	454BlackPirateHat.thumb.jpg	0
13	Black Puritan Hat	Haentze Hatcrafters has been making quality theatrical and military headgear for decades. Each hat is made meticulously by hand with quality materials. Many of these hats have been used in movies and historical reproductions and re-enactments.	89.99	75.99	BlackPuritanHat.jpg	BlackPuritanHat.thumb.jpg	2
14	Professor McGonagall Witch Hat	Professor McGonagall, Deputy Headmistress of Hogwarts and Head of Gryffindor House, commands respect in this dramatic witch hat - and so will you! The inside of this hat has a touch fastener size-adjustment tab. The hat is a must for all Harry Potter fans!	24.99	0.00	ProfessorMcGonagallWitchHat.jpg	ProfessorMcGonagallWitchHat.thumb.jpg	0
15	Black Wizard Hat	This cool Merlin-style wizard hat by Elope has a dragon that lays around the whole hat. The wizard hat is one size fits all and has a touch fastener on the inside to adjust accordingly.	34.99	0.00	BlackWizardHat.jpg	BlackWizardHat.thumb.jpg	0
16	Leprechaun Hat	Show them the green! This hand-blocked, wool felt hat will make you the hit of this year's St. Paddy's Day Celebration! Oh yes, the green you will don ... and what better way, hon ... than if this St. Patrick's Day ... you're wearing our cool Leprechaun!	88.99	0.00	LeprechaunHat.jpg	LeprechaunHat.thumb.jpg	0
17	9 Green MadHatter Top Hat	Each of our MadHatter hats is made meticulously by hand with quality materials. Many of these hats have been used in movies and historical reproductions and re-enactments.	149.99	124.95	9GreenMadHatterTopHat.jpg	9GreenMadHatterTopHat.thumb.jpg	2
18	Winter Walking Hat	Our declarative English walking hat by Christy's of London comes in 100% Lana Wool and reveals a finished satin lining. Christy's has been making hats since 1773 and knows how to make the best! Want proof? Try this one ... Irish eyes will be smiling.	49.99	0.00	WinterWalkingHat.jpg	WinterWalkingHat.thumb.jpg	0
19	Green MadHatter Hat	St. Patrick's Day Hat - Luck o' the Irish! This oversized green velveteen MadHatter is great for St.Patrick's day or a MadHatter's tea party.One size fits most adults.	39.99	28.99	GreenMadHatterHat.jpg	GreenMadHatterHat.thumb.jpg	2
20	Hole in One Golf Costume Hat	Golf Hat - OK, Ace. This spoof golfer's hat sports an astro-turf "green," has an attached golf ball and flag, and includes a soft elastic band  for comfort. This hat also makes a great gift that is definitely "up to par" for any goofball's - uh - golfballer's taste. Perfect for Dad! And don't you fore-get-it!	29.99	0.00	HoleinOneGolfCostumeHat.jpg	HoleinOneGolfCostumeHat.thumb.jpg	0
21	Luck of the Irish Bowler	This one size fits all Irish Derby comes with a shamrock attached to the side. This hat is made of a soft velvet and is comfortably sized.	29.99	0.00	LuckoftheIrishBowler.jpg	LuckoftheIrishBowler.thumb.jpg	0
22	St. Patrick's Irish Green Derby	This quality bowler will last you more than one St. Patrick's Day! A proper derby for the day, it is made of wool felt and has a green grosgrain band. This hat is not lined.	39.99	0.00	St.Patrick'sIrishGreenDerby.jpg	St.Patrick'sIrishGreenDerby.thumb.jpg	0
45	Tarbucket Helmet Military Hat	This is a reproduction Tarbucket type hat. This style was a popular military style in the early to mid 1800s. The style is similar to a shako hat, with the main difference being that the crown flairs outward.	299.99	0.00	TarbucketHelmetMilitaryHat.jpg	TarbucketHelmetMilitaryHat.thumb.jpg	0
23	Black Basque Beret	This is our tried and true men's classic beret hat(tam). Our Basque beret is superbly crafted, 100% wool, and has a comfortable leather sweatband. Lined and water resistant, the beret is great for everyday wear and rolls up nicely to fit in your pocket. So ... if you're antsy ... in your pantsy ... cause you wanna catch the fancy ... of the lady near your way ... then please don't delay ... just get this beret ... today ... and soon you'll be making hay!	49.99	0.00	BlackBasqueBeret.jpg	BlackBasqueBeret.thumb.jpg	0
24	Cotton Beret	The Parkhurst SunGuard line of headwear offers the comfort and breathability of cotton and provides up to 50 times your natural protection from the sun's rays. Fashionable, durable, and washable, Sunguard is the only choice.	12.95	7.95	CottonBeret.jpg	CottonBeret.thumb.jpg	2
25	Wool Beret	This classic tam from Kangol is one size fits all. It's composed of 100% wool and measures 11" in diameter.	24.99	0.00	WoolBeret.jpg	WoolBeret.thumb.jpg	0
26	Military Beret	As one of our best selling berets, this Black Military Beret is especially popular in these war-torn days. Made of wool felt, it's a facsimile of what Monty wore in the deserts of Africa in World War II. We don't guarantee any sweeping victories with this beret, but you might score a personal triumph or two!	19.99	12.95	MilitaryBeret.jpg	MilitaryBeret.thumb.jpg	3
27	Bond-Leather Driver	Leather was never so stylish. The Bond-Driver has an elastic sweatband for a sure fit. Seamed and unlined, this driver is perfect for cruising around town or saving the world.	49.99	0.00	Bond-LeatherDriver.jpg	Bond-LeatherDriver.thumb.jpg	0
28	Moleskin Driver	This quality ivy cap made by Christy's comes with a finished lining. The material of this ivy is called moleskin and is very soft. If your life's kinda in a hole ... and you wish you had a little more soul ... no need to beat your head against a pole, Ken ... just purchase our Christy's Ivy Cap in Moleskin!	29.99	25.00	MoleskinDriver.jpg	MoleskinDriver.thumb.jpg	2
29	Herringbone English Driver	Herringbone is everywhere this year from head to toe. The English Driver ivy cap is made of wool with a cotton sweatband on the inside.	29.99	0.00	HerringboneEnglishDriver.jpg	HerringboneEnglishDriver.thumb.jpg	0
30	Confederate Civil War Kepi	Rebel Hat - Southern Hat - This kepi comes with the crossed musket emblem on the front.	14.99	0.00	ConfederateCivilWarKepi.jpg	ConfederateCivilWarKepi.thumb.jpg	0
31	Hillbilly Hat	Blocked wool, with a rope band. Please allow 1-2 weeks for delivery. Some sizes available for immediate shipment. Corn Cob pipe not included! So, go ahead Joe, or Carl, or Billy ... act nutso and be silly ... because we've got you covered willy-nilly ... in our sleepy-hollow Hillbilly!	139.99	124.95	HillbillyHat.jpg	HillbillyHat.thumb.jpg	2
32	Mother Goose Hat	Sorceress Witch Hat - Boil, Boil, Toil and Trouble! Mix up a pot of your best witch's brew in this blocked wool felt hat. Available in almost all color combinations - email us for more information.	149.99	0.00	MotherGooseHat.jpg	MotherGooseHat.thumb.jpg	0
33	Uncle Sam Top Hat	Patriotic Hats, Uncle Sam Top Hat - This silk topper is a show stopper. Hand-fashioned quality will transform you into a Yankee Doodle Dandy ... Or you can call us a macaroni (something like that).	199.00	175.00	UncleSamTopHat.jpg	UncleSamTopHat.thumb.jpg	2
34	Velvet Sombrero Hat	Ay Caramba! This is the real thing! Get into this velvet sombrero, which is richly embossed with sequins. Comes in red and black.	79.99	0.00	VelvetSombreroHat.jpg	VelvetSombreroHat.thumb.jpg	0
35	Conductor Hat	Train Railroad Conductor Hat - You been working on the railroad all the live-long day? Well now, you can wear our Conductor's hat, and your troubles will all go away! We sell a ton of these! Set the scene correctly with an authentic train or streetcar conductor's uniform hat. Also makes a great gift for transportation enthusiasts. Don't be a drain ... get on the train!	69.99	0.00	ConductorHat.jpg	ConductorHat.thumb.jpg	0
36	Traditional Colonial Tricorn Hat	Truly revolutionary headgear. This hat is blocked from black wool, and edges are finished with white ribbon. The edges are tacked up for durability. So if you're glad to be born ... if you wanna toot your own horn ... just hop out of bed some lovely morn ... and put on our Traditional Colonial Tricorn!	39.99	0.00	TraditionalColonialTricornHat.jpg	TraditionalColonialTricornHat.thumb.jpg	0
37	Metal Viking Helmet	You can almost hear the creaking oars of your warship as you glide across open seas! Conquer new worlds with this authentic Nordic reproduction. Crafted from metal and horn, the Viking helmet is a necessity for any adventure. Would you adorn it while biking? ... How about on the wooded trials while hiking? ... Betcha it'll always be to your liking ... wherever you wear our Metal Viking!	119.99	105.95	MetalVikingHelmet.jpg	MetalVikingHelmet.thumb.jpg	2
38	Confederate Slouch Hat	Our replica Confederate Slouch Hat from the Civil War comes with Cavalry yellow straps and crossed-sword emblem.	129.99	101.99	ConfederateSlouchHat.jpg	ConfederateSlouchHat.thumb.jpg	1
39	Campaign Hat	Dress the part of Dudley-Do-Right, State Trooper Bob, Smokey the Bear, or WWI Doughboy. Wear it in the rain ... wear it carrying a cane ... wear it if you're crazy or sane ... just wear our versatile Campaign!	44.99	0.00	CampaignHat.jpg	CampaignHat.thumb.jpg	0
40	Civil War Union Slouch Hat	This Yankee slouch hat from the Civil War era comes in a black wool felt material and has the U.S. metal emblem on the front. This Union hat comes with the officer's cords.	129.99	0.00	CivilWarUnionSlouchHat.jpg	CivilWarUnionSlouchHat.thumb.jpg	0
41	Civil War Leather Kepi Cap	Calling all Civil War buffs! Yanks grab the blue, and Rebs get the gray. You'll all be victorious in this suede cap worn in the "War Between the States." So, if on the Civil War you're hep-eee ... then by all means, you gotta have our kepi!	39.99	0.00	CivilWarLeatherKepiCap.jpg	CivilWarLeatherKepiCap.thumb.jpg	0
42	Cavalier Hat - Three Musketeers	Reproduction of the original Cavalier hat complete with a feather! Handblocked from 100% wool felt. This is as close to the real thing as you get. It is better than downing a beer ... it is better than having your honey say, "Come on over here, Dear" ... All you gotta do is let go of your fear ... and order this stunning, galant Cavalier!	185.00	0.00	CavalierHat-ThreeMusketeers.jpg	CavalierHat-ThreeMusketeers.thumb.jpg	1
43	Hussar Military Hat	A "Hussar" was an enlisted Cavalry soldier. All hussar soldiers were taught to read and write, and they commonly kept journals of some sort - probably helping them to pass the time while they were away from home in the service of their country. They were required to keep records of their duties and work, as well.	199.99	0.00	HussarMilitaryHat.jpg	HussarMilitaryHat.thumb.jpg	0
44	Union Civil War Kepi Cap	Union Soldier's Cap - Yankee Cap - This kepi comes with the crossed musket emblem on the front.	14.99	0.00	UnionCivilWarKepiCap.jpg	UnionCivilWarKepiCap.thumb.jpg	2
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: hatshopadmin
--

COPY product_category (product_id, category_id) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	2
9	2
10	2
11	2
12	2
13	2
14	2
15	2
16	3
17	3
18	3
19	3
20	3
21	3
22	3
23	4
24	4
25	4
26	4
8	5
27	5
28	5
29	5
30	6
31	6
32	6
33	6
34	6
35	6
26	7
36	7
37	7
38	7
39	7
40	7
41	7
42	7
43	7
44	7
45	7
\.


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hatshopadmin
--

SELECT pg_catalog.setval('product_id_seq', 46, false);


--
-- Name: category_pk; Type: CONSTRAINT; Schema: public; Owner: hatshopadmin; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pk PRIMARY KEY (id);


--
-- Name: department_pk; Type: CONSTRAINT; Schema: public; Owner: hatshopadmin; Tablespace: 
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pk PRIMARY KEY (id);


--
-- Name: product_category_pk; Type: CONSTRAINT; Schema: public; Owner: hatshopadmin; Tablespace: 
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_pk PRIMARY KEY (product_id, category_id);


--
-- Name: product_pk; Type: CONSTRAINT; Schema: public; Owner: hatshopadmin; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pk PRIMARY KEY (id);


--
-- Name: category_f0; Type: FK CONSTRAINT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_f0 FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_category_f0; Type: FK CONSTRAINT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_f0 FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_category_f1; Type: FK CONSTRAINT; Schema: public; Owner: hatshopadmin
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_f1 FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

