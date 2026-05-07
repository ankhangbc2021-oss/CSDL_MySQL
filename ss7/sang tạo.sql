-- Giải pháp kiến trúc: Scalar Subquery trong SELECT
-- Vấn đề: Nếu dùng GROUP BY hoặc AVG() trực tiếp, hệ thống sẽ gộp tất cả các khóa học thành một dòng duy nhất, mất đi chi tiết từng khóa học.
-- Giải pháp: Đặt một Scalar Subquery ngay trong mệnh đề SELECT.
-- Scalar Subquery là một truy vấn con trả về một giá trị duy nhất.
-- Khi đặt trong SELECT, nó sẽ được tính cho từng dòng của bảng chính.
-- Nhờ vậy, ta vừa giữ được chi tiết từng khóa học (title, price), vừa có thể tính toán độ lệch so với giá trung bình toàn bộ.
-- Nói cách khác: Scalar Subquery giúp ta "nhúng" thông tin tổng quan (giá trung bình toàn sàn) vào từng dòng chi tiết (mỗi khóa học). Đây chính là cách giải quyết song song chi tiết + tổng quan.
-- Câu lệnh SQL hoàn chỉnh

SELECT 
    title,
    price,
    price - (SELECT AVG(price) FROM Courses) AS Price_Difference
FROM Courses;