-- Step 1: Aggregate Window Functions (start simple)

-- 👉 Use the employees table.

-- Find total salary per department (while still showing each employee).

-- Find average salary per department.

-- Calculate cumulative salary per department ordered by join date.

-- Show running total of salaries company-wide.

### -- 1.1
SELECT *, SUM(salary) OVER(PARTITION BY department)
FROM employees;
-- 1.2
SELECT *, AVG(salary) OVER(PARTITION BY department)
FROM employees;
-- 1.3
SELECT *, SUM(salary) OVER(PARTITION BY department ORDER BY join_date)
FROM employees;
-- 1.4
SELECT *, SUM(salary) OVER(ORDER BY emp_id)
FROM employees;

-- Step 2: Ranking Functions

-- 👉 Use employees.

-- Rank employees by salary within department (RANK).

-- Assign row numbers by join date (ROW_NUMBER).

-- Use DENSE_RANK to avoid gaps in ranking.

-- Get top 2 highest paid employees per department.

-- 2.1
SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary) AS emp_rank
FROM employees;	
-- 2.2
SELECT *, ROW_NUMBER() OVER(ORDER BY join_date) AS joining_rank
FROM employees;
-- 2.3
SELECT *, DENSE_RANK() OVER(PARTITION BY department ORDER BY salary) AS dense_emp_rank
FROM employees;
-- 2.4
SELECT * 
FROM (SELECT emp_id, emp_name, department, salary, ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS num_row
	  FROM employees) AS Ranking
WHERE num_row <= 2;


-- Step 3: Value Functions

-- 👉 Use sales (date-based practice).

-- Show each sale with previous sale’s amount (LAG).

-- Show each sale with next sale’s amount (LEAD).

-- Find difference between current and previous sales.

-- Show moving average (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).

-- 3.1
SELECT *, LAG(sale_amount, 1) OVER(ORDER BY sale_date) AS prev_sale
FROM sales;
-- 3.2
SELECT *, LEAD(sale_amount, 1) OVER(ORDER BY sale_date) AS Next_sale
FROM sales;
-- 3.3
SELECT *, LAG(sale_amount, 1) OVER(ORDER BY sale_date) AS Prev_sale, (sale_amount - LAG(sale_amount, 1) OVER(ORDER BY sale_date)) AS diff_curr_prev
FROM sales;
-- 3.4
SELECT *, AVG(sale_amount) OVER(ORDER BY sale_date ROWS BETWEEN 2 preceding AND current ROW) AS aveg_3_row
FROM sales;
-- Step 4: Statistical Functions

-- 👉 Use employees and sales.

-- Show percentile rank of salaries (PERCENT_RANK).
-- 4.1
SELECT *, PERCENT_RANK() OVER(ORDER BY salary) AS Percentile_rank
FROM employees;
-- Find CUME_DIST of salaries within department.
-- 4.2
SELECT *, CUME_DIST() OVER(PARTITION BY department ORDER BY salary) AS cummulative_distribution
FROM employees;
-- NTILE(4): Divide employees into 4 quartiles by salary.
-- 4.3
SELECT *, NTILE(4) OVER(ORDER BY salary) AS Quartile
FROM employees; 
-- Find median salary using window functions.
-- 4.4 --------- later
-- Step 5: Realistic Queries (joins + multiple tables)

-- 👉 Use orders + employees.

-- For each customer, show total orders and running total over time.
-- 5.1
SELECT *, SUM(order_amount) OVER(PARTITION BY customer_id ORDER BY order_id) AS running_cost_customer_wise
FROM orders;

-- For each order, rank employees based on total orders handled.
SELECT emp_id, emp_name, department, RANK() OVER(ORDER BY orders_count_table.total_orders) AS Ranking
FROM employees e
JOIN (SELECT employee_id, COUNT(*) AS total_orders
	  FROM orders o
	  GROUP BY employee_id) AS orders_count_table
ON e.emp_id = orders_count_table.employee_id;


-- Find top 3 customers by total order value per region.
SELECT customer_id, employee_id, regionwise_count_table.region, SUM(order_amount) OVER(PARTITION BY regionwise_count_table.region ORDER BY each_region_count)
FROM orders o
JOIN 
	(SELECT region, COUNT(*) AS each_region_count
	FROM orders 
	GROUP BY region) AS regionwise_count_table 
    ON o.region = regionwise_count_table.region;

-- Practice from student_window_function_2
-- A. Aggregate Window Functions

-- Show each student’s score per subject and average score of their class.

-- Show cumulative score for each student ordered by exam_date.

-- Show running total score per subject.
--  a.1

