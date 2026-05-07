-- SELECT SUM(total_spent)
-- FROM (
-- 	SELECT student_id, SUM(amount) as total_spent
-- 	FROM Payments
-- 	GROUP BY student_id
-- 	HAVING SUM(amount) > 10000000
-- );

-- Kiến trúc dữ liệu: "Derived Table" (Bảng dẫn xuất) là gì?

-- Derived Table là 1 bảng tạm thời từ 1 subquery đặt trong mệnh đề FROM 
-- Nó hoạt động giống như một bảng ảo: kết quả của subquery sẽ được coi như một bảng để tiếp tục truy vấn bên ngoài.

-- Tại sao chuẩn SQL lại bắt buộc phải thực hiện yêu cầu gắt gao này ở mệnh đề FROM?

-- Chuẩn SQL yêu cầu mọi derived table phải có tên (alias) để hệ quản trị biết cách tham chiếu đến nó.
-- Nếu không đặt alias, hệ thống không thể gọi các cột của bảng tạm đó trong phần SELECT hoặc các mệnh đề khác.
-- Vì vậy MySQL báo lỗi: Every derived table must have its own alias

-- Sửa code 
SELECT SUM(total_spent)
FROM (
	SELECT student_id, SUM(amount) as total_spent
	FROM Payments
	GROUP BY student_id
	HAVING SUM(amount) > 10000000
) AS vip_student;