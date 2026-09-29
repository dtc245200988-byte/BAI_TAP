-- Bài tập: Thực hành tạo chỉ mục (Index) trong MySQL
-- Sử dụng CSDL mẫu classicmodels
USE classicmodels;

-- BƯỚC 1: Tìm thông tin của khách hàng có tên là Land Of Toys Inc. 
-- Xem EXPLAIN trước khi đánh Index (sẽ bị duyệt qua tất cả rows, type = ALL)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- BƯỚC 2: Thêm chỉ mục cho cột customerName của bảng customers
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- BƯỚC 3: EXPLAIN lại xem có sự thay đổi không 
-- (sẽ sử dụng được possible_keys là idx_customerName, type: ref, rows: 1)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- BƯỚC 4: Thêm Index theo cặp (Composite Index) cho cột contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- BƯỚC 5: EXPLAIN truy vấn tìm kiếm theo contactFirstName
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- BƯỚC 6: Xoá chỉ mục trong bảng
ALTER TABLE customers DROP INDEX idx_full_name;
