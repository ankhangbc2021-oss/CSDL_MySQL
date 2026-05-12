CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;

-- Chi nhánh miên Bắc
CREATE TABLE IF NOT EXISTS Records_North (
	Record_ID INT PRIMARY KEY,
	Patient_Name VARCHAR(100),
	Diagnosis TEXT,
	Record_Date DATE
);
-- Chi nhánh miên Nam
CREATE TABLE IF NOT EXISTS Records_South (
	Record_ID INT PRIMARY KEY,
	Patient_Name VARCHAR(100),
	Diagnosis TEXT,
	Record_Date DATE
);

-- Chèn dữ liệu mâu (Gồm cả trường hợp trùng ID đề kiêm thử)
INSERT INTO Records_North VALUES (1, 'Nguyen Van A', 'Flu', '2026-04-28');
INSERT INTO Records_South VALUES (1, 'Le Thi B', 'Cold', '2026-04-28' );

SELECT * FROM Records_North;
SELECT * FROM Records_South;

-- 2.Xây dựng View tổng hợp: Tạo View tên National_Record_View bằng cách sử dụng lệnh UNION ALL.

-- // Bảng tổng hợp 
CREATE OR REPLACE VIEW National_Record_View AS
	SELECT Record_ID, Patient_Name, Diagnosis, Record_Date, 'North' AS Branch_Name
	FROM Records_North
UNION ALL
	SELECT Record_ID, Patient_Name, Diagnosis, Record_Date, 'South' AS Branch_Name
	FROM Records_South;
 -- // 
SELECT * FROM National_Record_View;
-- 3.Định danh chi nhánh: Trong View, tự động tạo thêm một cột ảo mang tên Branch_Name 
-- với giá trị tương ứng là 'North' hoặc 'South' cho mỗi bản ghi.

-- 4.Xử lý xung đột: Kiểm tra trường hợp một bệnh nhân trùng mã ID ở cả hai chi 
-- nhánh. Phân tích cách View hiển thị dữ liệu này (Liệu có mất dữ liệu không?).

-- Vì dùng UNION ALL, cả hai bản ghi đều được giữ lại.
-- View sẽ hiển thị 2 dòng riêng biệt, mỗi dòng có Branch_Name khác nhau.
-- Không mất dữ liệu, nhưng cần lưu ý rằng ID không còn duy nhất trong toàn quốc, mà chỉ duy nhất trong từng chi nhánh.
