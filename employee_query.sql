DROP TABLE IF EXISTS departments;
-- Create new table
CREATE TABLE departments(
  dept_no VARCHAR PRIMARY KEY,
  dept_name VARCHAR NOT NULL
);

-- Verify successful data import
SELECT * FROM departments;

-- Drop if exists
DROP TABLE IF EXISTS titles;

-- Create new table
CREATE TABLE titles (
  title_id VARCHAR PRIMARY KEY,
  title VARCHAR NOT NULL
);

-- Verify successful data import
SELECT * FROM titles;

-- Drop if exists
DROP TABLE IF EXISTS employees;

-- Create new table
CREATE TABLE employees (
  emp_no INT PRIMARY KEY,
  emp_title_id VARCHAR NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  sex VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- Verify successful data import
SELECT * FROM employees;

-- Drop if exists
DROP TABLE IF EXISTS dept_emp;

-- Create new table
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  PRIMARY KEY (emp_no,dept_no),
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Verify successful data import
SELECT * FROM dept_emp;

-- Drop if exists
DROP TABLE IF EXISTS dept_manager;

-- Create new table
CREATE TABLE dept_manager (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  PRIMARY KEY (emp_no,dept_no),
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Verify successful data import
SELECT * FROM dept_manager;

-- Drop if exists
DROP TABLE IF EXISTS salaries;

-- Create new table
CREATE TABLE salaries (
  emp_no INT PRIMARY KEY,
  salary INT NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Verify successful data import
SELECT * FROM salaries;

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex,salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE DATE_PART('year',hire_date) = 1986
ORDER BY emp_no;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
LEFT JOIN departments
ON dept_manager.dept_no = departments.dept_no
LEFT JOIN employees
ON dept_manager.emp_no = employees.emp_no
ORDER BY emp_no;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no, departments.dept_name 
FROM employees
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments ON departments.dept_no=dept_emp.dept_no
ORDER BY emp_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT employees.first_name, employees.last_name, employees.sex
From employees
WHERE first_name = 'Hercules' AND last_name like 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no
From employees
LEFT JOIN dept_emp
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no
From employees
LEFT JOIN dept_emp
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT employees.last_name, count(*) AS freq_count
FROM employees
GROUP BY last_name 
ORDER BY freq_count DESC;