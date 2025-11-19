-- get the orders placed this year

USE sql_store;
SELECT *
FROM orders
WHERE order_date >= '2019-01-01';

-- From the order_items table, get the items
-- for order #6
-- where the total price is greater than 30

SELECT *, 
quantity * unit_price AS 'total price'
FROM order_items
WHERE order_id = 6 AND quantity * unit_price > 30;


SELECT *
FROM customers 
WHERE state IN ('VA', 'FL', 'GA');

-- return products with
--  quantity in stock equal to 49, 38, 72

SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- return customers born
-- 				between 1/1/1990 and 1/1/2000
--                 
SELECT *
FROM Customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';
#LIKE operator
SELECT *
FROM customers
WHERE last_name LIKE 'b____y';
-- get the customers whose 
-- 	addresses contain TRAIL or AVENUE

SELECT *
FROM customers
WHERE address LIKE '%TRAIL%' OR 
 	  address LIKE '%AVENUE%';
-- 		phone numbers end with 9
SELECT *
FROM customers
WHERE phone LIKE '%9';

SELECT *
FROM customers 
WHERE address REGEXP 'TRAIL|AVENUE';

USE sql_store;

SELECT *
FROM customers
WHERE last_name REGEXP '[gim]e';

SHOW DATABASES;
SHOW TABLES;

SHOW COLUMNS
FROM  customers;

USE sql_store;
SELECT *
FROM customers
WHERE last_name REGEXP '[a-h]e';

########## REGEX ##########

-- IN REGEXP
-- ^ beginning of a string
-- $ end of a string
-- | logical or
-- [abcd]
-- [a-h]

-- Get the customers whose
-- 		first names are ELKA or AMBUR
-- 		last names end with EY or ON
-- 		last names start with MY or contains SE
-- 		last names contain B followed by R or U 

SELECT *
FROM customers
WHERE first_name REGEXP 'elka|ambur';
-- WHERE last_name REGEXP 'EY$|ON$'
-- WHERE last_name REGEXP '^MY|SE'
-- WHERE last_name LIKE 'MY%' OR last_name LIKE '%SE%'
-- WHERE last_name REGEXP 'b[ru]'

#NULL OPERATOR

SELECT *
FROM customers
WHERE phone IS NULL;

#EXERCISE
-- Get the orders that are not shipped

SELECT *
FROM orders
WHERE shipped_date IS NULL;

#ORDER BY CLAUSE
SELECT first_name, last_name, 10 + customer_id AS points
FROM customers
ORDER BY first_name DESC;
-- ORDER BY state DESC, first_name 
-- ORDER BY points, first_name

#EXERCISE
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;

# the limit clause
SELECT *
FROM customers
LIMIT 3;
-- page 1: 1 - 3
-- page 2: 4 - 6
-- page 3: 7 - 9(when we only need customers in page 3)
-- LIMIT 6, 3


#exercise
Get the top three loyal customers
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

# INNER JOINS
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
#EXERCISE

SELECT order_id, i.product_id, p.name, quantity, i.unit_price
FROM order_items i
JOIN products p ON i.product_id = p.product_id; 

#JOINING ACROSS DATABASES
SELECT *
FROM order_items i
JOIN sql_inventory.products p 
		ON i.product_id = p.product_id;


# SELF JOINS
USE sql_hr;
SELECT e.employee_id, e.first_name AS 'Employee', m.first_name AS 'Manager'
FROM employees e
JOIN employees m
		ON e.reports_to = m.employee_id

#JOINING MULTIPLE TABLES

USE sql_store;

SELECT o.order_id, o.order_date, c.first_name, c.last_name, s.name AS 'status'
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_statuses s ON o.status = s.order_status_id
ORDER BY s.order_status_id, o.order_id;

# EXERCISE
USE sql_invoicing;
SELECT p.date, p.invoice_id, p.amount, c.name, m.name 
FROM payments p
JOIN payment_methods m
		ON p.payment_method = m.payment_method_id
JOIN clients c
		ON p.client_id = c.client_id;


# Compound JOIN Conditions(WE have multiple conditions to join these tables.)
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
		ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id;

## IMPLICIT JOIN Syntax
-- basic one --
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;

-- IMPLICIT JOIN SYNTAX -- Mostly avoid it.
SELECT *
FROM orders o, customers c
WHERE  o.customer_id = c.customer_id;

-- avoid this imlicit because if we forget where clause, then we get cross JOIN

-- cross JOIN-- Upcoming--
SELECT *
FROM orders o, customers c;

-- OUTER JOINS
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

## Exercise
#products table and order_items table
SELECT p.product_id, name, quantity
FROM products p
LEFT JOIN order_items oi ON
	p.product_id = oi.product_id;

## OUTER JOINS between Multiple Tables

SELECT c.customer_id, c.first_name, o.order_id, sh.name AS 'Shipper'
FROM customers c
LEFT JOIN orders o ON
	c.customer_id = o.customer_id
LEFT JOIN shippers sh ON
	o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

## Exercise
SELECT o.order_date, o.order_id, c.first_name, sh.name AS 'shipper', os.name AS 'status'
FROM orders o
LEFT JOIN customers c ON
	o.customer_id = c.customer_id
LEFT JOIN shippers sh ON
	o.shipper_id = sh.shipper_id
JOIN order_statuses os ON 
	o.status = os.order_status_id
ORDER BY os.order_status_id, order_id;


## SELF OUTER JOINS
USE sql_hr;

SELECT e.employee_id, e.first_name AS EMPLOYEE, e1.first_name AS MANAGER
FROM employees e
LEFT JOIN employees e1 
ON e.reports_to= e1.employee_id;

## THE USING CLAUSE
USE sql_store;
SELECT 
	o.order_id, 
    c.first_name,
    sh.name AS shipper
FROM orders o 
JOIN customers c
	-- ON o.customer_id = c.customer_id #when to column name in two tables are same, then we easily use using clause
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);

--  
-- 		

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id AND
-- 		oi.product_id = oin.product_id #when we have two primary keys, and instead of this, we use USING CLAUSE.
        USING (order_id, product_id);

## EXERCISE
USE sql_invoicing;
SELECT p.date, c.name AS client, p.amount, pm.name AS 'Payment Method'
FROM payments p
LEFT JOIN clients c
	USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;


## NATURAL JOINS
USE sql_store;
SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c; ##DONT USE THIS NATURAL JOINS

## CROSS JOINS
SELECT 
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p # In CROSS JOIN here evry record of customers table combined with evry record in products table
ORDER BY c.first_name;

## EXERCISE
-- do a cross join between shippers and products 
-- using the implicit syntax
-- and when using explicit syntax
# EXPLICIT CROSS JOIN Syntax
SELECT 
	p.name AS Product,
    s.name AS Shippers
FROM products p 
CROSS JOIN shippers s
ORDER BY p.name;

#IMPLICIT CROSS JOIN Syntax
SELECT
	p.name AS Product,
    s.name AS Shippers
FROM products p, shippers s
ORDER BY p.name;

## With JOINS we can only combine columns  
## BUT IN SQL
## we can also combine rows from multiple tables ---- EXTREMELY POWERFUL

SELECT 
	order_id,
    order_date,
    'Active' AS STATUS
FROM orders
WHERE order_date >= '2019-01-01';

-- #SO Actual thing here is that we have to archive the orders in previous year and only want current year order.
-- # But here if we use date in using normal WHERE CLAUSE, we can get trouble next year, that we have to change again, so without it, we have to do this query 
-- # without hot-coding the date. 
-- UNION
SELECT 
	order_id,
    order_date,
    'Archived' AS STATUS
FROM orders
WHERE order_date < '2019-01-01';

#With UNION the number of columns each query selected should be same!
SELECT first_name
FROM customers
UNION 
SELECT name
FROM shippers;

## EXRCISE
SELECT 
	customer_id, 
    first_name, 
    points, 
    'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
	customer_id, 
    first_name, 
    points, 
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION 
SELECT 
	customer_id, 
    first_name, 
    points, 
    'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;

## COLUMN Attributes
# HOW to INSERT, DELETE AND UPDATE DATA
INSERT INTO customers
VALUES (DEFAULT, 
	'John', 
	'Smith', 
    '1990-01-01',
	 NULL,
	'adress',
	'city', 
    'CA',
	 DEFAULT);
# or we can choose instead of null values and default values like
INSERT INTO customers(
	first_name, last_name, birth_date, address, city, state)
VALUES ( 
	'John', 
	'Smith', 
    '1990-01-01',
	'adress',
	'city', 
    'CA');
# or we can even list them in any order
INSERT INTO customers(
	last_name, first_name, birth_date, address, city, state)
VALUES ( 
	'Smith', 
    'John', 
    '1990-01-01',
	'adress',
	'city', 
    'CA');


## INSERTING MULTIPLE ROWS
INSERT INTO shippers (name)
VALUES('Shipper1'),
	  ('Shipper2'),
      ('Shipper3');

## EXERCISE
-- Insert three rows in the products table
INSERT INTO products(name, quantity_in_stock, unit_price)
Values('copra', 3, 20),
	  ('aloo', 7, 24),
      ('pine', 9, 49);

## INSERTING HIERARCHICAL ROWS
# orders is parent table, and order items is child table, where we have to insert in both tables, some data is in one table and other in other table.alter
INSERT INTO orders(customer_id, order_date, status)
VALUES (1, '2019-01-02', 1); 
-- # we have add from valid customer id, check from customers table

INSERT INTO order_items
VALUES 
		(LAST_INSERT_ID(), 1, 1, 2.95),
		(LAST_INSERT_ID(), 2, 1, 3.95);


## CREATING A COPY OF A TABLE
CREATE TABLE orders_archived AS 
SELECT * FROM orders; ## This is sub query 
# sub query is SELECT statement that is part of another sql statement 

## we can also use sub query in an INSERT statement, which is a very powerful technique.

## ..
INSERT INTO orders_archived
SELECT *
 FROM orders
 WHERE order_date < '2019-01-01';

## EXERCISE
USE sql_invoicing;
CREATE TABLE invoices_archived
SELECT 
		i.invoice_id,
        i.number,
        c.name,
        i.invoice_total,
        i.payment_total,
        i.invoice_date,
        i.due_date,
        i.payment_date
FROM invoices i
JOIN clients c USING 
		(client_id)
WHERE i.payment_date IS NOT NULL;

## UPDATE record in table
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1;

## RESTORE 
## AS there are default values for the records which we wanna restore
UPDATE invoices
SET payment_total = DEFAULT, payment_date = DEFAULT
WHERE invoice_id = 1;

# Instead of default values, we can also give the expressions.

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE invoice_id = 3;


## UPDATING Multiple Rows
USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN (3, 4); # if we wanna change for every row, then don't write this line or subquery or statement.

## EXERCISE

-- Write a SQL statement to 
-- 	give any customer born before 1990
-- 	50 extra points

USE sql_store;

UPDATE customers
SET 
	points = points + 50
WHERE birth_date < '1990-01-01';

## Using SUBQUERIES in UPDATES --- very powerful

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN  
			(SELECT client_id
			FROM clients
			WHERE state IN ('CA', 'NY'));

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date;
    
SELECT *
FROM invoices
WHERE payment_date IS NULL;

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE payment_date IS NULL ;


