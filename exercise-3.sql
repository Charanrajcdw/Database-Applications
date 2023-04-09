USE hr;

SHOW tables;

SELECT * FROM COUNTRIES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM EMP_DETAILS_VIEW;

-- 1.Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
SELECT sum(salary) as total_salary FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id=d.department_id
JOIN LOCATIONS l ON d.location_id=l.location_id
WHERE city='Seattle' AND first_name!='Nancy';

-- 2.Fetch all details of employees who has salary more than the avg salary by each department.
SELECT *  FROM employees e1
JOIN (SELECT avg(salary) as avg_salary,department_id FROM employees GROUP BY department_id) e2
ON e1.department_id=e2.department_id 
WHERE e1.salary > e2.avg_salary
ORDER BY e1.department_id;

-- 3.Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
SELECT count(e.employee_id) as employee_count,city FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE salary>=7000 and salary<10000
GROUP BY l.city;

-- 4.Fetch max salary, min salary and avg salary by job and department. 
-- Info:  grouped by department id and job id ordered by department id and max salary
SELECT max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary,department_id,job_id
FROM employees
GROUP BY department_id,job_id
ORDER BY department_id,max_salary;

-- 5.Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy  
SELECT sum(salary) as total_salary FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id=d.department_id
JOIN LOCATIONS l ON d.location_id=l.location_id
WHERE country_id='US' AND first_name!='Nancy';

-- 6.Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
SELECT max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary,department_id,job_id
FROM employees
WHERE employee_id IN (SELECT employee_id FROM job_history
GROUP BY employee_id HAVING count(employee_id)>1)
GROUP BY department_id,job_id;

-- 7.Display the employee count in each department and also in the same result.  
-- Info: * the total employee count categorized as "Total"
-- • the null department count categorized as "-" *
SELECT coalesce(department_id,'0') as department_id, count(department_id) as employee_count from employees
GROUP BY department_id;

-- 8.Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1	100
-- 2	4
SELECT employee_id,count(employee_id) as job_count FROM employee t1 GROUP BY employee_id
RIGHT OUTER JOIN
SELECT employee_id,count(employee_id) as job_count FROM job_history t2 GROUP BY employee_id 
ON t1.employee_id=t2.employee_id
ORDER BY employee_id;

-- 9.Display average salary by department and country.
SELECT c.country_name,d.department_id,avg(e.salary) FROM employee e 
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
GROUP BY c.country_name,d.department_id
ORDER BY c.country_name;

-- 10.	Display manager names and the number of employees reporting to them by countries
-- (each employee works for only one department, and each department belongs to a country)
SELECT concat(e2.first_name,' ',e2.last_name) as manager,count(e1.manager_id) as employees_reporting,c.country_name
FROM employees e1 
JOIN employees e2 ON e1.manager_id=e2.employee_id
JOIN departments d ON d.department_id=e1.department_id
JOIN locations l ON l.location_id=d.location_id
JOIN countries c ON c.country_id=l.country_id
GROUP BY e1.manager_id,e2.first_name,e2.last_name,c.country_name;

-- 11.Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. 
-- (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5
SELECT department_id,
count(case when salary >= 0 and salary <= 10000 then 1 end) as "0-10000",
count(case when salary > 10000 and salary <= 20000 then 1 end) as "10000-20000",
count(case when salary > 20000 and salary <= 30000 then 1 end) as "20000-30000",
count(case when salary > 30000 then 1 end ) AS "Above 30000"
FROM employee
GROUP BY department_id;

-- 12.Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg Salary
-- 10              Germany      34242.8
SELECT c.country_name, count(employee_id) as employee_count, round(avg(salary),2) as average_salary
FROM employee e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
GROUP BY c.country_name;

-- 13.Display region and the number off employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty)

SELECT r.region_name, d.department_id, count(*) as employee_count
FROM employee e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id
GROUP BY r.region_id,r.region_name,d.department_id;

-- 14.Select the list of all employees who work either for one or more departments
-- or have not yet joined / allocated to any department
SELECT employee_id,iff(count(department_id)=0, 'Not yet joined','Working in one or more department')
FROM employees 
GROUP BY employee_id,department_id;

-- 15.write a SQL query to find the employees and their respective managers.
-- Return the first name, last name of the employees and their managers
SELECT e1.first_name,e1.last_name, concat(e2.first_name,' ',e2.last_name) as manager_name
FROM employee e1 
JOIN employee e2 on e1.manager_id = e2.employee_id;

-- 16.write a SQL query to display the department name, city, and state province for each department.
SELECT d.department_name,l.city,l.state_province FROM departments d
JOIN locations l on d.location_id = l.location_id;

-- 17.write a SQL query to list the employees (first_name , last_name, department_name) 
-- who belong to a department or don't
SELECT first_name,last_name,department_name,
iff(e.department_id IS NULL, 'Does not belong to a department','Belongs to a department') as department_status
FROM employees e LEFT OUTER JOIN departments d ON e.department_id=d.department_id; 

-- 18.The HR decides to make an analysis of the employees working in every department.
-- Help him to determine the salary given in average per department 
-- and the total number of employees working in a department.
-- List the above along with the department id, department name
SELECT e.department_id,d.department_name,e.employee_count,e.average_salary FROM (
SELECT department_id,avg(salary) as average_salary,count(*) as employee_count
FROM employee GROUP BY department_id) e
JOIN departments d ON d.department_id = e.department_id;

-- 19.Write a SQL query to combine each row of the employees 
-- with each row of the jobs to obtain a consolidated results.
-- (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT * FROM employee JOIN jobs;

-- 20.Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
SELECT e.first_name,e.last_name,e.email,region_name FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id
WHERE region_name in ('Europe','Asia');

-- 21.Write a query to display full name with alias as FULL_NAME 
-- (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry")
-- who are from oxford city and their second last character of their last name is 'e'
-- and are not from finance and shipping department.
SELECT concat(e.first_name,' ',e.last_name) as full_name FROM employee e
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id 
WHERE l.city = 'Oxford' AND substr(e.last_name, -2, 1) = 'e' AND d.department_name NOT IN ('Shipping','Finance');

-- 22.Display the first name and phone number of employees who have less than 50 months of experience
SELECT first_name, last_name, phone_number FROM employee
WHERE DATEDIFF(month,hire_date,CURRENT_DATE) < 50;

-- 23.Display Employee id, first_name, last name, hire_date and salary for employees
-- who has the highest salary for each hiring year.(For eg: John and Deepika joined on year 2023,
-- and john has a salary of 5000, and Deepika has a salary of 6500.
-- Output should show Deepika’s details only).
SELECT e1.employee_id, e1.first_name, e1.last_name, e1.hire_date, e1.salary 
FROM employee e1
JOIN (SELECT year(hire_date) as join_year,max(salary) as max_salary
FROM employee GROUP BY join_year) e2
ON year(e1.hire_date) = e2.join_year AND e1.salary = e2.max_salary;