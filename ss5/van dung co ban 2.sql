-- SELECT restaurant_name, created_at
-- FROM Restaurants
-- LIMIT 5;

-- nó chỉ lấy 5 dòng bất kì trong hàng thứ tự 
-- Nếu bảng không có ORDER BY, kết quả mỗi lần refresh có thể khác nhau, thậm chí lấy dữ liệu từ năm ngoái.
-- Đây chính là lý do danh sách hiển thị ngẫu nhiên, không phải “quán mới nhất”.

-- SỬA LẠI 
SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY created_at DESC LIMIT 5;
