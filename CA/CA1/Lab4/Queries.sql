--Question 1
--Identify how many employees are currently working in each department
SELECT COUNT(employee_id), department_name FROM employees
INNER JOIN departments USING (department_id)
GROUP BY department_name;

--Create a view
--Join employee table to view
--create new table after
CREATE VIEW EmployeeDepartment (employee_id, department_name)
AS SELECT COUNT(employee_id), department_name FROM employees
INNER JOIN departments USING (department_id)
GROUP BY department_name;

SELECT * FROM EmployeeDepartment;