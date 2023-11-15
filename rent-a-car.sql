-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.addresses
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    customer_id integer NOT NULL,
    postal_code character varying COLLATE pg_catalog."default" NOT NULL,
    address_text character varying COLLATE pg_catalog."default" NOT NULL,
    city_id integer NOT NULL,
    county_id integer NOT NULL,
    CONSTRAINT addresses_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.bills
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    customer_id integer NOT NULL,
    order_id integer NOT NULL,
    date date NOT NULL,
    time_rent character varying COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    address_id integer NOT NULL,
    CONSTRAINT bills_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.brands
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT brands_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.cars
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    model_year integer NOT NULL DEFAULT 2023,
    model_name character varying COLLATE pg_catalog."default" NOT NULL,
    brand_id integer,
    color character varying COLLATE pg_catalog."default",
    price double precision,
    CONSTRAINT cars_key PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.cities
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    county_id integer NOT NULL,
    CONSTRAINT cities_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.counties
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT counties_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.customers
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    surname character varying COLLATE pg_catalog."default" NOT NULL,
    identity_number character varying COLLATE pg_catalog."default" NOT NULL,
    phone character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT customers_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.orders
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    date date NOT NULL,
    car_id integer NOT NULL,
    customer_id integer NOT NULL,
    start_rent date NOT NULL,
    end_rent date NOT NULL,
    total_price double precision NOT NULL,
    payment_type character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT orders_pkey PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.addresses
    ADD CONSTRAINT "FK_CITY_ADDRESS" FOREIGN KEY (city_id)
    REFERENCES public.cities (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.addresses
    ADD CONSTRAINT "FK_COUNTY_ADDRESS" FOREIGN KEY (county_id)
    REFERENCES public.counties (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.addresses
    ADD CONSTRAINT "FK_CUSTOMER_ADDRESS" FOREIGN KEY (customer_id)
    REFERENCES public.customers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.bills
    ADD CONSTRAINT "FK_ADDRESS_BILL" FOREIGN KEY (address_id)
    REFERENCES public.addresses (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.bills
    ADD CONSTRAINT "FK_CUSTOMER_BILL" FOREIGN KEY (customer_id)
    REFERENCES public.customers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.bills
    ADD CONSTRAINT "FK_ORDER_BILL" FOREIGN KEY (order_id)
    REFERENCES public.orders (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.cars
    ADD CONSTRAINT "FK_BRAND_CAR" FOREIGN KEY (brand_id)
    REFERENCES public.brands (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.cities
    ADD CONSTRAINT "FK_COUNTY_CITY" FOREIGN KEY (county_id)
    REFERENCES public.counties (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.orders
    ADD CONSTRAINT "FK_CAR_ORDER" FOREIGN KEY (car_id)
    REFERENCES public.cars (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.orders
    ADD CONSTRAINT "FK_CUSTOMER_ORDER" FOREIGN KEY (customer_id)
    REFERENCES public.customers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;