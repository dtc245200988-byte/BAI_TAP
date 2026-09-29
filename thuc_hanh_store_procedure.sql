-- Bài tập: Thực hành tạo Store Procedure trong MySQL
-- Sử dụng CSDL mẫu classicmodels
USE classicmodels;

-- BƯỚC 1: Tạo Store Procedure đầu tiên (findAllCustomers)
DELIMITER //
CREATE PROCEDURE findAllCustomers()
BEGIN
  SELECT * FROM customers;
END //
DELIMITER ;

-- BƯỚC 2: Gọi procedure
CALL findAllCustomers();

-- BƯỚC 3: Sửa procedure (Bằng cách DROP và CREATE lại)
DELIMITER //
DROP PROCEDURE IF EXISTS `findAllCustomers`//
CREATE PROCEDURE findAllCustomers()
BEGIN
  SELECT * FROM customers WHERE customerNumber = 175;
END //
DELIMITER ;

-- BƯỚC 4: Gọi lại procedure sau khi sửa
CALL findAllCustomers();
