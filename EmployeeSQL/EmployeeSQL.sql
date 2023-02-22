-- SQL CHALLENGE
-- Gustavo Mendes Pinto

----- DATA RESET -----

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;


----- DATA MODELING -----

-- TITLES
-- drop table if exists
DROP TABLE IF EXISTS titles;
-- create titles table
CREATE TABLE titles(
	title_id VARCHAR(5) NOT NULL,
	title VARCHAR(30) NOT NULL,
	PRIMARY KEY(title_id)
);
-- copying csv to sql
COPY titles
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\titles.csv'
DELIMITER ','
CSV HEADER;
-- show table
SELECT * FROM titles;


-- EMPLOYEES
-- drop table if exists
DROP TABLE IF EXISTS employees CASCADE;
-- create employees table
CREATE TABLE employees(
	emp_no INT NOT NULL,
	emp_title_id VARCHAR(5) REFERENCES titles(title_id) NOT NULL,
	birth_date VARCHAR(10) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date VARCHAR(10) NOT NULL,
	PRIMARY KEY (emp_no),
	UNIQUE (emp_no)
);
-- copying csv to sql
COPY employees
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\employees.csv'
DELIMITER ','
CSV HEADER;
-- changing date fields data type to DATE (LOAD CSV BEFORE ALTERING TABLE)
SET datestyle TO 'sql,mdy'
ALTER TABLE employees
	ALTER COLUMN birth_date TYPE DATE USING birth_date::date,
	ALTER COLUMN hire_date TYPE DATE USING hire_date::date;
-- show table
SELECT * FROM employees ORDER BY emp_no;


-- DEPARTMENTS
-- drop table if exists
DROP TABLE IF EXISTS departments CASCADE;
-- create departments table
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(30) NOT NULL,
	PRIMARY KEY (dept_no)
);
-- copying csv to sql
COPY departments
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\departments.csv'
DELIMITER ','
CSV HEADER;
-- show table
SELECT * FROM departments;


-- SALARIES
-- drop table if exists
DROP TABLE IF EXISTS salaries;
-- create salaries table
CREATE TABLE salaries(
	emp_no INT REFERENCES employees(emp_no) NOT NULL,
	salary INT NOT NULL,
	PRIMARY KEY (emp_no)
);
-- copying csv to sql
COPY salaries
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\salaries.csv'
DELIMITER ','
CSV HEADER;
-- show table
SELECT * FROM salaries;


-- DEPT-EMP
-- drop table if exists
DROP TABLE IF EXISTS dept_emp;
-- create dept_emp table
CREATE TABLE dept_emp(
	emp_no INT REFERENCES employees(emp_no) NOT NULL,
	dept_no VARCHAR(4) REFERENCES departments(dept_no) NOT NULL
);
-- copying csv to sql
COPY dept_emp
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\dept_emp.csv'
DELIMITER ','
CSV HEADER;
-- show table
SELECT * FROM dept_emp;


-- DEPT-MANAGER
-- drop table if exists
DROP TABLE IF EXISTS dept_manager;
-- create dept_manager table
CREATE TABLE dept_manager(
	dept_no VARCHAR(4) REFERENCES departments(dept_no) NOT NULL,
	emp_no INT REFERENCES employees(emp_no) NOT NULL
);
-- copying csv to sql
COPY dept_manager
FROM 'C:\Users\gusme\iCloudDrive\Documents\Data Analystics\UOfT - Data Analytics\Challenges\sql-challenge\EmployeeSQL\data\dept_manager.csv'
DELIMITER ','
CSV HEADER;
-- show table
SELECT * FROM dept_manager;


----- DATA ANALYSIS -----

-- 1. List the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s
ON (e.emp_no = s.emp_no)
ORDER BY s.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE e.hire_date >= '1986-01-01 00:00:00' 
AND  e.hire_date < '1987-01-01 00:00:00'
ORDER BY e.hire_date;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments d
JOIN dept_manager dm
ON (d.dept_no = dm.dept_no)
JOIN employees e
ON (e.emp_no = dm.emp_no)
ORDER BY d.dept_no;

-- 4.List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN employees e
ON (de.emp_no = e.emp_no)
JOIN departments d
ON (de.dept_no = d.dept_no)

-- 5.List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT e.first_name, e.last_name, e.sex
FROM employees e
WHERE e.first_name = 'Hercules'
AND e.last_name LIKE 'B%';

-- 6.List each employee in the Sales department, including their employee number, last name, and first name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de
ON (e.emp_no = de.emp_no)
JOIN departments d
ON (de.dept_no = d.dept_no)
WHERE d.dept_no = 'd007'
ORDER BY e.emp_no;

-- 7.List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de
ON (e.emp_no = de.emp_no)
JOIN departments d
ON (de.dept_no = d.dept_no)
WHERE d.dept_no = 'd007' OR d.dept_no = 'd005'
ORDER BY e.emp_no;

-- 8.List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT e.last_name, COUNT(e.last_name) AS "Count of Last Names"
FROM employees e
GROUP BY e.last_name
ORDER BY "Count of Last Names" DESC;