CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO Department (dept_id, dept_name, location)
VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Operations', 'Lucknow');

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);
INSERT INTO Employee
(emp_id, emp_name, salary, manager_id, dept_id)
VALUES
(101, 'Amit', 90000, NULL, 1),
(102, 'Neha', 85000, NULL, 2),
(103, 'Rahul', 95000, NULL, 3),
(104, 'Priya', 80000, NULL, 4),
(105, 'Vikas', 88000, NULL, 5);

INSERT INTO Employee
(emp_id, emp_name, salary, manager_id, dept_id)
VALUES
(106, 'Arjun', 60000, 101, 1),
(107, 'Riya', 55000, 101, 1),
(108, 'Karan', 65000, 101, 1),

(109, 'Simran', 52000, 102, 2),
(110, 'Pooja', 58000, 102, 2),
(111, 'Ankit', 50000, 102, 2),

(112, 'Rohit', 70000, 103, 3),
(113, 'Sneha', 62000, 103, 3),
(114, 'Manish', 58000, 103, 3),

(115, 'Kavya', 54000, 104, 4),
(116, 'Nitin', 59000, 104, 4),
(117, 'Shreya', 61000, 104, 4),

(118, 'Deepak', 57000, 105, 5),
(119, 'Anjali', 53000, 105, 5),
(120, 'Mohit', 60000, 105, 5),

(121, 'Varun', 48000, 106, 1),
(122, 'Isha', 47000, 107, 1),

(123, 'Aman', 49000, 109, 2),
(124, 'Tanya', 46000, 110, 2),

(125, 'Raj', 51000, 112, 3),
(126, 'Nisha', 50000, 113, 3),

(127, 'Yash', 45000, 115, 4),
(128, 'Meera', 47000, 116, 4),

(129, 'Sahil', 49000, 118, 5),
(130, 'Pallavi', 48000, 119, 5);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Project
(project_id, project_name, dept_id)
VALUES
(201, 'Website Development', 1),
(202, 'Cloud Migration', 1),
(203, 'Recruitment System', 2),
(204, 'Payroll Management', 2),
(205, 'Financial Analysis', 3),
(206, 'Digital Marketing', 4),
(207, 'Supply Chain System', 5),
(208, 'Inventory Management', 5);


CREATE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM Department d
LEFT JOIN Employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT *
FROM Department_Salary_Summary;

CREATE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.salary,
    e.manager_id,
    m.emp_name AS manager_name
FROM Employee e
LEFT JOIN Employee m
ON e.manager_id = m.emp_id;

SELECT *
FROM Employee_Hierarchy;
CREATE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;

UPDATE Employee_Basic
SET salary = 60000
WHERE emp_id = 101;

SELECT *
FROM Employee
WHERE emp_id = 101;

WITH RECURSIVE EmployeeChain AS
(
    
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1
    FROM Employee e
    INNER JOIN EmployeeChain ec
        ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM EmployeeChain
ORDER BY level, emp_id;



WITH RECURSIVE EmployeeChain AS
(
 
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1
    FROM Employee e
    INNER JOIN EmployeeChain ec
        ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    CONCAT(REPEAT('    ', level), emp_name) AS employee_hierarchy,
    manager_id,
    level
FROM EmployeeChain
ORDER BY level, emp_id;
