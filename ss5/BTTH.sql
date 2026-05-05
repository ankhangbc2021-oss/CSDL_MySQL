-- 1. Bản vẽ Logic (Mổ xẻ Bẫy)
-- Bẫy thường gặp: Nếu viết WHERE total_amount BETWEEN 2000000 AND 5000000 OR note LIKE '%gấp%', thì toán tử OR sẽ phá vỡ toàn bộ điều kiện lọc. Kết quả là hệ thống trả về cả đơn hàng có giá trị ngoài khoảng hoặc đã bị CANCELLED, chỉ vì có note chứa “gấp”.
-- Giải pháp: Dùng ngoặc tròn () để khóa chặt điều kiện kép. Toán tử OR phải được đặt trong một nhóm riêng, sau khi đã đảm bảo các điều kiện chính (BETWEEN, status <> 'CANCELLED').
-- 2. Quy trình chống bẫy đầu vào (Phân trang)
-- Công thức OFFSET:
-- OFFSET=(page−1)×page_size
-- Với Trang 3, mỗi trang 20 dòng:
-- OFFSET=(3−1)×20=40
-- Chặn lỗi Backend:
-- python
-- if page <= 0:
--     page = 1   # reset về trang 1 nếu client gửi 0 hoặc âm
-- offset = (page - 1) * page_size
-- 3. Mã nguồn Database 

-- Tạo Database
CREATE DATABASE IF NOT EXISTS SuperTool;
USE SuperTool;

-- Tạo bảng Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL,
    total_amount DECIMAL(15,2),
    status VARCHAR(50),
    note TEXT
);

-- Dữ liệu mẫu
INSERT INTO Orders (user_id, total_amount, status, note) VALUES
    (1, 2500000, 'PENDING', 'Khách yêu cầu gấp'),
    (2, 4800000, 'CONFIRMED', 'Đơn hàng bình thường'),
    (NULL, 3000000, 'PROCESSING', 'Đơn hệ thống tự sinh'),
    (3, 2000000, 'SHIPPED', 'Giao gấp trong ngày'),
    (4, 5500000, 'CONFIRMED', 'Đơn vượt ngưỡng test'),
    (5, 1000000, 'PENDING', 'Đơn nhỏ'),   
    (6, 4000000, 'CANCELLED', 'Khách hủy'),         
    (NULL, 4500000, 'PROCESSING', 'Đơn ảo, giá cao'),
    (7, 2200000, 'CONFIRMED', 'Không có ghi chú đặc biệt'),
    (8, 5000000, 'PENDING', 'Khách ghi chú: gấp gấp');

-- Truy vấn Siêu Công Cụ Soi Đơn
SELECT 
    order_id,
    user_id,
    total_amount,
    status,
    note,
    CASE 
        WHEN total_amount > 4000000 THEN 'Nguy hiểm'
        ELSE 'Bình thường'
    END AS Alert_Level
FROM Orders
WHERE total_amount BETWEEN 2000000 AND 5000000
  AND status <> 'CANCELLED'
  AND (note LIKE '%gấp%' OR user_id IS NULL)
ORDER BY total_amount DESC
LIMIT 20 OFFSET 40;   
-- Trang 3, mỗi trang 20 dòng