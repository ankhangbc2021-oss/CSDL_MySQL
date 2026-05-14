CREATE DATABASE IF NOT EXISTS StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE IF NOT EXISTS Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE IF NOT EXISTS Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE IF NOT EXISTS Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE IF NOT EXISTS Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','Programming Fundamentals',4),
('C00003','Accounting Principles',3),
('C00004','Business Management',3),
('C00005','Web Development',4);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00002','C00001',9.0),
('S00003','C00004',7.5),
('S00004','C00003',8.0),
('S00005','C00001',9.2),
('S00006','C00004',6.8),
('S00007','C00003',8.7),
('S00008','C00001',7.9),
('S00001','C00002',8.8),
('S00002','C00005',9.1),
('S00005','C00005',8.9),
('S00008','C00002',9.3);


-- Phần A 
-- Câu 1 
CREATE VIEW ViewStudentBasic AS 
SELECT s.StudentID, s.FullName, dep.DeptName 
FROM Student s 
JOIN Department dep ON s.DeptID = dep.DeptID;

SELECT * FROM ViewStudentBasic;
-- Câu 2 
CREATE INDEX idxFullName ON Student (FullName);

-- Câu 3 
DELIMITER // 

CREATE PROCEDURE GetStudentsIT ()
BEGIN
	SELECT s.StudentID, s.FullName, s.Gender, s.BirthDate, dep.DeptName 
    FROM Student s 
	JOIN Department dep ON s.DeptID = dep.DeptID
    WHERE s.DeptID LIKE 'IT';
END //

DELIMITER ; 
-- call 
CALL GetStudentsIT();
-- drop 
DROP PROCEDURE GetStudentsIT;

-- P4 
-- Câu 4 
-- a 
CREATE VIEW ViewStudentCountByDept  AS 
SELECT  dep.DeptName,COUNT(s.StudentID) AS TotalStudents 
FROM Department dep
LEFT JOIN Student s ON dep.DeptID = s.DeptID 
GROUP BY dep.DeptName;

SELECT *  FROM ViewStudentCountByDept;
-- b 
SELECT DeptName, TotalStudents
FROM ViewStudentCountByDept
ORDER BY TotalStudents DESC
LIMIT 1;

-- Câu 5 
-- a 
DELIMITER //

CREATE PROCEDURE GetTopScoreStudent(IN varCourseID VARCHAR(6))
BEGIN
    SELECT 
        s.StudentID,
        s.FullName,
        c.CourseName,
        e.Score
    FROM Student s
    JOIN Enrollment e ON s.StudentID = e.StudentID
    JOIN Course c ON e.CourseID = c.CourseID
    WHERE e.CourseID = varCourseID
    ORDER BY e.Score DESC
    LIMIT 1;
END //

DELIMITER ;

-- b 
CALL GetTopScoreStudent ('C00001');

-- drop 
DROP PROCEDURE GetTopScoreStudent;
-- Phần C 
-- Câu 6 

