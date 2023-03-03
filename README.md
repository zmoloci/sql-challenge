# SQL Challenge
## Designing and Querying Pewlett Hackard's Employee Database using 1980s and 1990s CSV-format data

### Data Modeling

Using [QuickDBD](https://www.quickdatabasediagrams.com/), an Entity Relationship Diagram ([Fig.1 - Employee_ERD.png](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/Employee_ERD.png)) was developed. This diagram was built based on the available data from the [departments.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/departments.csv), [dept_emp.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/dept_emp.csv), [dept_manager.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/dept_manager.csv), [employees.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/employees.csv),  [salaries.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/salaries.csv) and [titles.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/titles.csv) CSV files provided.

| Pewlett Hackard's 1980s-1990s Employee Database ([Fig.1](https://github.com/zmoloci/python-api-challenge/blob/main/WeatherPy/output_data/Fig1.png)) |
| ----------- |
| ![Fig.1](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/Employee_ERD.png) |

---

### Data Engineering

Using the above ERD, a table schema was exported to pgAdmin4:
```
CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    -- Some employees missing dept_no
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
```


The data from the [departments.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/departments.csv), [dept_emp.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/dept_emp.csv), [dept_manager.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/dept_manager.csv), [employees.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/employees.csv),  [salaries.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/salaries.csv) and [titles.csv](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/data/titles.csv) were then loaded into the database using the above schema ([Table_schemas_from_QuickDBD.sql](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/Table_schemas_from_QuickDBD.sql)).

Note: it is necessary that these tables were created and populated in order based on the PRIMARY/FOREIGN KEY CONSTRAINTS dictated by the schema.
(i.e. employees must be imported before salaries as salaries requires the emp_no to be in place as employees' PRIMARY KEY, since it is a FOREIGN KEY of salaries)

The following order of imports successfully satisfied all constraints:
- titles
- employees
- salaries
- departments
- dept_manager
- dept_emp

---


### Data Analysis

The following Queries ([Data_analysis.sql](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/Data_Analysis.sql)) were performed on the database:

#### 1.  List the employee number, last name, first name, sex, and salary of each employee.

IN:
```
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
LEFT JOIN salaries s
ON e.emp_no = s.emp_no;
```
OUT (5 row sample):
| Query 1: ([Fig.Q1](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q1.png)) |
| ----------- |
| ![Fig.Q1](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q1.png) |


#### 2.  List the first name, last name, and hire date for the employees who were hired in 1986.


IN:
```
SELECT first_name, last_name, hire_date
FROM employees
WHERE emp_no IN
	(SELECT emp_no 
	 FROM employees
	 WHERE date_part('year', hire_date) = 1986
	);
```
OUT (5 row sample):
| Query 2: ([Fig.Q2](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q2.png)) |
| ----------- |
| ![Fig.Q2](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q2.png) |



#### 3.  List the manager of each department along with their department number, department name, employee number, last name, and first name.


IN:
```
SELECT d.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name
FROM departments d
LEFT JOIN dept_manager m
ON d.dept_no = m.dept_no
LEFT JOIN employees e
ON m.emp_no = e.emp_no;
```

OUT (5 row sample):
| Query 3: ([Fig.Q3](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q3.png)) |
| ----------- |
| ![Fig.Q3](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q3.png) |



#### 4.  List the department number for each employee along with that employee’s employee number, last name, first name, and department name.


IN:
```
SELECT d.dept_no, j.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments d
LEFT JOIN dept_emp j
ON d.dept_no = j.dept_no
LEFT JOIN employees e
ON j.emp_no = e.emp_no;
```

OUT (5 row sample):
| Query 4: ([Fig.Q4](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q4.png)) |
| ----------- |
| ![Fig.Q4](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q4.png) |



#### 5.  List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.


IN:
```
SELECT first_name, last_name, sex
FROM employees
WHERE emp_no 
IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Hercules' AND last_name LIKE 'B%');
```
OUT (5 row sample):
| Query 5: ([Fig.Q5](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q5.png)) |
| ----------- |
| ![Fig.Q5](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q5.png) |


#### 6.  List each employee in the Sales department, including their employee number, last name, and first name.

Option A: gives required data, without displaying dept_name or dept_no.
This is possible based on information gleaned from earlier queries. Specifically the dept_no for "Sales"

IN:
```
SELECT emp_no, last_name, first_name,
FROM employees
WHERE emp_no
IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no = 'd007');
```

OUT (5 row sample):
| Query 6A: ([Fig.Q6A](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q6A.png)) |
| ----------- |
| ![Fig.Q6A](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q6A.png) |


Option B: uses joins to help display the same data as above with the addition of the dept_no and dept_name being printed alongside each employee's  number, last name, and first name

IN:
```
SELECT j.emp_no, e.last_name, e.first_name, d.dept_name, d.dept_no
FROM departments d
LEFT JOIN dept_emp j
ON d.dept_no = j.dept_no
LEFT JOIN employees e
ON j.emp_no = e.emp_no
WHERE d.dept_no = 'd007';
```

OUT (5 row sample):
| Query 6B: ([Fig.Q6B](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q6B.png)) |
| ----------- |
| ![Fig.Q6B](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q6B.png) |


#### 7.  List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

IN:
```
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
```

OUT (5 row sample):
| Query 7: ([Fig.Q6A](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q7.png)) |
| ----------- |
| ![Fig.Q7](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q7.png) |


#### 8.  List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).


IN:
```
SELECT last_name, COUNT(last_name)  AS "employee last name count"
FROM employees
GROUP BY last_name
ORDER BY "employee last name count" DESC;
```


OUT (5 row sample):
| Query 8: ([Fig.Q6A](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q8.png)) |
| ----------- |
| ![Fig.Q8](https://github.com/zmoloci/sql-challenge/blob/main/EmployeeSQL/query_samples/Q8.png) |
