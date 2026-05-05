-- Giải pháp 1: Dùng nhiều toán tử OR

SELECT *
FROM Orders
WHERE reason = 'KHACH_HUY'
   OR reason = 'QUAN_DONG_CUA'
   OR reason = 'KHONG_CO_TAI_XE'
   OR reason = 'BOM_HANG';
-- Giải pháp 2: Dùng toán tử IN (...)

SELECT *
FROM Orders
WHERE reason IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');
-- Bảng so sánh hai cách viết

-- Tiêu chí	        	|OR liên tiếp	            									|IN (...)
-- Code sạch, dễ đọc	|Dài dòng, lặp lại nhiều lần									|Ngắn gọn, dễ nhìn, dễ hiểu
-- Khả năng mở rộng		|Nếu thêm 20 nguyên nhân → cực kỳ dài							|Chỉ cần thêm giá trị vào danh sách IN
-- Hiệu năng SQL Engine	|SQL Engine vẫn tối ưu được, nhưng phải parse nhiều điều kiện OR|SQL Engine tối ưu tốt hơn, đặc biệt khi danh sách dài

-- Câu truy vấn SQL tốt nhất (Giải pháp 2)

SELECT *
FROM Orders
WHERE reason IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');