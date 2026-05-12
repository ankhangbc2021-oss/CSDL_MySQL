CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;

-- 1: Thiết kế tầng dữ liệu
-- Bảng bệnh nhân
CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng dữ liệu sinh tồn
CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(20),
    Record_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES 
('BN001', 'Nguyen Van A'),
('BN002', 'Tran Thi B'),
('BN003', 'Le Van C');

INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure)
VALUES
('BN001', 80, '120/80'),
('BN002', 130, '140/90'), 
('BN003', 45, '110/70'); 


-- 2: Tối ưu hóa truy vấn
CREATE INDEX idx_patient_time ON Vitals_Logs(Patient_ID, Record_Time);

-- 3: Xây dựng Dashboard hiển thị
CREATE VIEW ER_Dashboard_View AS
SELECT p.Patient_ID,
       p.Full_Name,
       COALESCE(v.Heart_Rate, 'Pending') AS Heart_Rate,
       COALESCE(v.Blood_Pressure, 'Pending') AS Blood_Pressure,
       v.Record_Time,
       CASE 
           WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
           ELSE 'STABLE'
       END AS Urgency_Level
FROM Patients p
LEFT JOIN (
    SELECT vl.Patient_ID, vl.Heart_Rate, vl.Blood_Pressure, vl.Record_Time
    FROM Vitals_Logs vl
    INNER JOIN (
        SELECT Patient_ID, MAX(Record_Time) AS LatestTime
        FROM Vitals_Logs
        GROUP BY Patient_ID
    ) latest ON vl.Patient_ID = latest.Patient_ID AND vl.Record_Time = latest.LatestTime
) v ON p.Patient_ID = v.Patient_ID;

SELECT * FROM ER_Dashboard_View;
-- 4: Kiểm tra tính bảo mật 
UPDATE ER_Dashboard_View
SET Heart_Rate = 200
WHERE Patient_ID = 'BN001';
