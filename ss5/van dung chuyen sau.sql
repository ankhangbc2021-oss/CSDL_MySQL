-- 1. Thiết kế I/O & Luồng Backend
-- Đầu vào (Input):
-- Bảng Drivers với các cột:
-- driver_id (INT, AUTO_INCREMENT)
-- name (VARCHAR)
-- status (ENUM: 'AVAILABLE', 'LOCKED', 'BUSY')
-- trust_score (INT)
-- distance_km (DECIMAL hoặc FLOAT)
-- Tham số cấu hình: min_trust_score (ví dụ: 80, nhập từ Admin)
-- Đầu ra (Output):
-- Danh sách tài xế thỏa mãn điều kiện, sắp xếp theo:
-- distance_km tăng dần (gần nhất lên đầu)
-- Nếu bằng nhau, trust_score giảm dần (uy tín hơn lên trước)
-- Luồng xử lý Backend (pseudo-code):
-- plaintext
-- // Nhận tham số min_trust_score từ cấu hình
-- if min_trust_score < 0 then
--     min_trust_score = 0   // Chặn bẫy số âm, reset về giá trị tối thiểu hợp lệ
-- end if
-- // Sau đó gọi SQL để lọc dữ liệu
-- query = """
-- SELECT driver_id, name, status, trust_score, distance_km
-- FROM Drivers
-- WHERE status = 'AVAILABLE'
--   AND trust_score >= :min_trust_score
-- ORDER BY distance_km ASC, trust_score DESC;
-- """
-- 2. Triển khai SQL

CREATE DATABASE Driver;
USE Driver;

CREATE TABLE Drivers  (
	driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(155) NOT NULL,
    status ENUM('AVAILABLE', 'LOCKED', 'BUSY') NOT NULL,
    trust_score INT CHECK(trust_score >= 80) NOT NULL,
    distance_km DECIMAL (18,1) NOT NULL
);

INSERT INTO Drivers (name, status, trust_score, distance_km) VALUE 
	('Nguyễn Văn A', 'AVAILABLE', 90, 1.5),
    ('Nguyễn Văn C', 'AVAILABLE', 100, 1.5),
    ('Nguyễn Văn D', 'AVAILABLE', 80, 1.5),
    ('Nguyễn Văn B', 'BUSY', 81, 1.5);
    
SELECT driver_id, name, status, trust_score, distance_km
FROM Drivers
WHERE status = 'AVAILABLE'
AND trust_score >= :min_trust_score
ORDER BY distance_km ASC, trust_score DESC;
