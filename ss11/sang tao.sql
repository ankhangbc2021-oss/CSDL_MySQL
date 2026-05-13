-- Phần A: Thiết kế kiến trúc
-- 1. Flowchart (luồng dữ liệu):

-- Y tá nhập (Patient_ID, Dept_ID)
--         |
--         v
-- [Procedure Master: TransferBed]
--         |
--         +--> Kiểm tra hồ sơ bệnh nhân (Completed?) ❌ --> Báo lỗi
--         |
--         +--> Gọi Procedure phụ: FindEmptyBed(Dept_ID)
--                 |
--                 +--> Không tìm thấy giường trống ❌ --> Báo lỗi "Từ chối: Khoa ... đã hết giường"
--                 |
--                 +--> Trả về Bed_ID trống
--         |
--         +--> Giải phóng giường cũ
--         |
--         +--> Gán bệnh nhân vào giường mới
--         |
--         +--> Khóa giường mới
--         |
--         v
-- Trả về Bed_ID mới + Thông báo trạng thái

-- Thiết kế giao tiếp:

-- Procedure Master (TransferBed) nhận IN Patient_ID, IN Dept_ID
-- Procedure phụ (FindEmptyBed) nhận IN Dept_ID, trả về OUT Bed_ID.
-- Procedure Master dùng INOUT để hứng kết quả từ Procedure phụ (Bed_ID mới + Message).

-- Phần B: Triển khai Code
USE my1;

-- Procedure phụ: FindEmptyBed
DELIMITER //

CREATE PROCEDURE FindEmptyBed(
    IN p_dept_id INT,
    OUT p_bed_id INT
)
BEGIN
    -- Tìm giường trống đầu tiên trong khoa
    SELECT bed_id INTO p_bed_id
    FROM Beds
    WHERE dept_id = p_dept_id AND patient_id IS NULL
    LIMIT 1;

    -- Nếu không tìm thấy thì trả về NULL
    IF p_bed_id IS NULL THEN
        SET p_bed_id = 0;
    END IF;
END //

DELIMITER ;

-- Procedure Master: TransferBed
DELIMITER //

CREATE PROCEDURE TransferBed(
    IN p_patient_id INT,
    IN p_dept_id INT,
    OUT p_new_bed_id INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_old_bed INT;

    -- Kiểm tra bệnh nhân đã xuất viện chưa
    SELECT status INTO v_status
    FROM Appointments
    WHERE patient_id = p_patient_id
    ORDER BY appointment_date DESC
    LIMIT 1;

    IF v_status = 'Completed' THEN
        SET p_new_bed_id = 0;
        SET p_message = 'Lỗi: Bệnh nhân đã xuất viện, không thể chuyển giường.';
        LEAVE proc;
    END IF;

    -- Gọi procedure phụ để tìm giường trống
    CALL FindEmptyBed(p_dept_id, p_new_bed_id);

    -- Nếu không có giường trống
    IF p_new_bed_id = 0 THEN
        SET p_message = CONCAT('Từ chối: Khoa ', 
                               (SELECT dept_name FROM Departments WHERE dept_id = p_dept_id),
                               ' đã hết giường');
    ELSE
        -- Lấy giường cũ
        SELECT bed_id INTO v_old_bed
        FROM Beds
        WHERE patient_id = p_patient_id;

        -- Giải phóng giường cũ
        UPDATE Beds
        SET patient_id = NULL
        WHERE bed_id = v_old_bed;

        -- Gán bệnh nhân vào giường mới
        UPDATE Beds
        SET patient_id = p_patient_id
        WHERE bed_id = p_new_bed_id;

        SET p_message = 'Chuyển giường thành công';
    END IF;
END //

DELIMITER ;
-- test 
-- (1) Chuyển khoa thành công
CALL TransferBed(1, 2, @new_bed, @msg);
SELECT @new_bed AS BedMoi, @msg AS ThongBao;

-- (2) Bẫy hết giường trống
CALL TransferBed(2, 3, @new_bed, @msg);
SELECT @new_bed, @msg;

-- (3) Bẫy bệnh nhân đã xuất viện
CALL TransferBed(2, 1, @new_bed, @msg);
SELECT @new_bed, @msg;

-- (4) Dept_ID không tồn tại
CALL TransferBed(1, 999, @new_bed, @msg);
SELECT @new_bed, @msg;
