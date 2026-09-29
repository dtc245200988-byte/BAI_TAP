-- Bài tập: Thực hành tạo View trong MySQL
-- Sử dụng CSDL mẫu classicmodels
USE classicmodels;

-- BƯỚC 1: Tạo View có tên customer_views truy vấn dữ liệu từ bảng customers
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- BƯỚC 2: Truy vấn dữ liệu từ bảng ảo customer_views
SELECT * FROM customer_views;

-- BƯỚC 3: Cập nhật view customer_views (thêm contactFirstName, contactLastName và điều kiện city = 'Nantes')
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- BƯỚC 4: Truy vấn lại dữ liệu từ view sau khi cập nhật
SELECT * FROM customer_views;

-- BƯỚC 5: Xoá view customer_views
DROP VIEW customer_views;
