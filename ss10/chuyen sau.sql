CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;

-- Bằng Khoa
CREATE TABLE IF NOT EXISTS Departments (
	Dept_ID INT PRIMARY KEY,
	Dept_Name VARCHAR(100)

);

-- Bằng Hóa đơn (Két nôi bệnh nhân và khoa)
CREATE TABLE IF NOT EXISTS Invoices (
	Invoice_ID INT PRIMARY KEY,
	Patient_ID INT,
	Dept_ID INT,
	Amount DECIMAL(10, 2)
);

-- Chèn dữ liệu mâu
INSERT INTO Departments VALUES 
	(1, 'Nội'), 
	(2, 'Ngoại');
INSERT INTO Invoices VALUES 
	(101, 1, 1, 500.00), 
	(102, 2, 1, 300.00), 
	(103, 3, 2, 1000.00);
    
SELECT * FROM Departments;
SELECT * FROM Invoices;

-- Tạo View báo cáo: Tạo View tên Department_Revenue_View 
-- hiển thị: Tên khoa, Tổng số bệnh nhân, Tổng doanh thu.
CREATE OR REPLACE VIEW Department_Revenue_View AS
	SELECT dep.Dept_Name, 
		COUNT(DISTINCT dep.Dept_ID) AS total_Patient_ID, 
		SUM(inv.Amount) AS toltal_Revene 
    FROM Departments dep 
    JOIN Invoices inv ON dep.Dept_ID = inv.Dept_ID
GROUP BY dep.Dept_Name;
 
 -- Xóa 
DROP VIEW Department_Revenue_View;

-- Kiểm thử tính toàn vẹn: * Thực hiện truy vấn SELECT để kiểm tra kết quả tính toán.
SELECT * FROM Department_Revenue_View;
-- Giả lập hành vi của kế toán: Dùng lệnh UPDATE để thay đổi doanh thu trực tiếp trên 
-- View và xác nhận hệ thống từ chối thao tác.

UPDATE Department_Revenue_View
SET toltal_Revene = 9999999
WHERE Dept_Name LIKE ('Nội');
-- -> MySQL sẽ báo lỗi: View chứa hàm gộp không thể 
-- cập nhật. Điều này đảm bảo tính minh bạch, kế toán không thể chỉnh sửa số liệu báo cáo.

