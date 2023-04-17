--creating tables:

CREATE TABLE "Customer" (
  "customer_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50),
  "phone_number" VARCHAR(20),
  "address" VARCHAR(300),
  "email" VARCHAR(50),
  "customer_since" DATE
);


CREATE TABLE "Salesperson" (
  "salesperson_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50),
  "address" VARCHAR(300),
  "phone_number" VARCHAR(20),
  "email" VARCHAR(50),
  "start_date" DATE
);


CREATE TABLE "Mechanic" (
  "mechanic_id" INTEGER PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50),
  "address" VARCHAR(300),
  "phone_number" VARCHAR(20),
  "start_date" DATE
);


CREATE TABLE "Possible_Services" (
  "service_id" INTEGER PRIMARY KEY,
  "name" VARCHAR(50),
  "price" NUMERIC(8,2)
);


CREATE TABLE "Possible_Parts" (
  "part_id" INTEGER PRIMARY KEY,
  "name" VARCHAR(50),
  "price" NUMERIC(8,2)
);


CREATE TABLE "Vehicle" (
  "vehicle_id" SERIAL PRIMARY KEY,
  "make" VARCHAR(20),
  "model" VARCHAR(20),
  "used" BOOLEAN,
  "customer_id" INTEGER,
    FOREIGN KEY ("customer_id") REFERENCES "Customer"("customer_id")
);


CREATE TABLE "Mechanic_Vehicle" (
  "mech_veh_id" SERIAL PRIMARY KEY,
  "mechanic_id" INTEGER,
  "vehicle_id" INTEGER,
    FOREIGN KEY ("mechanic_id") REFERENCES "Mechanic"("mechanic_id"),
    FOREIGN KEY ("vehicle_id") REFERENCES "Vehicle"("vehicle_id")
);


CREATE TABLE "Sale" (
  "sale_id" SERIAL PRIMARY KEY,
  "sale_date" DATE,
  "sale_price" NUMERIC(8,2),
  "financed" BOOLEAN,
  "customer_id" INTEGER,
  "vehicle_id" INTEGER,
  "salesperson_id" INTEGER,
    FOREIGN KEY ("salesperson_id") REFERENCES "Salesperson"("salesperson_id"),
    FOREIGN KEY ("customer_id") REFERENCES "Customer"("customer_id"),
	FOREIGN KEY ("vehicle_id") REFERENCES "Vehicle" ("vehicle_id")
);


CREATE TABLE "Service_Ticket" (
  "ticket_id" SERIAL PRIMARY KEY,
  "service_date" DATE,
  "vehicle_id" INTEGER,
  "part_id" INTEGER,
  "quantity" INTEGER,
  "p_price" NUMERIC(8,2),
  "service_id" INTEGER,
  "s_price" NUMERIC(8,2),
  "total" NUMERIC(8,2),
  "mechanic_id" INTEGER,
	FOREIGN KEY ("mechanic_id") REFERENCES "Mechanic"("mechanic_id"),
	FOREIGN KEY ("vehicle_id") REFERENCES "Vehicle" ("vehicle_id"),
	FOREIGN KEY ("part_id") REFERENCES "Possible_Parts"("part_id"),
	FOREIGN KEY ("service_id") REFERENCES "Possible_Services"("service_id")
	);



-------------------------------------
--inserting data:

CREATE OR REPLACE FUNCTION add_customer(
	customer_id INTEGER, 
	first_name VARCHAR, 
	last_name VARCHAR, 
	phone_number VARCHAR,
	address VARCHAR,
	email VARCHAR,
	customer_since DATE
	)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Customer"
	VALUES(customer_id, first_name, last_name, phone_number, address, email, customer_since);
END;
$MAIN$
LANGUAGE plpgsql;


SELECT add_customer(1, 'Sarah', 'Connor', '(800)867-5309', '24 Clover Ave, New York, NY 12345', 'sarah.connor.gmail.com','02-25-2018');
SELECT add_customer(2, 'Max', 'Potter', '(147)555-7894', '123 Main St, Cleveland, OH 45678', 'm.potter123@yahoo.com', '06-24-2019');
SELECT add_customer(3, 'Cindy', 'Crawchevy', '1800-224-3636','47 Beale St, Memphis, TN 86963', 'cindy_c@my_work.com', '12-06-2020');
SELECT add_customer(4, 'Robert', 'Skinner', '(456)789-7676', '1467 Evergreen Ln, Tulsa, OK 56477', 'rob.sk@gmail.com', '01-29-2021');
					


CREATE OR REPLACE FUNCTION add_mechanic(
	mechanic_id INTEGER, 
	first_name VARCHAR(50), 
	last_name VARCHAR(50),
	address VARCHAR(200),
	phone_number VARCHAR(20),
	start_date DATE)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Mechanic"
	VALUES(mechanic_id, first_name, last_name, address, phone_number, start_date);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT add_mechanic(1, 'Pete', 'Harley', '255 Broad St, New York, NY 05348', '188-456-6996', '05-14-2018');
SELECT add_mechanic(2, 'Gary', 'Butler', '96 Long St, New York, NY 05649', '188-478-2363', '09-22-2016');
SELECT add_mechanic(3, 'John', 'Turkey', '1066 3rd Ave, New York, NY 05963', '188-654-1234', '04-16-2010');
SELECT add_mechanic(4, 'Tom', 'Jeffreys', '1456 E 22nd St, New York, NY 05462', '188-852-7896', '01-12-2019');



CREATE OR REPLACE FUNCTION add_parts(
	part_id INTEGER, 
	part_name VARCHAR(50),
	price NUMERIC (7,2))
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Possible_Parts"
	VALUES(part_id, part_name, price);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT add_parts(1, 'TPMS', 40.00);
SELECT add_parts(2, 'Break Pads', 30.00);
SELECT add_parts(3, 'Tire', 125.00);
SELECT add_parts(4, 'Rotor', 30.00);
SELECT add_parts(5, 'Windshield Wipers', 20.00);



CREATE OR REPLACE FUNCTION add_services(
	service_id INTEGER, 
	service_name VARCHAR(100),
	price NUMERIC (7,2))
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Possible_Services"
	VALUES(service_id, service_name, price);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT add_services(1, 'Oil Change', 100.00);
SELECT add_services(2, 'Service Breaks', 200.00);
SELECT add_services(3, 'Mount & Balance Tire', 28.00);
SELECT add_services(4, 'Wiper Replacement', 10.00);
SELECT add_services(5, 'Inspection', 150.00);
SELECT add_services(6, 'Alignment - 2 wheels', 80.00);
SELECT add_services(7, 'Alignment - 4 wheels', 100.00);
SELECT add_services(8, 'Diagnostics', 120.00);
SELECT add_services(9, 'Replace TPMS', 340.00);




CREATE OR REPLACE FUNCTION add_vehicles(
	vehicle_id INTEGER, 
	make VARCHAR(50),
	model VARCHAR(50),
	used BOOLEAN,
	cust_id INTEGER,
	)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Vehicle"
	VALUES(vehicle_id, make, model, used, cust_id);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT add_vehicles(1, 'JEEP', 'Cherokee', true, 1);
SELECT add_vehicles(2, 'Nissan', 'Pathfinder', false, 2);
SELECT add_vehicles(3, 'Honda', 'Accord', true, 3);
SELECT add_vehicles(4, 'Nissan', 'Pathfinder', false, 4);


ALTER TABLE "Vehicle"
ADD year INTEGER;

UPDATE "Vehicle"
SET year = 2012
WHERE vehicle_id =1;

UPDATE "Vehicle"
SET year = 2023
WHERE vehicle_id =2;

UPDATE "Vehicle"
SET year = 2019
WHERE vehicle_id =3;

UPDATE "Vehicle"
SET year = 2023
WHERE vehicle_id =4;



CREATE OR REPLACE FUNCTION add_vehicles(
	vehicle_id INTEGER, 
	make VARCHAR(50),
	model VARCHAR(50),
	used BOOLEAN,
	cust_id INTEGER,
	year INTEGER)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Vehicle"
	VALUES(vehicle_id, make, model, used, cust_id, year);
END;
$MAIN$
LANGUAGE plpgsql; 

--creating additional vehicles for customers 2, 3 & 4,
-- if boolean 'used' = [NULL], vehicle was not bought at this dealership

SELECT add_vehicles(5, 'Lexus', 'RX', false, 2, 2023);
SELECT add_vehicles(6, 'Audi', 'A4', NULL, 4, 2021);
SELECT add_vehicles(7, 'Chevy', 'Equinox', NULL, 3, 2020);


--just realized 2 of my 7 vehicles are the same - no fun!
UPDATE "Vehicle"
SET make = 'Ford'
WHERE vehicle_id = 4;

UPDATE "Vehicle"
SET model = 'Explorer'
WHERE vehicle_id = 4;



CREATE OR REPLACE FUNCTION add_salesperson(
	salesperson_id INTEGER, 
	first_name VARCHAR(50), 
	last_name VARCHAR(50),
	address VARCHAR(200),
	phone_number VARCHAR(20),
	email VARCHAR(50),
	start_date DATE)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Salesperson"
	VALUES(salesperson_id, first_name, last_name, address, phone_number, email, start_date);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT add_salesperson(1, 'Jeffrey', 'Wagner', '779 Bass Ave, New York, NY 05348', '188-699-4548','jeff_wagner@dealership.com', '08-01-2015');
SELECT add_salesperson(2, 'Shelly', 'Stone', '17 Eisenhower Blvd, New York, NY 05649', '188-886-2625', 'shelly_stone@dealership.com', '02-03-2021');
SELECT add_salesperson(3, 'Toby', 'Miller', '1423 7th Ave, New York, NY 05963', '188-864-4741','toby_miller@dealership.com', '05-21-2019');
SELECT add_salesperson(4, 'Nancy', 'Wheeler', '156 Long Ln, New York, NY 05462', '188-966-8833', 'nancy_wheeler@dealership.com', '09-15-2018');



CREATE OR REPLACE FUNCTION insert_mech_veh(
	mech_veh_id INTEGER, 
	mechanic_id INTEGER,
	vehicle_id INTEGER)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Mechanic_Vehicle"
	VALUES(mech_veh_id, mechanic_id, vehicle_id);
END;
$MAIN$
LANGUAGE plpgsql; 


SELECT insert_mech_veh(1,1,1);
SELECT insert_mech_veh(2,2,1);
SELECT insert_mech_veh(3,3,6);
SELECT insert_mech_veh(4,4,3);



INSERT INTO "Mechanic_Vehicle"
VALUES(5, 2, 2);

INSERT INTO "Mechanic_Vehicle"
VALUES(6, 4, 5);

UPDATE "Mechanic_Vehicle"
SET vehicle_id = 7
WHERE mech_veh_id = 6;



CREATE OR REPLACE FUNCTION add_sales(
	sale_id INTEGER, 
	sale_date DATE, 
	sale_price NUMERIC(8,2),
	financed BOOLEAN,
	cust_id INTEGER,
	veh_id INTEGER,
	sp_id INTEGER)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Sale"
	VALUES(sale_id, sale_date, sale_price, financed, cust_id, veh_id, sp_id);
END;
$MAIN$
LANGUAGE plpgsql; 



SELECT add_sales(1,'08-21-2015', '12200', 'no', 1, 1, 1);
SELECT add_sales(2,'10-01-2020', '18600', 'no', 3, 3, 4);
SELECT add_sales(3,'02-05-2023', '35200', 'yes', 2, 2, 2);
SELECT add_sales(4,'03-19-2023', '38400', 'yes', 4, 4, 3);
SELECT add_sales(5,'04-10-2023', '48600', 'yes', 2, 5, 1);



CREATE OR REPLACE FUNCTION add_service_tix(
	ticket_id INTEGER, 
	service_date DATE,
	veh_id INTEGER,
	part_id INTEGER,	
	quantity INTEGER,
	p_price NUMERIC(8,2),
	service_id INTEGER,
	s_price NUMERIC(8,2),
	total NUMERIC(8,2),
	mech_id INTEGER)
	
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Service_Ticket"
	VALUES(ticket_id, service_date, veh_id, part_id, quantity, p_price,
		   service_id, s_price, total, mech_id);
END;
$MAIN$
LANGUAGE plpgsql; 



SELECT add_service_tix(1, '05-03-2016', 1, 3, 4, '500.00', 3, '112.00', NULL, 1);
SELECT add_service_tix(2, '10-24-2018', 1, 5, 1, '20.00', 4, '10.00', NULL, 2);
SELECT add_service_tix(3, '04-15-2021', 3, NULL, NULL, NULL, 1, '100.00', NULL, 4);
SELECT add_service_tix(4, '06-16-2022', 6, NULL, NULL, NULL, 5, '150.00', NULL, 3);
SELECT add_service_tix(5, '09-10-2022', 7, NULL, NULL, NULL, 6, '80.00', NULL, 4);


UPDATE "Service_Ticket"
SET p_price = 0.00
WHERE ticket_id = 3;

UPDATE "Service_Ticket"
SET p_price = 0.00
WHERE ticket_id = 4;

UPDATE "Service_Ticket"
SET p_price = 0.00
WHERE ticket_id = 5;


--add up the total for the service ticket:
CREATE OR REPLACE PROCEDURE add_total()
LANGUAGE plpgsql
AS $$ 
BEGIN 
	UPDATE "Service_Ticket"
	SET total = p_price + s_price;
	COMMIT;
END;
$$;

CALL add_total()



-----------------------------------
--is_serviced:

ALTER TABLE "Vehicle"
ADD COLUMN is_serviced BOOLEAN;

UPDATE "Vehicle"
SET is_serviced = false



CREATE OR REPLACE PROCEDURE change_is_serviced()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE "Vehicle"
	SET is_serviced = true
	WHERE vehicle_id IN (
		SELECT vehicle_id
		FROM "Service_Ticket");
	COMMIT;
END;
$$;


CALL change_is_serviced();


