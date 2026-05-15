USE Rikkeiclinicdb;

SELECT * FROM appointments;

ALTER TABLE appointments 
MODIFY appointment_id INT AUTO_INCREMENT;

DROP TRIGGER IF EXISTS PreventDoctorDoubleBookingInsert;
DROP TRIGGER IF EXISTS PreventDoctorDoubleBookingUpdate;

DELIMITER //

-- Trigger kiểm soát khi thêm mới
CREATE TRIGGER PreventDoctorDoubleBookingInsert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Appointments
        WHERE doctor_id = NEW.doctor_id
          AND appointment_date = NEW.appointment_date
          AND status <> 'Cancelled'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;
END //

-- Trigger kiểm soát khi dời lịch
CREATE TRIGGER PreventDoctorDoubleBookingUpdate
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF (NEW.appointment_date <> OLD.appointment_date OR NEW.doctor_id <> OLD.doctor_id) THEN
        IF EXISTS (
            SELECT 1
            FROM Appointments
            WHERE doctor_id = NEW.doctor_id
              AND appointment_date = NEW.appointment_date
              AND status <> 'Cancelled'
              AND appointment_id <> OLD.appointment_id
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
        END IF;
    END IF;
END //

DELIMITER ;


-- Kịch bản 1: Lịch mới đưa vào khung giờ hoàn toàn trống → Thành công


INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status)
VALUES (1, 101, '2026-05-20 09:00:00', 'Pending');
-- Kịch bản 2: Lịch mới đưa vào khung giờ đang có ca 'Pending' -> Bị chặn & Báo lỗi


INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status)
VALUES (1, 101, '2026-05-20 09:00:00', 'Pending');
-- Trigger sẽ báo lỗi vì trùng giờ với ca chưa hủy

-- Kịch bản 3: Lịch mới đưa vào khung giờ đang có ca 'Cancelled' -> Thành công


INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status)
VALUES (1, 101, '2026-05-20 09:00:00', 'Cancelled');

-- Sau đó thêm ca mới cùng giờ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status)
VALUES (1, 101, '2026-05-20 09:00:00', 'Pending');
-- Thành công vì ca cũ đã hủy

-- Kịch bản 4: Cập nhật trạng thái một ca khám từ 'Pending' sang 'Completed' → Thành công

UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 1;
-- Thành công vì chỉ đổi trạng thái, không đổi giờ hay bác sĩ

