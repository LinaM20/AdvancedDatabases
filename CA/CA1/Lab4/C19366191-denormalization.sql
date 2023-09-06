--Question 1: Storing a derivable value

--Query to demonstrate what is desired: Identify how many employees are currently working in each department
SELECT COUNT(employee_id), department_name FROM employees
INNER JOIN departments USING (department_id)
GROUP BY department_name;

--This will alter the departments table to add a column called 
--employee_count to an integer
ALTER TABLE departments ADD COLUMN employee_count integer;

--This will update the departments table to populate it with the data
--using a sub-query. It show the count of each employee
--in each department
UPDATE departments 
SET employee_count = (SELECT count(employee_id) FROM employees
WHERE departments.department_id = employees.department_id);

COMMIT;


--Query to demonstrate the solution
--This will show the count, department name and department id the count is
--more than 3
SELECT employee_count, department_id, department_name
FROM departments
WHERE employee_count > 3;


--Question 2: Short circuit key
SELECT dependent_id, employee_id, department_id, location_id
FROM dependents
JOIN employees USING (employee_id)
JOIN departments USING (department_id);

--Add column department id and location id to the table dependents
ALTER TABLE dependents ADD COLUMN department_id integer, ADD COLUMN location_id integer;

--Department id and location id will be a foreign key in the dependents table
ALTER TABLE dependents
ADD CONSTRAINT fk_department_id
FOREIGN KEY (department_id) REFERENCES departments(department_id), 
ADD CONSTRAINT fk_location_id
FOREIGN KEY (location_id) REFERENCES locations(location_id);

--Add department id data to the dependents table
UPDATE dependents SET department_id = employees.department_id
FROM employees
WHERE dependents.employee_id = employees.employee_id;
COMMIT;

--Add location id data to the location table
UPDATE dependents SET location_id = departments.location_id
FROM departments
WHERE dependents.department_id = departments.department_id;
COMMIT;

--Query to show how to find the names of the dependents who are 
--associated with department id and location id
SELECT dependent_id, location_id, first_name, last_name, department_id
FROM dependents
WHERE department_id = 9;


--Question 3
--Query to understand the problem
SELECT employee_id, employees.first_name, employees.last_name, dependent_id, dependents.first_name, dependents.last_name
FROM employees
JOIN dependents USING (employee_id);

--Creating a view that contains the employee id, names and the dependents
--id and names. 
CREATE MATERIALIZED VIEW EmployeeDetailsDependents
AS SELECT employee_id, employees.first_name employee_first_name, 
employees.last_name employee_last_name, dependent_id, 
dependents.first_name dependents_first_name, dependents.last_name dependents_last_name
FROM employees
JOIN dependents USING(employee_id)
WITH DATA;

SELECT * FROM EmployeeDetailsDependents;

--Question 4
--View to get the current employee info
CREATE OR REPLACE VIEW CurrentEmployeeInfo
AS SELECT employees.employee_id, job_title, department_name, startdate,
(SELECT CONCAT(first_name, ' ', last_name) as m_name 
FROM employees manager 
WHERE manager.employee_id = employees.manager_id)
AS manageremployee
FROM employees
 JOIN departments USING (department_id)
 JOIN jobhist USING (department_id)
 JOIN jobs on jobs.job_id = jobhist.job_id;

--Creating a new view to hold the employee current role info
SELECT * FROM CurrentEmployeeInfo;

--Creating a view to hold the employees previous info we are getting the starting 
--position here as we want to get the employees first role
CREATE OR REPLACE VIEW EmployeePreviousInfo
AS SELECT job_title, jobhist.salary, department_name, enddate, job_id
FROM jobs
 JOIN jobhist USING (job_id)
 JOIN departments USING (department_id)
where changedesc = 'Starting Position';

SELECT * FROM EmployeePreviousInfo;