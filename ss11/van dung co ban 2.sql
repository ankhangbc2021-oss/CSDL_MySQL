USE rikkeiclinicdb;

DELIMITER //

CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
	UPDATE Inventory
	SET stock_quantity = stock_quantity + p_quantity
	WHERE item_id = p_item_id;
END //

DELIMITER ;

-- Phần A: Phân tích

-- Viết một câu lệnh CALL tái hiện lại chính xác thao tác gõ nhầm số âm của nhân viên cho mã vật tư item_id = 10.
CALL AddInventory(10, -12);
-- Giải thích ngắn gọn (1–2 dòng) lý do lệnh UPDATE hiện tại lại gây mất hàng trong kho.
--  Nguyên nhân do chưa có trình sử lý điều kiện nên nó vẫn nhận số lượng âm 

-- Phần B: Sửa chữa mã nguồn

-- Viết lệnh DROP để xóa thủ tục cũ.
DROP PROCEDURE IF EXISTS AddInventory;
-- Viết lệnh CREATE tạo lại thủ tục AddInventory mới. Cấu trúc mã phải đảm bảo: 
-- Chỉ thực hiện cộng kho nếu dữ liệu truyền vào hợp lệ theo đúng quy tắc hệ thống.

DELIMITER // 
CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
	IF p_quantity <= 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: số lượng không được âm';
    ELSE 
		UPDATE Inventory
		SET stock_quantity = stock_quantity + p_quantity
		WHERE item_id = p_item_id;
	END IF;
END // 
DELIMITER ;