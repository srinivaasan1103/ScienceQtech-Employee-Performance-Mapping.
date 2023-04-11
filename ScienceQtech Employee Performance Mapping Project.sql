CREATE DATABASE employee;

USE employee;

-- Checking all the tables after importing data
SELECT * FROM emp_record_table;

SELECT * FROM proj_table;

SELECT * FROM data_science_team;

-- 3) query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table
ORDER BY DEPT ASC;

-- 4) query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING
-- less than 2
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

-- Between 2 and 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

-- Above 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING >4;

-- 5) query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

SELECT CONCAT(FIRST_NAME, " ", LAST_NAME) AS 'Name', DEPT
FROM emp_record_table
WHERE DEPT = 'FINANCE';

-- 6) query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

SELECT w.MANAGER_ID,
       count(*)
FROM emp_record_table w,
     emp_record_table m
WHERE w.MANAGER_ID = m.EMP_ID
GROUP BY w.MANAGER_ID
ORDER BY w.MANAGER_ID ASC;

-- 7) Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

 SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
 FROM emp_record_table
 WHERE DEPT = "FINANCE"
 
 UNION
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
 FROM emp_record_table
 WHERE DEPT = "HEALTHCARE"
 
 GROUP BY EMP_ID, FIRST_NAME, LAST_NAME, DEPT;
 
 -- 8) query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
 -- Also include the respective employee rating along with the max emp rating for the department.
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
 FROM emp_record_table
 ORDER BY DEPT, EMP_RATING DESC;
 
 -- 9) query to calculate the minimum and the maximum salary of the employees in each role.
 
 SELECT ROLE, MIN(SALARY) AS min_sal, MAX(SALARY) AS max_sal
 FROM emp_record_table
 GROUP BY ROLE;
 
 -- 10) query to assign ranks to each employee based on their experience

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP,
ROW_NUMBER() OVER (ORDER BY EXP DESC) AS Ranking 
FROM emp_record_table;

-- 11) query to create a view that displays employees in various countries whose salary is more than six thousand

CREATE VIEW display_emp_sal AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

SELECT * FROM display_emp_sal ORDER BY COUNTRY, SALARY DESC;

-- 12) nested query to find employees with experience of more than ten years

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM emp_record_table
WHERE EXP IN (SELECT EXP
FROM emp_record_table
WHERE EXP > 10)
ORDER BY EXP DESC;     

-- 13) query to create a stored procedure to retrieve the details of the employees whose experience is more than three years

DELIMITER &&
CREATE PROCEDURE get_exp()
BEGIN
SELECT * FROM emp_record_table
WHERE EXP > 3;
END &&
CALL get_exp()
 
-- 14) query using stored functions in the project table to check whether the job profile assigned to each employee
-- in the data science team matches the organization’s set standard

DELIMITER $$

CREATE FUNCTION emp_profile(
	EXP INT
) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE emp_profile VARCHAR(50);

    IF EXP <= 2 THEN
		SET emp_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF (EXP BETWEEN 2 AND 5) THEN
        SET emp_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF (EXP BETWEEN 5 AND 10) THEN
        SET emp_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF (EXP BETWEEN 10 AND 12) THEN
        SET emp_profile = 'LEAD DATA SCIENTIST';
	ELSEIF (EXP BETWEEN 12 AND 16) THEN
        SET emp_profile = 'MANAGER';
    END IF;
	
	RETURN (emp_profile);
END$$
DELIMITER ;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, emp_profile(EXP)
FROM emp_record_table;
 
 -- 15) index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan

CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME(225));
EXPLAIN SELECT EMP_ID, FIRST_NAME, LAST_NAME
FROM emp_record_table
WHERE FIRST_NAME = "Eric";

-- 16) query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating)

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP, SALARY, EMP_RATING, (0.05 * SALARY) * EMP_RATING AS Bonus
FROM emp_record_table;
 
 -- 17) query to calculate the average salary distribution based on the continent and country.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, CONTINENT, AVG(SALARY)
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY,EMP_ID, FIRST_NAME, LAST_NAME;
