-- Phần A: Phân tích & Đề xuất đa giải pháp
-- 1. Định nghĩa I/O (tham số):

-- IN p_patient_id INT (Mã bệnh nhân, có thể NULL)
-- IN p_phone VARCHAR(15) (Số điện thoại, có thể NULL)
-- OUT p_total_due DECIMAL(18,2) (Tổng nợ)
-- OUT p_message VARCHAR(100) (Thông báo trạng thái)
-- 2. Đề xuất 2 giải pháp logic:

-- Giải pháp 1: Rẽ nhánh IF...ELSE
-- Nếu cả ID và Phone đều NULL → báo lỗi.
-- Nếu có ID → tra cứu theo ID.
-- Nếu không có ID nhưng có Phone → tra cứu theo Phone.
-- Nếu không tìm thấy → trả về nợ = 0, thông báo "Không tìm thấy".

-- Giải pháp 2: Truy vấn linh hoạt với OR
-- Dùng một câu SELECT với điều kiện (patient_id = p_patient_id OR phone = p_phone).
-- Nếu cả hai đều NULL → chặn ngay.
-- Nếu không tìm thấy → trả về nợ = 0, thông báo "Không tìm thấy".

-- 3. So sánh & Lựa chọn:

-- Tiêu chí		|Giải pháp 1 (IF...ELSE)						|Giải pháp 2 (OR linh hoạt)
-- Ưu điểm		|Rõ ràng, dễ đọc, dễ kiểm soát từng trường hợp	|Ngắn gọn, ít dòng lệnh hơn
-- Nhược điểm	|Code dài hơn, nhiều nhánh						|Khó kiểm soát khi cả ID và Phone cùng nhập
-- Phù hợp		|Khi cần thông báo chi tiết từng tình huống		|Khi muốn viết nhanh, gọn


--  Lựa chọn: Giải pháp 1 (IF...ELSE) vì dễ bảo trì và thông báo rõ ràng cho từng tình huống.

-- Phần B: Thiết kế & Triển khai
USE my1;

DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),
    OUT p_total_due DECIMAL(18,2),
    OUT p_message VARCHAR(100)
)
BEGIN
    DECLARE v_patient_id INT;

    -- Trường hợp cả ID và Phone đều NULL
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET p_total_due = 0;
        SET p_message = 'Lỗi: Không được bỏ trống cả ID và Phone';
    
    ELSE
        -- Nếu có ID thì ưu tiên tra cứu theo ID
        IF p_patient_id IS NOT NULL THEN
            SELECT patient_id INTO v_patient_id
            FROM Patients
            WHERE patient_id = p_patient_id;
        ELSE
            SELECT patient_id INTO v_patient_id
            FROM Patients
            WHERE phone = p_phone;
        END IF;

        -- Nếu không tìm thấy bệnh nhân
        IF v_patient_id IS NULL THEN
            SET p_total_due = 0;
            SET p_message = 'Không tìm thấy bệnh nhân';
        ELSE
            SELECT total_due INTO p_total_due
            FROM Patient_Invoices
            WHERE patient_id = v_patient_id;

            SET p_message = 'Đã tra cứu thành công';
        END IF;
    END IF;
END //

DELIMITER ;

-- (1) Chỉ truyền ID
CALL GetPatientDebt(1, NULL, @debt, @msg);
SELECT @debt AS TongNo, @msg AS ThongBao;

-- (2) Chỉ truyền Phone
CALL GetPatientDebt(NULL, '0912222333', @debt, @msg);
SELECT @debt, @msg;

-- (3) Truyền NULL cả 2
CALL GetPatientDebt(NULL, NULL, @debt, @msg);
SELECT @debt, @msg;

-- (4) Truyền ID hoặc Phone không tồn tại
CALL GetPatientDebt(999, NULL, @debt, @msg);
SELECT @debt, @msg;
