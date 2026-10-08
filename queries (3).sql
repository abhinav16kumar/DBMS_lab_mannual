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
CREATE TABLE Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Salary_Audit
(emp_id, old_salary, new_salary)
VALUES
(106, 55000, 60000),
(107, 50000, 55000),
(108, 60000, 65000),
(109, 48000, 52000),
(110, 55000, 58000);

SELECT *FROM salary_Audit;

DROP PROCEDURE IF EXISTS transfer_employee;
DELIMITER $$

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_old_dept_id INT;
    DECLARE v_employee_count INT;
    DECLARE v_department_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_employee_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    SELECT COUNT(*) INTO v_department_count
    FROM Department
    WHERE dept_id = p_new_dept_id;

    IF v_department_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    SELECT dept_id INTO v_old_dept_id
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_old_dept_id = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee is already in this department';
    END IF;

    UPDATE Employee
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;

    COMMIT;
END$$

DROP TRIGGER IF EXISTS validate_employee_salary$$
CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END$$

DROP TRIGGER IF EXISTS validate_salary_update$$
CREATE TRIGGER validate_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Updated salary must be greater than zero';
    END IF;
END$$

DROP TRIGGER IF EXISTS salary_audit$$
CREATE TRIGGER salary_audit
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO Salary_Audit (emp_id, old_salary, new_salary)
        VALUES (NEW.emp_id, OLD.salary, NEW.salary);
    END IF;
END$$

DELIMITER ;

CALL transfer_employee(106, 2);
SELECT * FROM Employee WHERE emp_id = 106;
SELECT * FROM Salary_Audit;

