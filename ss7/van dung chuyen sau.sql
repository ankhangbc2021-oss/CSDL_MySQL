-- Cơ chế short-circuit của EXISTS:
-- Khi SQL kiểm tra điều kiện EXISTS (subquery), nó sẽ dừng ngay lập tức (short-circuit) nếu tìm thấy một dòng phù hợp trong subquery. Nó không cần duyệt hết toàn bộ bảng con.
-- -> Điều này cực kỳ quan trọng khi bảng Payments có hàng chục triệu bản ghi.

-- Ngược lại với NOT IN:
-- NOT IN phải lấy toàn bộ danh sách từ subquery trước, rồi so sánh từng giá trị.
-- Nếu danh sách có chứa NULL, logic còn dễ bị “sập bẫy” (trả về rỗng).
-- Với dữ liệu lớn (5 triệu học viên + hàng chục triệu giao dịch), việc gom toàn bộ danh sách trước khi lọc sẽ tốn bộ nhớ và CPU hơn nhiều.
-- -> Vì vậy, trong trường hợp này, bạn B đúng: NOT EXISTS vừa an toàn về logic, vừa hiệu quả hơn về hiệu năng.

SELECT s.email 
FROM Students s 
WHERE NOT EXISTS(
	SELECT 1 
    FROM Payments p
    WHERE p.student_id = s.id AND YEAR(p.patmet_date) = 2024
);