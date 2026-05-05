-- 1. Giải pháp kiến trúc
-- Công cụ SQL phù hợp nhất để rẽ nhánh logic ngay trong SELECT là CASE WHEN … THEN … ELSE … END.
-- Nó cho phép tạo ra một cột ảo (alias) ngay trong quá trình truy vấn, không cần thay đổi cấu trúc bảng.
-- 2. Xử lý ngoại lệ (NULL)
-- Nếu total_orders = NULL, thì các điều kiện so sánh (>=, <) sẽ không đúng → rơi vào nhánh ELSE.
-- Để tránh gán nhãn sai, ta cần bắt riêng trường hợp NULL bằng một điều kiện WHEN total_orders IS NULL THEN 'Chưa có đơn'.
-- Như vậy, khách hàng mới đăng ký sẽ được phân loại đúng, không gây lỗi báo cáo.
-- 3. Code SQL hoàn chỉnh

SELECT 
    name AS Ten_Khach_Hang,
    CASE 
        WHEN total_orders IS NULL THEN 'Chưa có đơn'
        WHEN total_orders > 500 THEN 'Kim Cương'
        WHEN total_orders >= 100 THEN 'Vàng'
        ELSE 'Bạc'
    END AS Xep_Hang
FROM Users;
-- 4. Giải thích logic
-- CASE kiểm tra lần lượt từ trên xuống dưới.
-- Nếu total_orders IS NULL → gán 'Chưa có đơn'.
-- Nếu > 500 → 'Kim Cương'.
-- Nếu từ 100 đến 500 → 'Vàng'.
-- Nếu < 100 → 'Bạc'.
