
--1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
LEFT JOIN salaries s
ON e.emp_no = s.emp_no;


--2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE emp_no IN
	(SELECT emp_no 
	 FROM employees
	 WHERE date_part('year', hire_date) = 1986
	);

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT d.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name
FROM departments d
LEFT JOIN dept_manager m
ON d.dept_no = m.dept_no
LEFT JOIN employees e
ON m.emp_no = e.emp_no;

--4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT d.dept_no, j.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments d
LEFT JOIN dept_emp j
ON d.dept_no = j.dept_no
LEFT JOIN employees e
ON j.emp_no = e.emp_no;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE emp_no 
IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Hercules' AND last_name LIKE 'B%');
	
--6. List each employee in the Sales department (d007), including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no
IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no = 'd007');


--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments d
LEFT JOIN dept_emp j
ON d.dept_no = j.dept_no
LEFT JOIN employees e
ON j.emp_no = e.emp_no
WHERE j.dept_no
IN (
	SELECT j.dept_no
	FROM dept_emp j
	WHERE dept_no = 'd007' OR dept_no = 'd005');

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name)  AS "employee last name count"
FROM employees
GROUP BY last_name
ORDER BY "employee last name count" DESC;
