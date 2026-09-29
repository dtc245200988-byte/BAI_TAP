-- Bài tập: Thực hành sử dụng Trigger trong MySQL
-- Bước 1: Tạo cơ sở dữ liệu và bảng
CREATE DATABASE IF NOT EXISTS company;
USE company;

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- Bước 2: Tạo Trigger (Cập nhật phòng ban dựa theo mức lương)
DELIMITER //
DROP TRIGGER IF EXISTS update_department //
CREATE TRIGGER update_department 
BEFORE INSERT ON employees 
FOR EACH ROW 
BEGIN 
    IF NEW.salary >= 5000 THEN 
        SET NEW.department = 'Management'; 
    ELSEIF NEW.salary >= 3000 THEN 
        SET NEW.department = 'Sales'; 
    ELSE 
        SET NEW.department = 'Support'; 
    END IF; 
END // 
DELIMITER ;

-- Bước 3: Demo sử dụng trigger
-- Giả sử chèn vào department là 'A', nhưng Trigger sẽ tự động ghi đè theo salary
INSERT INTO employees (name, department, salary) 
VALUES 
('John Doe', 'A', 3500), 
('Jane Smith', 'A', 2000), 
('David Johnson', 'A', 6000);

-- Kiểm tra kết quả
SELECT * FROM employees;
