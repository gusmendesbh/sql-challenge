SCHEMA

DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS E dept_emp;
DROP TABLE IF EXISTS dept_manager;

-- create titles table
CREATE TABLE titles(
	title_id VARCHAR(5) NOT NULL,
	title VARCHAR(30) NOT NULL,
	PRIMARY KEY(title_id)
);

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
-- changing date fields data type (LOAD CSV BEFORE ALTERING TABLE)
ALTER TABLE employees
	ALTER COLUMN birth_date TYPE DATE USING birth_date::date,
	ALTER COLUMN hire_date TYPE DATE USING hire_date::date;

-- create departments table
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(30) NOT NULL,
	PRIMARY KEY (dept_no)
);

-- create salaries table
CREATE TABLE salaries(
	emp_no INT REFERENCES employees(emp_no) NOT NULL,
	salary INT NOT NULL,
	PRIMARY KEY (emp_no)
);

-- create dept_emp table
CREATE TABLE dept_emp(
	emp_no INT REFERENCES employees(emp_no) NOT NULL,
	dept_no VARCHAR(4) REFERENCES departments(dept_no) NOT NULL
);

-- create dept_manager table
CREATE TABLE dept_manager(
	dept_no VARCHAR(4) REFERENCES departments(dept_no) NOT NULL,
	emp_no INT REFERENCES employees(emp_no) NOT NULL
);
