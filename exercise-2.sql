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

-- 1.Write a SQL query to remove the details of an employee whose first name ends in ‘even’
DELETE FROM EMPLOYEES WHERE FIRST_NAME LIKE '%even';

-- 2.Write a query in SQL to show the three minimum values of the salary from the table.
SELECT DISTINCT SALARY FROM EMPLOYEES ORDER BY SALARY LIMIT 3;

-- 3.Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
CREATE TABLE employee LIKE employees;
INSERT INTO employee SELECT * FROM employees;
DROP TABLE employees;

-- 4.Write a SQL query to remove the column Age from the table
ALTER TABLE employees DROP COLUMN age;

-- 5.Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
SELECT concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME, EMAIL, year(HIRE_DATE) as HIRE_YEAR FROM employees WHERE HIRE_YEAR<2000;

-- 6.Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
SELECT EMPLOYEE_ID, JOB_ID FROM JOB_HISTORY WHERE year(START_DATE) BETWEEN 1990 AND 1999;

-- 7.Find the first occurrence of the letter 'A' in each employees Email ID 
-- Return the employee_id, email id and the letter position
SELECT EMPLOYEE_ID, EMAIL, charindex('A',EMAIL) as LETTER_POSITION FROM employees;

-- 8.Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
SELECT EMPLOYEE_ID, concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME, EMAIL FROM employees WHERE length(FULL_NAME)<12;

-- 9.Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID 
-- Return the employee_id, and their corresponding UNQ_ID;
SELECT EMPLOYEE_ID, concat_ws('_',FIRST_NAME,LAST_NAME,EMAIL) as UNQ_ID FROM employees;

-- 10.Write a SQL query to update the size of email column to 30
ALTER TABLE employees ALTER COLUMN email VARCHAR(40);
DESCRIBE TABLE employees;

-- 11.Write a SQL query to change the location of Diana to London
SELECT *,'London' as LOCATION FROM employees WHERE FIRST_NAME='Diana';

-- 12.Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
-- Info : this mean you need to separate phone into 2 parts 
-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
SELECT FIRST_NAME, EMAIL,
substr(PHONE_NUMBER,0,length(PHONE_NUMBER)-length(split_part(PHONE_NUMBER,'.',4))-1) as PHONE,
split_part(PHONE_NUMBER,'.',4) as EXTENSION FROM employees;

-- 13.Write a SQL query to find the employee with second and third maximum salary with and without using top/limit keyword
SELECT concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME,SALARY FROM employees
WHERE SALARY IN (SELECT DISTINCT SALARY FROM employees ORDER BY SALARY DESC OFFSET 1 ROWS FETCH NEXT 2);

SELECT concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME, SALARY FROM employees
WHERE SALARY IN (SELECT DISTINCT SALARY FROM employees ORDER BY SALARY DESC LIMIT 2 OFFSET 1); 

-- 14.Fetch all details of top 3 highly paid employees who are in department Shipping and IT
SELECT TOP 3 * FROM employees 
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM departments WHERE DEPARTMENT_NAME IN ('Shipping','IT'))
ORDER BY SALARY DESC;

-- 15.Display employee id and the positions(jobs) held by that employee (including the current position)
SELECT e.EMPLOYEE_ID, JOB_TITLE FROM EMPLOYEES e,JOBS j,JOB_HISTORY jh
WHERE e.EMPLOYEE_ID = jh.EMPLOYEE_ID AND jh.JOB_ID = j.JOB_ID;

-- 16.	Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg : 
-- Emp ID      Date Joined
-- 1	Monday, June 21st, 1999

SELECT FIRST_NAME, to_varchar(HIRE_DATE, concat(
decode(extract('dayofweek',HIRE_DATE),1,'Monday',2,'Tuesday',3,'Wednesday',4,'Thursday',5,'Friday',6,'Saturday',0,'Sunday'),
', MMMM dd, yyyy')) as JOIN_DATE FROM employees;

-- 17.The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes) . 
-- Later, update the maximum salary to 40,000. Save the entries as well.
-- Now, revert back the changes to the initial state, where the salary was 30,000
BEGIN TRANSACTION;
INSERT INTO jobs VALUES ('DT_ENGG','Data Engineer',12000,30000);
UPDATE jobs SET MAX_SALARY = 40000 WHERE JOB_ID='DT_ENGG';
SELECT * FROM jobs;
ROLLBACK;

-- 18.Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
SELECT round(avg(SALARY),3) as AVG_SALARY FROM employees WHERE HIRE_DATE BETWEEN '1996-01-08' AND '2000-01-01';

-- 19.Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
SELECT REGION_NAME FROM regions
UNION ALL SELECT ('Australia') as REGION_NAME
UNION ALL SELECT ('Asia') as REGION_NAME
UNION ALL SELECT ('Antarctica') as REGION_NAME
UNION ALL SELECT ('Europe') as REGION_NAME;
SELECT REGION_NAME FROM regions
UNION SELECT ('Australia') as REGION_NAME
UNION SELECT ('Asia') as REGION_NAME
UNION SELECT ('Antarctica') as REGION_NAME
UNION SELECT ('Europe') as REGION_NAME;

-- 20.Write a SQL query to remove the employees table from the database
DROP TABLE employees;


