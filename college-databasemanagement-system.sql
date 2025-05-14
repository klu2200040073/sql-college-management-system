
-- 1. Create Database
CREATE DATABASE CollegeDB;
USE CollegeDB;

-- 2. Create Tables

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    dept_id INT,
    year INT,
    email VARCHAR(100),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 3. Insert Sample Data

-- Departments
INSERT INTO Departments VALUES
(101, 'Computer Science'),
(102, 'Electronics'),
(103, 'Mechanical');

-- Students
INSERT INTO Students VALUES
(1, 'Arjun Reddy', 'Male', 101, 2, 'arjun@college.edu'),
(2, 'Meera Das', 'Female', 102, 3, 'meera@college.edu'),
(3, 'Rahul Dev', 'Male', 101, 1, 'rahul@college.edu');

-- Courses
INSERT INTO Courses VALUES
(501, 'Data Structures', 4, 101),
(502, 'Digital Electronics', 3, 102),
(503, 'Thermodynamics', 4, 103),
(504, 'DBMS', 4, 101);

-- Enrollments
INSERT INTO Enrollments (student_id, course_id, semester, grade) VALUES
(1, 501, 'Sem-3', 'A'),
(1, 504, 'Sem-3', 'B'),
(2, 502, 'Sem-5', 'A'),
(3, 504, 'Sem-1', 'C');

-- 4. Queries to Demonstrate Skills

-- View all student details with department name
SELECT s.student_id, s.name, s.email, d.dept_name
FROM Students s
JOIN Departments d ON s.dept_id = d.dept_id;

-- Get course list along with department name
SELECT c.course_name, c.credits, d.dept_name
FROM Courses c
JOIN Departments d ON c.dept_id = d.dept_id;

-- Show students who scored 'A' grade
SELECT s.name, c.course_name, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade = 'A';

-- Count of students per department
SELECT d.dept_name, COUNT(*) AS student_count
FROM Students s
JOIN Departments d ON s.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Courses with average grades (assume A=4, B=3, C=2)
SELECT c.course_name,
       AVG(CASE grade
           WHEN 'A' THEN 4
           WHEN 'B' THEN 3
           WHEN 'C' THEN 2
           ELSE 0 END) AS average_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- 5. Create a View for Easy Report
CREATE VIEW StudentGrades AS
SELECT s.name AS student_name, c.course_name, e.semester, e.grade
FROM Enrollments e
JOIN Students s ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id;

-- 6. Stored Procedure: Get all students from a given department
DELIMITER //
CREATE PROCEDURE GetStudentsByDept(IN deptName VARCHAR(100))
BEGIN
    SELECT s.name, s.email
    FROM Students s
    JOIN Departments d ON s.dept_id = d.dept_id
    WHERE d.dept_name = deptName;
END //
DELIMITER ;

-- Call the procedure
-- CALL GetStudentsByDept('Computer Science');

-- 7. Function: Get Total Courses by Department
DELIMITER //
CREATE FUNCTION CountCourses(dept INT) RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Courses WHERE dept_id = dept;
    RETURN total;
END //
DELIMITER ;

-- Use the function
-- SELECT CountCourses(101) AS Total_Courses_CSE;

-- 8. Subquery: Find Students who are not enrolled in any course
SELECT name FROM Students
WHERE student_id NOT IN (SELECT student_id FROM Enrollments);

-- 9. Drop objects if needed
-- DROP VIEW StudentGrades;
-- DROP PROCEDURE GetStudentsByDept;
-- DROP FUNCTION CountCourses;

