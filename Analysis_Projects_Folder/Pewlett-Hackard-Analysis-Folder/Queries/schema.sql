-- Creating tables for PH-EmployeeDB
-- Syntax goes like , CREATE TABLE "name_of_the_table" (
CREATE TABLE departments (
-- column_name type of data(length of data) NOT NULL,
	 dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
-- define what is the primary key inside parentheses
     PRIMARY KEY (dept_no),
-- UNIQUE keyword eliminates all duplicate records
     UNIQUE (dept_name)
-- ); signals that the statement is complete
);
-- Highlight the code you want to run otherwise Postgres will run all the code again and give you an error
CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
-- join two fields as primary key for example (emp_no, dept_no)
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
-- FOLLOW THE LIST OF COLUMNS AS FOUND IN THE CSV FILE TO BE IMPORTED, IT MAKES A DIFFERENCE!!!!
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
-- WHEN IMPORTING MAKE SURE TO IMPORT IN THE CORRECT ORDER TO PREVENT ERRORS WHERE A KEY DOES NOT YET EXIST
-- DROP TABLE "TABLE_NAME" CASCADE; CASCADE ALSO DELETES CONNECTIONS TO OTHER TABLES
-- Any table that does not reference a foreign key can be dropped without the CASCADE constrain
SELECT * FROM dept_emp;

-- FIND OUT RETIRABLE EMPLOYEES 
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- FIND OUT COUNT OF RETIRABLE EMPLOYEES 
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- USING "INTO" COMMAND TO CREATE A NEW TABLE
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SEE WHAT THE NEW TABLE LOOKS LIKE

SELECT * FROM retirement_info;

SELECT first_name, last_name, title
FROM employees AS e

-- RECREATE retirement_info to include emp_no column

DROP TABLE retirement_info;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name, dept_no
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no
ORDER BY dept_no;

-- CHECK retirement_info

SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- inner join of departments and dept_manager tables
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Left Join for retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- COUNT number still employed
SELECT COUNT(first_name)
FROM current_emp;

-- CHECK ALL NAMES OF CURRENT EMPLOYEES
SELECT first_name, last_name
FROM current_emp;

-- ORGANIZING USING GROUP BY

-- Employee count by department number (group by department)
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- using ORDER BY to sort Employee count by department number (group by department)
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_emp_count --save into another table for export
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--List # 1: Employee list
-- JOIN THREE TABLES:
-- 1) employees, 2) salaries and 3) dept_emp table
-- use INNER JOIN to show strict matching between three tables
-- use WHERE to filter retirable ages and hire dates
-- use WHERE to filter currently employed 
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s --each join should have a join and on statements
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

--List # 2: Management list
-- JOIN THREE TABLES: 
-- 1) managers -> dept_no, emp_no, from_date, to_date 
-- 2) departments -> dept_no, dept_name
-- 3) employees -> last_name, first_name
-- use INNER JOIN to show strict matching between three tables
-- use WHERE to filter retirable ages and hire dates
-- use WHERE to filter currently employed
-- use WHERE to filter currently manager

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
--TABLE 3:
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--RETIREMENT INFO FOR SALES AND DEVELOPMENT TEAM ONLY
-- ADD department to retirement_info table
SELECT ri.emp_no,
	ri.last_name,
	ri.first_name,
	de.dept_no
INTO s_and_d_retirees
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
--WHERE (de.dept_no = *) OR (de.dept_no = 'd007')
ORDER BY ri.last_name;

--ADD DEPARTMENT NAMES
SELECT sd.emp_no,
	sd.last_name,
	sd.first_name,
	d.dept_name
FROM s_and_d_retirees AS sd
INNER JOIN departments AS d
ON (sd.dept_no = d.dept_no)
WHERE sd.dept_no IN ('d007', 'd005') --USE IN OPERATOR TO CHOOSE FROM A LIST
ORDER BY sd.last_name;

--##CHALLENGE##

