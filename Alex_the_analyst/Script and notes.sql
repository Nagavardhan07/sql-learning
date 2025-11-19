SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name, last_name, birth_date, age, (age + 10) * 10
FROM parks_and_recreation.employee_demographics;

#PEMDAS OR BODMAS + EXPONENT
# PARENTHESIS, EXPONENT, MULTIPLICATION, DIVISION, ADDITION, SUBTRACTION

SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics; 
# SELECT STATEMENT
# WHERE CLAUSE 
-- LIKE STATEMENT -- % AND _
 
-- NOW GROUP BY
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;


-- ORDER BY -- JUST SORT EITHER IN ASCENDING OR DESCENDING ORDER
SELECT *
FROM employee_demographics
ORDER BY gender, age;

-- or
-- NOT RECOMMENDED -- 
SELECT *
FROM employee_demographics
ORDER BY 5, 4; -- by column number -- but this is not recommended
-- and this could be a problem if we are using stored procedure or triggers, like adding or removing columns, and these column number are mistaken for other.
-- 


 -- # HAVING VS WHERE CLAUSE
 -- DIFFERENCE BETWEEN EM'
SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender;
 -- This is wrong, because, when we select some column and aggregate function, that aggregate functions occurs only after grouping or group by
-- because the grouping doesn't yet occured when where clause is run.
-- so the correct order is
 -- HAVING is particularly created for this purposed example
 
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary)
FROM employee_salary
-- WHERE occupation LIKE '%manager%'
GROUP BY occupation;



# -- Limit and ALIASING

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1;

-- Aliasing-
-- AS

-- JOINS
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

 -- Inner JOIN
SELECT ed.employee_id, age, occupation
FROM employee_demographics ed -- or we can use FROM employee_demographics AS ed
JOIN employee_salary es
		ON ed.employee_id = es.employee_id;

-- OUTER JOINS        
-- LEFT JOIN and RIGHT JOIN

SELECT *
FROM employee_demographics ed
RIGHT JOIN employee_salary es
		ON ed.employee_id = es.employee_id;
        
-- SELF JOIN

SELECT e1.employee_id AS emp_santa, 
	e1.first_name AS first_name_santa,
    e1.last_name AS first_name_santa,
    e2.employee_id AS emp, 
	e2.first_name AS first_name_emp,
    e2.last_name AS first_name_emp
FROM employee_salary e1
JOIN employee_salary e2
	ON e1.employee_id + 1 = e2.employee_id;


-- JOINING MULTIPLE TABLES
SELECT *
FROM employee_demographics ed 
JOIN employee_salary es
		ON ed.employee_id = es.employee_id
JOIN parks_departments pd
	ON es.dept_id = pd.department_id;
        
SELECT *
FROM parks_departments;

-- UNIONS
-- UNION gonna remove all the duplicates even if we use DISTINCT or not using it.

SELECT first_name, last_name
FROM  employee_demographics
UNION -- or UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

-- If we wanna sow all instead of removing duplicates, we just use UNION ALL

SELECT first_name, last_name
FROM  employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;
 --
 -- Ex
 --
SELECT first_name, last_name, 'old' AS Label
FROM  employee_demographics
WHERE age > 50;

--
-- EX
--
SELECT first_name, last_name, 'old Man' AS AGE_Label
FROM  employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'old Lady' AS AGE_Label
FROM  employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS Salary_Label
FROM  employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;


# -- STRING FUNCTIONS

SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name) AS LENGTH
FROM employee_demographics
ORDER BY LENGTH;

-- or

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

-- EX

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT TRIM('                  sky                ');
SELECT LTRIM('                  sky                '); --  left trim
SELECT RTRIM('                  sky                '); -- right trim

SELECT first_name, 
	LEFT(first_name, 4),
    RIGHT(first_name, 4),
    SUBSTRING(first_name, 3, 2),
    birth_date,
    SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;


-- REPLACE
SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

-- LOCATE
SELECT LOCATE('x', 'ALEXANDER');

SELECT first_name, LOCATE('an', first_name)
FROM employee_demographics;

-- CONCATENATION
SELECT first_name, last_name,
	CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

## -- CASE STATEMENT -- 
-- CASE Statement allows us to add logic to the SELECT statement, sort of like IF ELSE Statement like programming language.

SELECT first_name,
	last_name,
    age,
    CASE
		WHEN age <= 30 THEN 'Young' 
        WHEN age BETWEEN 31 AND 50 THEN 'Old'
        WHEN age >= 50 THEN "On Death's Door"
	END AS Age_Bracket
FROM employee_demographics;
 
 -- Ex 
 --
-- Pay Increase adn Bonus
-- who made < 50000 = 5% bonus
-- who made > 50000 = 7% bonus
-- who are in Finance = 10% bonus

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary * 1.07 -- or salary + (salary * 0.07)
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.10
END AS Bonus
FROM employee_salary;



SELECT *
FROM employee_salary;
SELECT *
FROM parks_departments;


## -- SUBQUERIES -- 
-- Query within another query

-- Use SUBQUERY in WHERE Clause, and 
-- then in SELECT Clause 
-- and in FROM Clause
-- in WHERE clause
SELECT *
FROM employee_demographics
WHERE employee_id IN 
					(SELECT employee_id
						FROM employee_salary
                        WHERE dept_id = 1)
;

-- In SELECT Clause
-- below this is not what we need, it does give the avg of the all salary. we need avg of salaries present in salary column without group by....HOW?
SELECT first_name, salary, AVG(salary) -- when we use aggregate functions we should always use GROUP BY, and all columns written in select statement should be there in GROUP BY EXCEPT aggregate functions.
FROM employee_salary
GROUP BY first_name, salary;

-- This is How!

SELECT first_name, salary,
(SELECT AVG(salary)
	FROM employee_salary) 
FROM employee_salary;



-- SUBQUERY IN FROM STATEMENT

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT  AVG(max_age)-- when we didn't used alias we use SELECT  AVG(`MAX(age)`) -- It is ` 'backtick' -- below esc key, or we use took alias, SELECT  AVG(max_age)
FROM
(SELECT gender, AVG(age) AS avg_age, 
				MAX(age) AS max_age, 	
                MIN(age)AS min_age, 	
                COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS agg_table;





## -- ## -- WINDOW FUNCTIONS -- ## -- ##

-- This is normal one
SELECT ed.first_name, ed.last_name, gender, AVG(salary) AS avg_salary
FROM employee_demographics ed
JOIN employee_salary es
		ON ed.employee_id = es.employee_id
GROUP BY ed.first_name, ed.last_name, gender;

-- This is window function
SELECT ed.first_name, ed.last_name, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics ed
JOIN employee_salary es
		ON ed.employee_id = es.employee_id;
        
-- Ex - 2
SELECT ed.employee_id, ed.first_name, ed.last_name, gender, salary, SUM(salary) OVER(PARTITION BY gender ORDER BY ed.employee_id) AS Rolling_Total
FROM employee_demographics ed
JOIN employee_salary es
		ON ed.employee_id = es.employee_id;

-- SPECIAL THINGS WE CAN ONLY DO IN WINDOW FUNCTIONS.
SELECT ed.employee_id, ed.first_name, ed.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics ed
JOIN employee_salary es
		ON ed.employee_id = es.employee_id;
        
        
###########################################################
########  --- CTE'S -- Common Table Expression #############

WITH CTE_Example AS -- naming CTE or defining CTE
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics ed
JOIN employee_salary es
	ON ed.employee_id = es.employee_id
    GROUP BY gender
)
SELECT AVG(avg_sal) -- or *
FROM CTE_Example; -- we can use CTE as soon as we created it.
-- we can use it only for once after creating it. like only one query after defining it.
-- Its more readable than normal, and easy to read and understand. PREFER THIS!

-- or this is the normal way of getting the same as above(WITH CTE)
-- CREATE VIEW AVG_SALARY AS -- just tried how to craete views adn it is very easy.
SELECT AVG(avg_sal)
FROM (
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics ed
JOIN employee_salary es
	ON ed.employee_id = es.employee_id
    GROUP BY gender
) example_subquery
;

-- Basic example of joining multiple CTE's
WITH CTE_Example AS -- naming CTE or defining CTE
(
SELECT employee_id, gender, birth_date
FROM employee_demographics ed
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example c1
JOIN CTE_Example2 c2
		ON c1.employee_id = c2.employee_id
;

-- and we can use it like this too
WITH CTE_Example (Gender, AVG_SAL, MAX_SAL, MIN_SAL, COUNT_SAL) AS -- naming CTE or defining CTE
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics ed
JOIN employee_salary es
	ON ed.employee_id = es.employee_id
    GROUP BY gender
)
SELECT * -- or *
FROM CTE_Example
;
-- So CTE's are generally useful because they are readable, 
-- and it helps in most of the complex problems 
-- and also some problems which aren't able to solve normally.

#####################################################
 ###### --- TEMPORARY TABLES --- ######

CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(100) 
);

SELECT *
FROM temp_table;

-- we can use the temp table multiple times liek for manipulating it., before storing it in a permanant table
-- its like abit advanced to CTE

INSERT INTO temp_table
VALUES ('nag', 'k', 'KING OF KOTHA');

SELECT *
FROM temp_table;

-- ex-- we need a sub section from salary table, where salary is greater tahn 50000
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;



############################################
######## -- STORED PROCEDURE -- ############

SELECT *
FROM employee_salary
WHERE salary >= 50000;


-- super simple
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- CALL large_salaries();

-- A bit complex than super simple
-- just changed the delimiter from ; to $$
DELIMITER $$ 
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000; 
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ; 

-- good practice after this stored procedure as we used delimiter changed, good practice to change back. at the end.

CALL large_salaries3();

-- THIS PROCEDURE NOT CRATING, IT THROWING AN ISSUE IN MY SQL SERVER, SHOWING SQL ERROR IN SYNTAX PLEASE LOOK INTO IT
-- IF WE RUN THIS QUERY WE GET TWO TABLES, AS THERE ARE TWO STATEMENTS INSIDE THE PROCEDURE.
-- CHECK WHY DELIMITER IN MY SQL SERVER NOT WORKING
-- AND WE CAN ALSO ALTER EVERYTHING IN PROCEDURE BY CLICKING ALTER IN SCHEMAS -> STORED PROCEDURES -> RIGHT CLICK ON THE PROCEDURE
-- WE CAN ALSO CRATE THE PROCEDURE FROM SCHEMAS.

-- AND IT A GOOD PRACTICE TO USE DROP TABLE IF EXISTS 'table_name'; -- OR -- DROP PROCEDURE IF EXISTS 'proc_name()';

-- just changed the delimiter from ; to $$
USE parks_and_recreation;

DELIMITER $$ 
USE parks_and_recreation $$

CREATE PROCEDURE large_salaries_4(employee_id_param INT)
BEGIN
	SELECT *
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$

DELIMITER ;


##########################################
####### -- TRIGGERS AND EVENTS -- ########

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- if we gonna have multiple QUERIES in code, then this gonna help us. as we gonna use normal delimimter inside.
-- so if we use a comment on side of delimiter as shown below., it won't run.
DELIMITER $$  

CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

-- We can't do anything, like alter or something, with trigger inside the schemas.
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

###########################################
######### EVENTS ##########
-- when we are importing data, you can pull data from a specific file path on a schedule.
-- We can build report taht are exported to a file on a schedule
-- you can do it dialy, weekly, monthly, yearly... whatever
-- super helpful for autoation in general.

SELECT *
FROM employee_demographics;

-- if the age is more than 60, automatically retire

DROP EVENT IF EXISTS delete_retirees;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age>= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';
