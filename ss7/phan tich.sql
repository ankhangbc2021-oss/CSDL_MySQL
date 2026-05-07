-- SELECT * FROM Courses
-- WHERE id NOT IN (SELECT course_id FROM Enrollments);

-- Khám nghiệm tử thi (Logic Boolean)
-- Khi bạn viết:

-- WHERE id NOT IN (1, 2, NULL)
-- thì về mặt logic nó tương đương:

-- id != 1 AND id != 2 AND id != NULL
-- Trong SQL, mọi phép so sánh với NULL đều trả về UNKNOWN (không phải TRUE/FALSE).

-- Do đó, biểu thức cuối cùng trở thành:
-- TRUE AND TRUE AND UNKNOWN = UNKNOWN

-- Kết quả UNKNOWN bị SQL coi là không thỏa điều kiện → toàn bộ truy vấn ngoài trả về rỗng.
-- Đây chính là “bẫy logic” của NOT IN khi danh sách có chứa NULL.

--  Giải pháp kiến trúc
-- Để tránh sập do dữ liệu rác NULL, bạn cần lọc bỏ NULL ngay trong subquery bằng mệnh đề:

-- WHERE course_id IS NOT NULL
-- Như vậy, danh sách trả về sẽ không bao giờ chứa NULL, và NOT IN sẽ hoạt động đúng.

-- Thực thi: Câu lệnh SQL chống lỗi
-- Cách 1: Vá trực tiếp với NOT IN
-- SELECT *
-- FROM Courses c
-- WHERE c.id NOT IN (
--     SELECT course_id
--     FROM Enrollments
--     WHERE course_id IS NOT NULL
-- );
-- Cách 2: Dùng NOT EXISTS (an toàn tuyệt đối)
SELECT *
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.id
);