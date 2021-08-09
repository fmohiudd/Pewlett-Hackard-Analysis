Departments
-
dept_no varchar pk fk - Dept_Emp.dept_no
dept_name varchar

Dept_Emp
-
emp_no int pk fk -< Employees.emp_no
dept_no int pk fk
hire_date date
date_end date

Employees
-
emp_no int pk
birth_date date
first_name varchar
last_name varchar
gender varchar
hire_date date

Manager
-
dept_no varchar pk fk - Departments.dept_no
emp_no int pk fk - Employees.emp_no
hire_date date
date_end date

Salaries
-
emp_no int pk fk -< Employees.emp_no
salary int
hire_date date
date_end date

Titles
-
emp_no int pk fk -< Employees.emp_no 
titles varchar pk
date_start date pk
date_end date 