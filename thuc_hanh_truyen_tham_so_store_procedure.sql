-- Bài tập: Thực hành truyền tham số vào Store Procedure trong MySQL
-- Sử dụng CSDL mẫu classicmodels
USE classicmodels;

-- -----------------------------------------------------------------------------
-- 1. Tham số loại IN
-- -----------------------------------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS `getCusById`//
CREATE PROCEDURE getCusById (IN cusNum INT(11))
BEGIN
  SELECT * FROM customers WHERE customerNumber = cusNum;
END //
DELIMITER ;

-- Gọi store procedure loại IN
CALL getCusById(175);

-- -----------------------------------------------------------------------------
-- 2. Tham số loại OUT
-- -----------------------------------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS `GetCustomersCountByCity`//
CREATE PROCEDURE GetCustomersCountByCity(
    IN  in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END//
DELIMITER ;

-- Gọi store procedure loại OUT
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS TotalCustomersInLyon;

-- -----------------------------------------------------------------------------
-- 3. Tham số loại INOUT
-- -----------------------------------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS `SetCounter`//
CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END//
DELIMITER ;

-- Gọi store procedure loại INOUT
SET @counter = 1;
CALL SetCounter(@counter, 1); -- Tăng 1, kết quả: 2
CALL SetCounter(@counter, 1); -- Tăng 1, kết quả: 3
CALL SetCounter(@counter, 5); -- Tăng 5, kết quả: 8
SELECT @counter AS FinalCounterValue; -- 8
