-- SELECT title, price
-- FROM Courses
-- WHERE price = (SELECT price FROM Courses WHERE instructor_id = 5);

-- Phân tích
-- Lý do báo lỗi là = thì chỉ lấy dữ liệu duy nhất nhưng subquery thì lại lấy nhiều dữ liệu do id = 5 nhưng có 2 khóa học khác nên giá tiền có thể khác nhau nên báo lỗi "Subquery returns more than 1 row"

-- Sửa code: Viết lại câu lệnh SQL để vá lỗi, đảm bảo dù ông A có 1 hay 100 khóa học thì code vẫn chạy đúng

SELECT title, price
FROM Courses
WHERE price IN (SELECT price FROM Courses WHERE instructor_id = 5);