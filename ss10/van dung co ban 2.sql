CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;

CREATE TABLE IF NOT EXISTS Patients (
	Full_Name VARCHAR(150) NOT NULL, 
    Phone VARCHAR(15) NOT NULL,
    Age INT NOT NULL,
    Address TEXT
);

DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= 500000 DO
		INSERT INTO Patients (Full_Name, Phone, Age, Address)
		VALUES (CONCAT('Patient ', i), CONCAT('090', i), FLOOR(RAND()*100), 'Ho Chi Minh City');
		SET i = i + 1;
	END WHILE;
END //
DELIMITER ;

-- Gọi procedure đề nạp dữ liệu
CALL SeedPatients();

-- Đo lường tốc độ truy vấn: Thực hiện câu lệnh SELECT tìm kiếm theo Phone trước và sau khi đánh Index. Sử dụng EXPLAIN để phân tích cách Database vận hành.

-- Trước khi sử dụng Index 
SELECT * FROM Patients WHERE Phone = '0905234';

-- Sau khi sử dụng Index 
CREATE INDEX index_phone  ON Patients (Phone);
DROP INDEX index_phone  ON Patients;

SELECT * FROM Patients WHERE Phone = '0905234';
-- Kết quả sau khi sử dụng Index thì nó chạy rất nhanh dưới 0.1s trong khi đó trước khi sử dụng thì hơn 2s

-- Đo lường tốc độ ghi: Viết script thực hiện INSERT 1.000 dòng liên tục khi bảng có Index 
-- và khi không có Index để so sánh thời gian thực thi.
DELIMITER // 
	CREATE PROCEDURE INSERT_TEST_data()
    BEGIN 
		DECLARE i INT DEFAULT 1;
        WHILE i <= 1000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
		VALUES (CONCAT('New Patient ', i), CONCAT('090', i), FLOOR(RAND()*100), 'Ho Chi Minh City');
        SET i = i + 1;
	END WHILE;
END//
DELIMITER ;

CALL INSERT_TEST_data();

-- Kết quả: Khi Index thì nó chạy chậm hơn khi chưa Index vì nó phải cập nhật lại Index 


