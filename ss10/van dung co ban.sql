CREATE DATABASE test_db;
USE test_db;

CREATE TABLE Patients (
	Patient_ID INT PRIMARY KEY,
	Full_Name VARCHAR(100),
	Age INT,
	Room_Number INT,
	HIV_Status VARCHAR(50),
	Mental_Health_History VARCHAR(255)
);
-- Chèn một số dữ liệu
INSERT INTO Patients (Patient_ID, Full_Name, Age, Room_Number, HIV_Status, Mental_Health_History)
VALUES
	(1, 'Minh Thu', 30, 101, 'Negative', 'None'),
	(2, 'Hong Vân', 40, 102, 'Positive', 'Anxiety'),
	(3, 'Cao Cường', 25, 103, 'Negative', 'None');

CREATE OR REPLACE VIEW Reception_Patient_View AS
	SELECT Patient_ID, Full_Name, Age, Room_Number
    FROM Patients
    WHERE Age > 0 
    WITH CHECK OPTION;

-- Thực hiện truy vấn SELECT qua View để xác nhận các cột nhạy cảm đã bị ẩn.
SELECT * FROM Reception_Patient_View;

-- Thực hiện cập nhật tuổi hợp lệ (> 0) và không hợp lệ (< 0) để kiểm tra cơ chế bảo vệ của View.
-- Tuổi hợp lệ
UPDATE Reception_Patient_View 
SET Age = 35 
WHERE Patient_ID = 1;

-- Tuổi ko hợp lệ 
UPDATE Reception_Patient_View 
SET Age = -5 
WHERE Patient_ID = 1;