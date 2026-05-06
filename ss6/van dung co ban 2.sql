-- SELECT hotel_id, room_name, MIN(price_per_night)
-- FROM Rooms
-- GROUP BY hotel_id;

-- Do room_name ko nằm trong GROUP BY nên không hợp lệ: nó kcũng không được tổng hợp.
-- Về mặt toán học thì 1 id có thể có nhiều tên nên nó ko biết hiển thị tên gì

-- Sửa code 

SELECT hotel_id, MIN(price_per_night)
FROM Rooms
GROUP BY hotel_id;