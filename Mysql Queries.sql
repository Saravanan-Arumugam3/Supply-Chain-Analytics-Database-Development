## Query 1 - Select contracts of customers that belong to Transportation and Warehousing lines of business
SELECT * 
FROM contract
WHERE line_of_business IN ("TRAN", "WARE");

## Query 2 - Suppliers that are scheduled to supply more than 10000 units
SELECT supplier_id, SUM(sch_quantity) AS "Total parts scheduled" 
FROM collect
GROUP BY supplier_id
HAVING SUM(sch_quantity) > 10000
ORDER BY SUM(sch_quantity) Desc;

## Query 3 - Select all the vehicles which are less than 10 years old with their vendor names and account numbers
SELECT a.vehicle_id, a.registration_nr, a.age, b.name, b.account_nr 
FROM vehicle AS a
INNER JOIN vendor AS b
ON a.vendor_id = b.vendor_id
WHERE a.age < 10;

## Query 4 - Select customer name, supplier name, invoice number, invoice date details of supplier
## who can supply part number "10215229"
SELECT i.invoice_nr, i.inv_date, s.name AS 'Supplier_Name', c.customer_name AS 'Customer_Name'
FROM invoice AS i
Inner Join supplier AS s
ON (i.supplier_id = s.supplier_id)
Inner Join customer AS c
ON (i.customer_id = c.customer_id)
WHERE i.supplier_id IN (SELECT s2.supplier_id FROM supply_parts AS s2 WHERE s2.part_nr = "10215229");
           
## Query 5 - Find the trips that used the vehilce id "12" or that happened after 2020-12-31
select trip_id from provide where vehicle_id = '12'
UNION
select trip_id from trip where date > "2021-12-31";

## Query 6 - top 5 part numbers with highest value sold
SELECT  S1.part_nr, S1.price
FROM supplied S1
WHERE 5 > (SELECT COUNT(*)
            FROM supplied AS S2
            WHERE S1.price < S2.price);

## Query 7 - Find the costliest part
SELECT S2.part_nr, (round(S2.price/S2.quantity)) AS per_part_cost
FROM supplied AS S2
WHERE ((round(S2.price/S2.quantity)) >= ALL (SELECT (round(S3.price/S3.quantity)) AS part_cost
																FROM supplied AS S3));

## Query 8 - Find the cargobill number if invoice number is 4733675856 and date is '2007-07-20'
SELECT cargo_bill_nr
FROM cargo_bill
WHERE EXISTS (SELECT invoice_nr, date
			  WHERE invoice_nr = "4733675856"
              AND date='2007-07-20');
              
## Query 9 - create a view of transportation conrtacts
CREATE VIEW Transportation_contracts
AS SELECT * 
FROM contract
WHERE line_of_business = "TRAN";
