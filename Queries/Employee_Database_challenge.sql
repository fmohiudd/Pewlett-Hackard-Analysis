-- DELIVERABLE 1
-- 1. Retrieve the "emp_no", "first_name" and "last_name" from the Employees Table
SELECT e.emp_no, e.first_name, e.last_name,
       t.titles, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
-- Add filter on the date of birth between 1952 & 1955
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- COPIED THIS PORTION FROM THE Employee_Challange_Starter_code.sql
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, titles
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

select * From unique_titles

-- Retrieve the number of employees by most recent job title who are about 
-- to reitre. 
SELECT COUNT(unique_titles.titles) as counts, unique_titles.titles
INTO retiring_titles
FROM unique_titles
GROUP BY unique_titles.titles
ORDER BY counts DESC;
-----------------------------------------------
-- DELIVERABLE 2
-- CREATE a MENTORSHIP ELIGIBILITY TABLE for employees 
-- born from Jan 1, 1965 to Dec 31, 1965.

-- Select the first occurence of the employee number
SELECT DISTINCT ON(e.emp_no) e.emp_no, e.first_name,e.last_name, e.birth_date,
	t.from_date, t.to_date, t.titles
-- Save into a CSV file
INTO mentorship_eligibility
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
-- MAKE sure that the employee is still employed.
AND t.to_date = '9999-01-01'
ORDER BY emp_no;

-----------------------------------------------
-- EXTRA WORK
-- TO GET THE TOTAL COUNT OF UNIQUE EMPLOYEES CURRENTLY WORKING
-- IN THE COMPANY
SELECT COUNT(DISTINCT employees.emp_no)
FROM employees
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE titles.to_date = '9999-01-01';
