USE Rikkeiclinicdb;

SELECT * FROM Medicines ;

CREATE TABLE IF NOT EXISTS Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(10,2) NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    change_type VARCHAR(20) NOT NULL,   -- 'TĂNG GIÁ' hoặc 'GIẢM GIÁ'
    difference DECIMAL(10,2) NOT NULL,  -- giá chênh lệch
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM Price_Changes_Log ;

-- 2. 
DROP TRIGGER IF EXISTS TrackPriceChanges;

DELIMITER //

CREATE TRIGGER TrackPriceChanges
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN
    DECLARE diff DECIMAL(10,2);

    -- nếu giá mới cao hơn giá cũ
    IF NEW.price > OLD.price THEN
        SET diff = NEW.price - OLD.price;
        INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, change_type, difference)
        VALUES (OLD.medicine_id, OLD.price, NEW.price, 'TĂNG GIÁ', diff);
    END IF;

    -- nếu giá mới thấp hơn giá cũ
    IF NEW.price < OLD.price THEN
        SET diff = OLD.price - NEW.price;
        INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, change_type, difference)
        VALUES (OLD.medicine_id, OLD.price, NEW.price, 'GIẢM GIÁ', diff);
    END IF;
END //

DELIMITER ;

SELECT * FROM Medicines ;
SELECT * FROM Price_Changes_Log ;

-- test 
UPDATE Medicines
SET price = 16000
WHERE medicine_id = 1;

-- 3. 
-- Nếu nhân viên cập nhật các thông tin khác (như Sửa tên thuốc, Cập nhật tồn kho) mà không làm thay đổi giá bán, hệ thống tuyệt đối KHÔNG được phép sinh ra log rác.
-- done 
-- Nếu nhân viên gõ nhầm giá mới là số âm hoặc bằng 0 (VD: -5000), hệ thống không được phép tính toán hay ghi log. Phải ngay lập tức CHẶN giao dịch cập nhật đó và trả về thông báo lỗi: "Lỗi: Giá thuốc mới không hợp lệ".

DROP TRIGGER IF EXISTS TrackPriceChanges;

DELIMITER //

CREATE TRIGGER TrackPriceChanges
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN

	DECLARE diff DECIMAL(10, 2);
	
    IF NEW.price <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;
    
    IF NEW.price <> OLD.price THEN
		
        -- nếu giá mới lớn hơn 
        IF NEW.price > OLD.price THEN
        SET diff = NEW.price - OLD.price ;
        INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, change_type, difference)
        VALUES (OLD.medicine_id, OLD.price, NEW.price, 'TĂNG GIÁ', diff);
        END IF;
        
        -- Nếu giá cũ cao hơn 
        IF NEW.price < OLD.price THEN
        SET diff = OLD.price - NEW.price;
        INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, change_type, difference)
        VALUES (OLD.medicine_id, OLD.price, NEW.price, 'GIẢM GIÁ', diff);
        END IF;
        
	END IF;

END //

DELIMITER ;

SELECT * FROM Medicines ;
SELECT * FROM Price_Changes_Log ;

-- test số âm 
UPDATE Medicines
SET price = -5000
WHERE medicine_id = 1;

-- update stock ko sinh ra rác ở log 
UPDATE Medicines
SET stock = 500
WHERE medicine_id = 1;