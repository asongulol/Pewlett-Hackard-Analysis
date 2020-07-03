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