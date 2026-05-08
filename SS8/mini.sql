-- ==============================
-- PHẦN I - THIẾT KẾ & TẠO BẢNG (DDL)
-- ==============================

CREATE DATABASE IF NOT EXISTS sales_management_system;
USE sales_management_system;

-- Bảng khách hàng
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender TINYINT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL
);

-- Bảng danh mục
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Bảng sản phẩm
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
);

-- Bảng đơn hàng
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE IF NOT EXISTS order_details (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_price DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (order_id, product_id),
    
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

-- ==============================
-- PHẦN II - NHẬP DỮ LIỆU BAN ĐẦU
-- ==============================

-- Khách hàng
INSERT INTO customers (full_name, dob, gender, email, phone_number)
VALUES
('Nguyen Van A','1985-10-04',1,'a@gmail.com','0111111111'),
('Tran Van B','1985-05-06',0,'b@gmail.com','0222222222'),
('Tran Van C','1985-04-07',0,'c@gmail.com','023456789'),
('Tran Van D','1985-03-09',0,'d@gmail.com','0222222227'),
('Tran Van E','1985-02-10',0,'e@gmail.com','0222222224'),
('Le Thi F','2001-01-15',1,'f@gmail.com','0999999999'); -- chưa từng đặt hàng

-- Danh mục
INSERT INTO categories(category_name)
VALUES
('Dien tu'),
('Thoi trang'),
('Gia dung'),
('Sach'),
('The thao');

-- Sản phẩm
INSERT INTO products(category_id, product_name, product_price)
VALUES
(1, 'Laptop Dell', 22000000),
(1, 'iPhone 15', 28000000),
(1, 'Tai nghe Bluetooth', 1500000),
(2, 'Ao Hoodie', 450000),
(2, 'Quan Jean', 650000),
(3, 'Noi chien khong dau', 1800000),
(4, 'Sach SQL Co Ban', 120000),
(5, 'Giay Adidas', 2500000);

-- Đơn hàng
INSERT INTO orders(customer_id, order_date)
VALUES
(1, '2025-05-01'),
(2, '2025-05-02'),
(3, '2025-05-03'),
(4, '2025-05-04'),
(5, '2025-05-05');

-- Chi tiết đơn hàng
INSERT INTO order_details (order_id, product_id, quantity, order_price)
VALUES
(1, 1, 1, 22000000),
(1, 8, 2, 5000000),
(2, 2, 1, 28000000),
(3, 4, 3, 1350000),
(4, 7, 2, 240000),
(5, 8, 1, 2500000);

-- ==============================
-- PHẦN III - CẬP NHẬT DỮ LIỆU
-- ==============================

-- Cập nhật giá sản phẩm
UPDATE products
SET product_price = 30000000
WHERE product_name = 'iPhone 15';

-- Cập nhật email khách hàng
UPDATE customers
SET email = 'newemail@gmail.com'
WHERE customer_id = 1;

-- ==============================
-- PHẦN IV - XÓA DỮ LIỆU
-- ==============================

-- Xóa chi tiết đơn hàng bị lỗi/hủy
DELETE FROM order_details
WHERE order_id = 5
AND product_id = 8;

-- ==============================
-- PHẦN V - TRUY VẤN DỮ LIỆU
-- ==============================

-- 1. Danh sách khách hàng + CASE
SELECT
    full_name AS 'Ho Ten',
    email AS 'Email',
    CASE
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nu'
    END AS 'Gioi Tinh'
FROM customers;

-- 2. 3 khách hàng trẻ tuổi nhất
SELECT
    full_name,
    YEAR(NOW()) - YEAR(dob) AS age
FROM customers
ORDER BY age ASC
LIMIT 3;

-- 3. Danh sách đơn hàng kèm tên khách hàng
SELECT
    o.order_id,
    o.order_date,
    c.full_name
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- 4. Đếm số lượng sản phẩm theo danh mục
SELECT
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM categories c
INNER JOIN products p
ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) >= 2;

-- 5. Scalar Subquery
-- Sản phẩm có giá lớn hơn giá trung bình

SELECT *
FROM products
WHERE product_price >
(
    SELECT AVG(product_price)
    FROM products
);

-- 6. Column Subquery
-- Khách hàng chưa từng đặt hàng

SELECT *
FROM customers
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM orders
);

-- 7. Subquery với hàm tổng hợp
-- Danh mục có doanh thu > 120% doanh thu trung bình

SELECT
    c.category_name,
    SUM(od.order_price * od.quantity) AS total_revenue
FROM categories c
INNER JOIN products p
ON c.category_id = p.category_id
INNER JOIN order_details od
ON p.product_id = od.product_id
GROUP BY c.category_name
HAVING total_revenue >
(
    SELECT AVG(total_money) * 1.2
    FROM
    (
        SELECT SUM(od2.order_price * od2.quantity) AS total_money
        FROM categories c2
        INNER JOIN products p2
        ON c2.category_id = p2.category_id
        INNER JOIN order_details od2
        ON p2.product_id = od2.product_id
        GROUP BY c2.category_id
    ) AS revenue_table
);

-- 8. Correlated Subquery
-- Sản phẩm đắt nhất trong từng danh mục

SELECT *
FROM products p1
WHERE product_price =
(
    SELECT MAX(product_price)
    FROM products p2
    WHERE p1.category_id = p2.category_id
);

-- 9. Truy vấn lồng nhiều cấp
-- Khách hàng VIP mua sản phẩm thuộc danh mục Điện tử

SELECT DISTINCT full_name
FROM customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM orders
    WHERE order_id IN
    (
        SELECT order_id
        FROM order_details
        WHERE product_id IN
        (
            SELECT product_id
            FROM products
            WHERE category_id =
            (
                SELECT category_id
                FROM categories
                WHERE category_name = 'Dien tu'
            )
        )
    )
);