


CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

/*Data for the table employees */

insert /*+ APPEND */ into employees 
(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id)
select rownum, 'firstname'||rownum, 'lastname'||rownum , rownum||'@mail.com', '01 968'||rownum, current_date,
random_between(1,19),
rownum+20000, 
random_between(200,206),
random_between(1,11)
from generate_series(300, 1000) as rownum;


