-- Creating tables for PH-EmployeeDB
-- Use DROP TABLE statement to recreate a table or fix a mistake.
-- DROP TABLE Employees CASCADE; <-- tells Postgres tha we want to 
-- remove Employees table completely and CASCADE says we also want to
-- remove the connection to other tables in the database.

CREATE TABLE departments(
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE Employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name	VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL, 
	to_data DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL, 
	titles VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	PRIMARY KEY (emp_no, titles, from_date)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL, 
	dept_no VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

--SELECT * FROM departments;
SELECT * FROM dept_manager;
-- --QUERIES START HERE
-- Determine retirement eligibilty
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM Employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--CREATE a new table to export
SELECT first_name, last_name
INTO retirement_info
FROM Employees
WHERE (birth_date BETWEEN '1952-01-1' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check if the table got created.
SELECT * FROM retirement_info;

DROP TABLE retirement_info;
-- Create a new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM Employees
Where (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check data
SELECT * FROM retirement_info;

-- JOINING TABLES------
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retrement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name, 
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- ALIAS A TABLE FOR EASIER READ.
-- Joining retirement_info and dept_emp tables.
SELECT ri.emp_no, 
	ri.first_name,
	ri.last_name,
	de.to_date
-- LET SQL KNOW WHAT THE ALIASES STAND FOR
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- ALIAS Joining retirement_info and dept_emp tables.
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date,
FROM departments as d
LEFT JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Select the emplyees still working.
SELECT ri.emp_no, 
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
--Add the codes that will join the tables
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
-- Add filter for current employees
WHERE de.to_date = ('9999-01-01');
SELECT * FROM current_emp

----Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM current_emp

























