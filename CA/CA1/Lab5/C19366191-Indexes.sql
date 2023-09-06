SET ENABLE_SEQSCAN = off;

--Question 1: identify how many employees are currently working in each department
--1.a Running the query without indexes
--Query to demonstrate what is desired: number of employees in each department
SELECT COUNT (DISTINCT employee_id), department_name
FROM employees
JOIN departments USING (department_id)
GROUP BY department_name;

--Using explain analyse on the query
EXPLAIN ANALYSE
SELECT COUNT (DISTINCT employee_id), department_name
FROM employees
JOIN departments USING (department_id)
GROUP BY department_name;


select * from employees;
--1.b Running the query with an index
--Query with index to demonstrate what is desired: add index on department name
CREATE UNIQUE INDEX department_name_index on departments ( department_name );

EXPLAIN ANALYSE
SELECT COUNT (employee_id), department_name
FROM employees
JOIN departments USING (department_id)
GROUP BY department_name;

--Question 2: identify how many departments are currently based in each city

--2.a Running the query without indexes
--Query to demonstrate what is desired: number of departments in each city
SELECT COUNT (department_id), city
FROM departments
JOIN locations USING (location_id)
GROUP BY city;

--Using explain analyse on the query
EXPLAIN ANALYSE
SELECT COUNT (department_id), city
FROM departments
JOIN locations USING (location_id)
GROUP BY city;

--2.b Running the query with an index
--Query with index to demonstrate what is desired: add index on city name
CREATE UNIQUE INDEX city_name_index on locations ( city );

EXPLAIN ANALYSE
SELECT COUNT (department_id), city
FROM departments
JOIN locations USING (location_id)
GROUP BY city;

--Question 3: full set of information on each employee

--3.a Running the query without indexes
--Drop indexes from before
DROP INDEX department_name_index;
DROP INDEX city_name_index;

--Query to demonstrate what is desired: employee information
SELECT employee_id, first_name, last_name, email, phone_number, salary, hire_date, 
job_title, department_name,
(SELECT CONCAT(first_name, ' ', last_name) as m_name FROM employees manager WHERE manager.employee_id = employees.manager_id)
FROM departments
JOIN employees USING (department_id)
JOIN jobs USING (job_id)
ORDER BY job_title;

EXPLAIN ANALYSE
SELECT employee_id, first_name, last_name, email, phone_number, salary, hire_date, 
job_title, department_name,
(SELECT CONCAT(first_name, ' ', last_name) as m_name FROM employees manager WHERE manager.employee_id = employees.manager_id)
FROM departments
JOIN employees USING (department_id)
JOIN jobs USING (job_id)
ORDER BY job_title;

--3.b Running the query with an index
--Query with index to demonstrate what is desired: add indexes
--First Index
CREATE INDEX employee_details_index on employees ( employee_id, first_name, last_name );

--Second Index
CREATE INDEX job_title_index ON jobs (job_title);

--Third Index
CREATE INDEX employee_index ON employees ( employee_id, email, phone_number );

EXPLAIN ANALYSE
SELECT employee_id, first_name, last_name, email, phone_number, salary, hire_date, 
job_title, department_name,
(SELECT CONCAT(first_name, ' ', last_name) as m_name FROM employees manager WHERE manager.employee_id = employees.manager_id)
FROM departments
JOIN employees USING (department_id)
JOIN jobs USING (job_id)
ORDER BY job_title;