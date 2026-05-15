USE Rikkeiclinicdb;

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
	-- Lôi logic: Dùng NEW thay vì OLD khiến toàn bộ hệ thống bị "tê liệt"
	IF NEW.status = 'Completed' THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Lôi: Không được phép thao tác trên lịch khẩm này!';
	END IF;
END //

DELIMITER ;

-- Phần A: Phân tích
SELECT * FROM appointments;
-- Viết một câu lệnh UPDATE thử chuyển lịch khám có mã appointment_id = 104 từ trạng thái 'Pending' sang 'Completed' để quan sát lỗi do Trigger gây ra.
UPDATE appointments 
SET status = 'Completed'
WHERE appointment_id = 104;
-- Giải thích ngắn gọn (1–2 dòng): Để kiểm tra xem một lịch khám trong quá khứ đã hoàn thành hay chưa, bạn phải dùng đối tượng OLD hay NEW? Vì sao? 

-- Để kiểm tra xem một lịch khám trong quá khứ đã hoàn thành hay chưa, bạn phải dùng OLD.
-- Lý do: OLD phản ánh trạng thái trước khi cập nhật, cho biết lịch hẹn vốn đã ở trạng thái nào. Nếu muốn ngăn việc “hoàn thành rồi mà lại sửa ngược”, ta cần so sánh với giá trị cũ (OLD), chứ không phải giá trị mới (NEW).

-- Phần B: Sửa chữa mã nguồn

-- Viết lệnh DROP để xóa Trigger cũ.
DROP TRIGGER IF EXISTS PreventStatusRevert;
-- Viết lệnh CREATE tạo lại Trigger PreventStatusRevert mới. Viết lại Trigger PreventStatusRevert để chặn UPDATE.

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
	
	IF OLD.status = 'Completed' THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Lôi: Không được phép thao tác trên lịch khẩm này!';
	END IF;
END //

DELIMITER ;

-- test 
UPDATE appointments 
SET status = 'Completed'
WHERE appointment_id = 104;