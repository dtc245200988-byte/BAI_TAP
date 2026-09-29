-- Bài tập: Luyện tập sử dụng View, Index, Store Procedure

-- Bước 1: Tạo cơ sở dữ liệu demo
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- Bước 2: Tạo bảng Products và chèn dữ liệu
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(50) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10,2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(50)
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES 
('P001', 'Iphone 14 Pro Max', 25000000.00, 50, 'Điện thoại flagship của Apple', 'Available'),
('P002', 'Samsung Galaxy S23', 20000000.00, 30, 'Điện thoại flagship của Samsung', 'Available'),
('P003', 'Macbook Pro M2', 35000000.00, 20, 'Laptop chuyên dụng cho đồ hoạ', 'Available'),
('P004', 'Dell XPS 15', 30000000.00, 15, 'Laptop văn phòng cao cấp', 'Out of stock');

-- Bước 3: Đánh chỉ mục (Index) và so sánh với EXPLAIN
-- EXPLAIN trước khi tạo Index (type: ALL)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'Iphone 14 Pro Max' AND productPrice = 25000000.00;

-- Tạo Unique Index trên bảng Products (cột productCode)
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- Tạo Composite Index trên bảng Products (cột productName và productPrice)
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- EXPLAIN sau khi tạo Index (type: const, ref)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'Iphone 14 Pro Max' AND productPrice = 25000000.00;

-- Bước 4: Tạo, Sửa, Xoá View
-- Tạo view
CREATE VIEW vw_products AS 
SELECT productCode, productName, productPrice, productStatus 
FROM Products;

SELECT * FROM vw_products;

-- Sửa đổi view (Bằng cách CREATE OR REPLACE)
CREATE OR REPLACE VIEW vw_products AS 
SELECT productCode, productName, productPrice, productAmount, productStatus 
FROM Products
WHERE productStatus = 'Available';

SELECT * FROM vw_products;

-- Xóa view
DROP VIEW IF EXISTS vw_products;

-- Bước 5: Tạo Store Procedures

-- 1. Store Procedure lấy tất cả thông tin
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_GetAllProducts`//
CREATE PROCEDURE sp_GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

CALL sp_GetAllProducts();

-- 2. Store Procedure thêm một sản phẩm mới
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_AddProduct`//
CREATE PROCEDURE sp_AddProduct(
    IN p_code VARCHAR(50), 
    IN p_name VARCHAR(100), 
    IN p_price DECIMAL(10,2), 
    IN p_amount INT, 
    IN p_desc TEXT, 
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //
DELIMITER ;

CALL sp_AddProduct('P005', 'iPad Pro M2', 22000000.00, 10, 'Máy tính bảng Apple', 'Available');

-- 3. Store Procedure sửa thông tin sản phẩm theo id
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_UpdateProductById`//
CREATE PROCEDURE sp_UpdateProductById(
    IN p_id INT,
    IN p_code VARCHAR(50), 
    IN p_name VARCHAR(100), 
    IN p_price DECIMAL(10,2), 
    IN p_amount INT, 
    IN p_desc TEXT, 
    IN p_status VARCHAR(50)
)
BEGIN
    UPDATE Products 
    SET 
        productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //
DELIMITER ;

CALL sp_UpdateProductById(1, 'P001', 'Iphone 14 Pro Max 256GB', 26000000.00, 45, 'Điện thoại flagship của Apple updated', 'Available');

-- 4. Store Procedure xoá sản phẩm theo id
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_DeleteProductById`//
CREATE PROCEDURE sp_DeleteProductById(IN p_id INT)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;

CALL sp_DeleteProductById(4);

-- Kiểm tra kết quả cuối cùng
CALL sp_GetAllProducts();
