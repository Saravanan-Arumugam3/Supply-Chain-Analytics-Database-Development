CREATE TABLE customer
(customer_id CHAR(3) NOT NULL PRIMARY KEY,
customer_name VARCHAR(80) NOT NULL UNIQUE,
address varchar(120) UNIQUE,
poc VARCHAR (20));

CREATE TABLE CONTRACT
( contract_id CHAR(5) NOT NULL PRIMARY KEY,
contract_description VARCHAR(80) NULL,
line_of_business CHAR(4) NOT NULL,
CONSTRAINT C1 CHECK (line_of_business IN ("TRAN", "WARE", "SOUR")),
business_head VARCHAR(30) NOT NULL,
customer_id CHAR(3),
start_date DATE,
end_date DATE,
FOREIGN KEY (customer_id) REFERENCES customer (customer_id));

CREATE TABLE supplier
(supplier_id CHAR(5) NOT NULL PRIMARY KEY,
name VARCHAR(80) UNIQUE,
address VARCHAR(120) UNIQUE);

CREATE TABLE part
(part_nr CHAR(8) NOT NULL PRIMARY KEY,
description VARCHAR(30) NOT NULL);

CREATE TABLE collection_schedule
(schedule_id SMALLINT NOT NULL PRIMARY KEY,
delivery_date DATE NOT NULL,
customer_id CHAR(3) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer (customer_id));

CREATE TABLE supply_parts
(supplier_id CHAR(5),
part_nr CHAR(8),
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id),
FOREIGN KEY (part_nr) REFERENCES part (part_nr),
PRIMARY KEY (supplier_id, part_nr));

CREATE TABLE collect
(schedule_id SMALLINT NOT NULL,
supplier_id CHAR(5) NOT NULL,
part_nr CHAR(8) NOT NULL,
sch_quantity INT NOT NULL,
FOREIGN KEY (schedule_id) REFERENCES collection_schedule (schedule_id),
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id),
FOREIGN KEY (part_nr) REFERENCES part (part_nr),
PRIMARY KEY (schedule_id, supplier_id, part_nr));

CREATE TABLE route
(customer_id CHAR(3) NOT NULL,
supplier_id CHAR(5) NOT NULL,
route_id CHAR(9) NOT NULL UNIQUE,
FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id),
PRIMARY KEY (customer_id, supplier_id));

CREATE TABLE invoice
(invoice_nr CHAR(10) NOT NULL PRIMARY KEY,
inv_date DATE,
supplier_id CHAR(5) NOT NULL,
customer_id CHAR(3) NOT NULL,
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id),
FOREIGN KEY (customer_id) REFERENCES customer (customer_id));

CREATE TABLE SUPPLIED
(part_nr CHAR(8) NOT NULL,
invoice_nr CHAR (10) NOT NULL,
price INT,
quantity INT,
FOREIGN KEY (part_nr) REFERENCES part (part_nr),
FOREIGN KEY (invoice_nr) REFERENCES invoice (invoice_nr),
PRIMARY KEY (part_nr, invoice_nr));

CREATE TABLE cargo_bill
(cargo_bill_nr CHAR(13) NOT NULL,
date DATE,
invoice_nr CHAR(10) NOT NULL,
FOREIGN KEY (invoice_nr) REFERENCES invoice (invoice_nr),
PRIMARY KEY (cargo_bill_nr, invoice_nr));

CREATE TABLE trip
(trip_id CHAR(16) NOT NULL PRIMARY KEY,
delivery_date DATE,
date DATE,
cargo_bill_nr CHAR (13) NOT NULL,
FOREIGN KEY (cargo_bill_nr) REFERENCES cargo_bill(cargo_bill_nr));

CREATE TABLE vendor
(vendor_id CHAR(3) NOT NULL PRIMARY KEY,
name VARCHAR(30) UNIQUE,
address VARCHAR(120),
account_nr CHAR(10) UNIQUE);

CREATE TABLE vehicle
(vehicle_id CHAR(2) NOT NULL PRIMARY KEY,
registration_nr CHAR(10) NOT NULL UNIQUE,
capacity INT,
year INT,
age INT,
vendor_id CHAR(3),
FOREIGN KEY (vendor_id) REFERENCES vendor (vendor_id));

CREATE TABLE provide
(trip_id CHAR (16) NOT NULL,
vehicle_id CHAR(2) NOT NULL,
PRIMARY KEY (trip_id, vehicle_id),
FOREIGN KEY (trip_id) REFERENCES trip (trip_id),
FOREIGN KEY (vehicle_id) REFERENCES vehicle (vehicle_id));

CREATE TABLE proof_of_delivery
(pod_nr CHAR(6) NOT NULL PRIMARY KEY,
date DATE,
trip_id CHAR(16) NOT NULL,
FOREIGN KEY (trip_id) REFERENCES trip (trip_id));


