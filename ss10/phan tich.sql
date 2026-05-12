CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;

-- Thiết kế bảng: Tạo bảng Pharmacy_Inventory với các trường dữ liệu phù hợp (ID, Tên thuốc, Lô sản xuất, Hạn sử dụng, Số lượng).
CREATE TABLE IF NOT EXISTS Pharmacy_Inventory (
	Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
	Drug_Name VARCHAR(255),
	Batch_Number VARCHAR(50),
	Expiry_Date DATE,
	Quantity INT
);

INSERT INTO Pharmacy_Inventory(Drug_Name, Batch_Number, Expiry_Date, Quantity) 
VALUES
('Thuốc cảm', 'FAK', '2026-05-03', 12),
('Paracetamol', 'PAR', '2026-05-02', 12);

-- 2 Triển khai Index: So sánh hiệu năng giữa việc đánh 2 Index đơn độc lập 
-- và 1 Composite Index trên cả 2 cột (Drug_Name, Expiry_Date).

CREATE INDEX idx_drugname ON Pharmacy_Inventory(Drug_Name);
CREATE INDEX idx_expiry ON Pharmacy_Inventory(Expiry_Date);
-- Khi truy vấn có cả Drug_Name và Expiry_Date, 
-- MySQL có thể chỉ dùng một Index rồi lọc thêm, dẫn đến hiệu năng chưa tối ưu.

CREATE INDEX idx_drug_expiry ON Pharmacy_Inventory(Drug_Name, Expiry_Date);
SELECT * 
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol'
AND Expiry_Date < '2026-12-31';
-- MySQL sẽ dùng Composite Index để lọc trực tiếp, nhanh hơn nhiều so với việc kết hợp hai Index đơn lẻ.

-- 3  Phân tích kỹ thuật: * Sử dụng EXPLAIN để chứng minh hiệu quả của Composite Index.

-- Trước khi có Composite Index: EXPLAIN thường cho thấy Using where + Using index condition, nhưng vẫn phải quét nhiều dòng.
-- Sau khi có Composite Index: EXPLAIN sẽ hiển thị ref hoặc range trên idx_drug_expiry, số dòng quét giảm mạnh.

-- Giải thích hiện tượng Index bị "vô hiệu hóa" khi sử dụng LIKE '%keyword%'.

-- Khi dùng LIKE '%keyword%', Index 
-- bị vô hiệu hóa vì ký tự % ở đầu khiến MySQL không thể dự đoán vị trí bắt đầu trong Index.
-- -> nên dung LIKE '%keyword'

-- Đề xuất giải pháp khắc phục để tối ưu tìm kiếm theo tên (Ví dụ: Full-text 
-- Search hoặc tối ưu lại cấu trúc LIKE).
CREATE FULLTEXT INDEX ft_drugname ON Pharmacy_Inventory(Drug_Name);
SELECT * FROM Pharmacy_Inventory
WHERE MATCH(Drug_Name) AGAINST('Paracetamol');

--  Tìm kiếm nhanh hơn, hỗ trợ từ khóa gần đúng.
-- LIKE tối ưu: Nếu có thể, dùng LIKE 'Para%' thay vì %tamol, vì Index 
-- vẫn hoạt động khi ký tự % chỉ ở cuối.