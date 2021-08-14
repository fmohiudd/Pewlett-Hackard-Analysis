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

--------------------------------------------------------------------
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

-- Practice the same code as above using ALIAS
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER Join dept_manager as dm
ON d.dept_no = dm.dept_no;
-- ---------------------------
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

-- ALIAS Joining retirement_info and dept_emp tables to
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date,
FROM departments as d
LEFT JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


--DROP current_emp so that we can run this code again. 
DROP TABLE current_emp;
-- Select the emplyees still working and add those names
-- into a new table, current_emp
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
-- ---------------------------------------
-- Use COUNT, GROUPBY, ASCENDING, DESCENDING
--Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO curr_emp_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- -------------------------------
-- Create Additional Lists
--Check the Salaries Table has to_date that aligns with employment date
SELECT * FROM salaries
ORDER BY to_data DESC;

-- List 1: Employee Information
-- First create a table emp_info to left join with salaries
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;

-- Create the employees list
SELECT e.emp_no, e.first_name, e.last_name, e.gender,
		s.salary, 
		de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');
-- EXPORT and save this table
-- -------------------------------------------
-- 2. CREATE Management list from Departments, Manager & Employees TABLE.
-- List of managers per department
SELECT dm.dept_no,
	   d.dept_name,
	   ce.last_name,
	   ce.first_name,
	   dm.from_date,
	   dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments as d
	ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp as ce
	ON(dm.emp_no = ce.emp_no);
-- -----------------------------------
-- 3. Department Retirees from Department, Dept_Emp and Employees
SELECT ce.emp_no, ce.first_name, ce.last_name,
	   d.dept_name
INTO dept_info 
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
	ON (de.dept_no = d.dept_no);
-- ------------------------------------------
-- CREATE A Tailored List on Sales from Department, demp_emp, Employees
-- SELECT ce.emp_no, ce.first_name, ce.last_name,
--	d.dept_name
-- INTO tailored_info
-- FROM current_emp AS ce
 -- WHERE departments AS d IN (d.dept_no);








































