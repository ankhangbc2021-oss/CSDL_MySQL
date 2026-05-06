-- Phân tích bẫy dữ liệu (NOT IN vs NULL)
-- Khi viết:

-- SELECT room_id, room_name
-- FROM Rooms
-- WHERE room_id NOT IN (SELECT room_id FROM Bookings);
-- Nếu trong bảng Bookings có một bản ghi với room_id = NULL, thì tập hợp NOT IN ( ... ) sẽ chứa giá trị NULL.

-- Theo logic toán học của SQL: bất kỳ phép so sánh với NULL → kết quả là UNKNOWN.

-- Do đó, toàn bộ điều kiện room_id NOT IN (...) trở thành UNKNOWN cho tất cả các dòng → trả về 0 kết quả.
--  Đây chính là “thảm họa NULL”.

--  Giải pháp an toàn
-- Có 2 cách khắc phục:

-- Lọc NULL trong Subquery

-- SELECT room_id, room_name
-- FROM Rooms
-- WHERE room_id NOT IN (
--     SELECT room_id 
--     FROM Bookings 
--     WHERE room_id IS NOT NULL
-- );
-- Dùng LEFT JOIN + IS NULL (khuyến khích, dễ đọc & an toàn)

-- SELECT r.room_id, r.room_name
-- FROM Rooms r
-- LEFT JOIN Bookings b ON r.room_id = b.room_id
-- WHERE b.room_id IS NULL;
--  Đánh giá
-- Cách 1 (NOT IN + lọc NULL): vẫn chạy được, nhưng dễ bị bỏ sót nếu quên điều kiện IS NOT NULL.

-- Cách 2 (LEFT JOIN + IS NULL): rõ ràng, trực quan, không bị ảnh hưởng bởi NULL, thường được coi là best practice trong nghiệp vụ chống “Dead Inventory”.

--  SQL hoàn chỉnh 
SELECT r.room_id, r.room_name
FROM Rooms r
LEFT JOIN Bookings b ON r.room_id = b.room_id
WHERE b.room_id IS NULL;