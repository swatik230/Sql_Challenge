-- This script perfoms the following tasks:

-- -- 1. Drop the table if it exists
-- -- 2. Create the table and its columns and primary key
-- -- 3. Create the foreign key (FK) if necessary
-- -- 4. Drop the column if FK is compose and the column it is not necessary


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Table employees:

-- Remove table if it exists
DROP TABLE IF EXISTS employees CASCADE;

-- Create the table employees
CREATE TABLE employees(
	emp_no INT NOT NULL,
	emp_title_id VARCHAR(5) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY(emp_no, emp_title_id)
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Table departments:

-- Remove table if it exists
DROP TABLE IF EXISTS departments CASCADE;

-- Create the table departments
CREATE TABLE departments(
	dept_no VARCHAR(5) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(50) NOT NULL
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Table dept_emp:



	CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(5) NOT NULL REFERENCES departments(dept_no),
	emp_title_id VARCHAR(5) NOT NULL,
	FOREIGN KEY (emp_no, emp_title_id) REFERENCES employees(emp_no, emp_title_id),
	PRIMARY KEY(emp_no, dept_no));
	
ALTER TABLE dept_emp DROP column emp_title_id;	


-- create Table dept_manager:

CREATE TABLE dept_manager (
	dept_no VARCHAR(5) NOT NULL REFERENCES departments(dept_no),
	emp_no INT NOT NULL,
	emp_title_id VARCHAR(5) NOT NULL,
	FOREIGN KEY (emp_no, emp_title_id) REFERENCES employees(emp_no, emp_title_id),
	PRIMARY KEY(dept_no, emp_no)
);

-- Drop the Composed Primary Key to only allow the correct number of columns
ALTER TABLE dept_manager DROP column emp_title_id;

-- create Table salaries:

CREATE TABLE salaries(
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR(5) NOT NULL,
	FOREIGN KEY (emp_no, emp_title_id) REFERENCES employees(emp_no, emp_title_id),
	salary INT
);

ALTER TABLE salaries DROP column emp_title_id;


DROP TABLE IF EXISTS titles;

-- Create the table titles
CREATE TABLE titles(
	emp_title_id VARCHAR(5) NOT NULL,
	title VARCHAR(30) NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no,emp_title_id) REFERENCES employees(emp_no,emp_title_id),
	PRIMARY KEY (emp_title_id, title)
);

-- Drop the Composed Primary Key to only allow the correct number of columns
ALTER TABLE titles DROP column emp_no;

--- Create View for Employee _hire _date  who hired in 1986

create view employee_hire_date as (
select e.emp_no,e.last_name,e.first_name,e.sex,e.hire_date from employees e where e.hire_date between '1986-01-01'
and '1986-12-31' order by e.hire_date desc
)

--- Create View for employees first name starting with Hercules & lastname with B

create view lastnameB as(
SELECT * FROM employees
WHERE first_name = 'Hercules' AND last_name like 'B%');

-----Create View for emp_sales . employees in sales depatment

create view emp_Sales as (
SELECT 
employees.emp_no, 
employees.last_name, 
employees.first_name,
dept_emp.dept_no,
departments.dept_name
FROM employees 
LEFT JOIN dept_emp 
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales');


-----Create view for employees in sales & Development Environments

create view emp_sales_dev as(
SELECT 
employees.emp_no, 
employees.last_name, 
employees.first_name,
dept_emp.dept_no,
departments.dept_name
FROM employees 
LEFT JOIN dept_emp 
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development'))