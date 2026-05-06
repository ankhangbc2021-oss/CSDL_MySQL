-- Phân tích đa giải pháp (WHERE vs HAVING)
-- Hướng tiếp cận 1 – Lọc Trễ (Bad Practice):
-- Gom nhóm tất cả đơn hàng của khách sạn, kể cả đơn hủy/lỗi.
-- Sau đó dùng HAVING để lọc theo điều kiện số lượng đơn thành công và doanh thu trung bình.
-- Nhược điểm: Database phải gom nhóm hàng triệu bản ghi không cần thiết rồi mới loại bỏ, gây tốn RAM và CPU.
-- Hướng tiếp cận 2 – Lọc Sớm (Clean Code):
-- Dùng WHERE status = 'COMPLETED' để loại bỏ đơn hủy/lỗi ngay từ đầu.
-- Sau đó mới GROUP BY hotel_id và dùng HAVING để kiểm tra số lượng và doanh thu trung bình.
-- Ưu điểm: Chỉ xử lý dữ liệu cần thiết, giảm khối lượng tính toán, tối ưu hiệu năng.

--  Bảng so sánh Trade-off
-- Tiêu chí	Hướng 		|1 (HAVING toàn bộ)			|Hướng 2 (WHERE trước)
-- Dữ liệu gom nhóm		|Tất cả đơn (cả hủy/lỗi)	|Chỉ đơn thành công
-- Bộ nhớ RAM			|Cao (gom nhóm dư thừa)		|Thấp hơn
-- CPU	Nặng 			|(tính toán vô ích)			|Nhẹ hơn
-- Tính rõ ràng			|Khó đọc, dễ nhầm lẫn		|Clean code, dễ hiểu
-- Thực tiễn triển khai	|Không khuyến khích			|Khuyến khích

-- Kết luận: Cách 2 là tối ưu nhất vì giảm tải cho hệ thống và dễ bảo trì.


-- Thực thi 
SELECT 
    hotel_id,
    COUNT(*) AS completed_orders,
    AVG(total_price) AS avg_revenue
FROM Bookings
WHERE status = 'COMPLETED'
GROUP BY hotel_id
HAVING COUNT(*) >= 50
   AND AVG(total_price) > 3000000;
