-- Phân tích kiến trúc & Logic I/O
-- Đầu vào (Input): Bảng Bookings chứa các đơn đặt phòng với các cột như user_id, status, booking_id, ....
-- Đầu ra (Output): Danh sách user_id thỏa mãn đồng thời:
-- Có tổng số đơn ≥ 10 (bất kể trạng thái).
-- Có số đơn hủy > 5 (status = 'CANCELLED').
--  Vấn đề: Nếu ta chỉ dùng COUNT(*) thì sẽ đếm tất cả đơn. Nhưng để đếm riêng số đơn hủy, ta cần hàm tổng hợp kết hợp với điều kiện.
-- Giải pháp: Dùng SUM(CASE WHEN ... THEN 1 ELSE 0 END) hoặc COUNT(IF(...)) để đếm có điều kiện trong cùng một nhóm.

-- CÂU LỆNH 
SELECT 
    user_id,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_bookings
FROM Bookings
GROUP BY user_id
HAVING COUNT(*) >= 10
   AND SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) > 5;
