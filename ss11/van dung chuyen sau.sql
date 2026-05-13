USE my1;

DELIMITER //

CREATE PROCEDURE CalculateDischargeCost(
    IN p_total_cost DECIMAL(18,2),
    IN p_patient_type VARCHAR(20),
    INOUT p_final_amount DECIMAL(18,2),
    INOUT p_message VARCHAR(100)
)
BEGIN
    -- Kiểm tra chi phí hợp lệ
    IF p_total_cost < 0 THEN
        SET p_final_amount = 0;
        SET p_message = 'Lỗi: Chi phí không hợp lệ';
    ELSE
        CASE p_patient_type
            WHEN 'BHYT' THEN
                SET p_final_amount = p_total_cost * 0.2;
            WHEN 'VIP' THEN
                SET p_final_amount = p_total_cost * 0.9;
            WHEN 'THUONG' THEN
                SET p_final_amount = p_total_cost;
            ELSE
                SET p_final_amount = p_total_cost;
        END CASE;
        SET p_message = 'Đã tính toán xong';
    END IF;
END //

DELIMITER ;

-- Trường hợp BHYT: Tổng chi phí 1.000.000 → phải đóng 200.000
SET @final_amount = 0; SET @msg = '';
CALL CalculateDischargeCost(1000000, 'BHYT', @final_amount, @msg);
SELECT @final_amount AS SoTienPhaiThu, @msg AS ThongBao;

-- Trường hợp VIP: Tổng chi phí 1.000.000 → phải đóng 900.000
SET @final_amount = 0; SET @msg = '';
CALL CalculateDischargeCost(1000000, 'VIP', @final_amount, @msg);
SELECT @final_amount, @msg;

-- Trường hợp THUONG: Tổng chi phí 1.000.000 → phải đóng 1.000.000
SET @final_amount = 0; SET @msg = '';
CALL CalculateDischargeCost(1000000, 'THUONG', @final_amount, @msg);
SELECT @final_amount, @msg;

-- Trường hợp nhập sai chi phí âm: -500000 → phải thu = 0, báo lỗi
SET @final_amount = 0; SET @msg = '';
CALL CalculateDischargeCost(-500000, 'BHYT', @final_amount, @msg);
SELECT @final_amount, @msg;
