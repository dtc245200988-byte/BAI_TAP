-- =============================================================================
-- DỰ ÁN FLASHMART: TỐI ƯU TRUY VẤN JOIN VÀ KHẮC PHỤC THẤT THOÁT DỮ LIỆU
-- DATABASE DDL, DML & OPTIMIZED SELECT QUERIES
-- Target Database: flashmart_db
-- Target Repository: https://github.com/dtc245200988-byte/BAI_TAP.git
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG DỮ LIỆU
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- Xóa các bảng cũ nếu đã tồn tại
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 1.1. Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 1.2. Bảng Products (Sản phẩm)
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

-- 1.3. Bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- -----------------------------------------------------------------------------
-- 2. CHÈN DỮ LIỆU MẪU THỬ NHIỆM (DML DATA INSERTION)
-- -----------------------------------------------------------------------------

-- Chèn 3 khách hàng (Chú ý: Charlie customer_id = 3 chưa từng mua hàng)
INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie');

-- Chèn 3 sản phẩm (Chú ý: Keyboard product_id = 103 chưa từng được ai mua)
INSERT INTO Products VALUES 
(101, 'Laptop'), 
(102, 'Mouse'), 
(103, 'Keyboard');

-- Chèn các đơn hàng giao dịch
INSERT INTO Orders VALUES 
(1001, 1, 101), 
(1002, 1, 102), 
(1003, 2, 101);


-- =============================================================================
-- 3. CÁC CÂU LỆNH TRUY VẤN ĐÃ ĐƯỢC KHẮC PHỤC CHUẨN XÁC (OPTIMIZED REPORT QUERIES)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- BÁO CÁO 1 (CHO GIÁM ĐỐC MARKETING):
-- Yêu cầu: Danh sách TẤT CẢ khách hàng kèm số lượng đơn hàng (Bao gồm người chưa từng mua)
-- Giải pháp: Sử dụng LEFT JOIN kết hợp COUNT(o.order_id)
-- Kết quả đúng: Alice (2 đơn), Bob (1 đơn), Charlie (0 đơn)
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_id AS 'Mã Khách Hàng',
    c.name AS 'Tên Khách Hàng',
    COUNT(o.order_id) AS 'Tổng Số Đơn Hàng'
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;


-- -----------------------------------------------------------------------------
-- BÁO CÁO 2 (CHO GIÁM ĐỐC KHO VẬN):
-- Yêu cầu: Danh sách các sản phẩm CHƯA TỪNG ĐƯỢC BÁN LẦN NÀO để thanh lý thu hồi vốn
-- Giải pháp: Kỹ thuật Anti-Join sử dụng LEFT JOIN ... WHERE o.order_id IS NULL
-- Kết quả đúng: 103 - Keyboard
-- -----------------------------------------------------------------------------
SELECT 
    p.product_id AS 'Mã Sản Phẩm',
    p.product_name AS 'Tên Sản Phẩm'
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
