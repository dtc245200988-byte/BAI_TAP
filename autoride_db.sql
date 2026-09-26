-- =============================================================================
-- DỰ ÁN AUTORIDE: THỰC HÀNH TÁI CẤU TRÚC HỆ THỐNG QUẢN LÝ THUÊ XE
-- DATABASE RE-ENGINEERING & DML SIMULATION SCRIPT
-- Target Database: autoride_db
-- Target Repository: https://github.com/dtc245200988-byte/BAI_TAP.git
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- Xóa các bảng cũ nếu đã tồn tại để xây dựng lại cấu trúc chuẩn
DROP TRIGGER IF EXISTS trg_prevent_invalid_inspection;
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

-- -----------------------------------------------------------------------------
-- 2. TẠO CÁC BẢNG THEO MÔ HÌNH KHỞI TẠO CHUẨN HÓA
-- -----------------------------------------------------------------------------

-- 2.1. Bảng Cars (Danh mục xe)
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 2.2. Bảng Rentals (Hợp đồng thuê xe - Đã nâng cấp cấu trúc & khóa trạng thái)
CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    
    -- Khóa chặt các trạng thái vòng đời hợp đồng bằng kiểu ENUM
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') 
           NOT NULL DEFAULT 'BOOKED',
    
    -- Bổ sung các trường quản lý tài chính sử dụng kiểu DECIMAL(12,2) chống sai số
    security_deposit DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT
);

-- 2.3. Bảng Inspections (Biên bản kiểm tra tình trạng xe - Thực thể độc lập 1-N)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- 3. RÀNG BUỘC TOÀN VẸN NGHIỆP VỤ (DATABASE TRIGGER BẢO VỆ TẦNG CSDL)
-- Chặn không cho phép chèn Biên bản kiểm tra (Inspection) khi hợp đồng đang ở trạng thái 'BOOKED'
-- -----------------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER trg_prevent_invalid_inspection
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE current_rental_status VARCHAR(20);
    
    -- Lấy trạng thái hợp đồng hiện tại
    SELECT status INTO current_rental_status
    FROM Rentals
    WHERE rental_id = NEW.rental_id;
    
    -- Nếu hợp đồng mới dừng ở BOOKED (chưa bàn giao xe), chặn ngay lập tức
    IF current_rental_status = 'BOOKED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI NGHIỆP VỤ: Không thể tạo biên bản kiểm tra xe cho hợp đồng đang ở trạng thái BOOKED!';
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- 4. KỊCH BẢN THỬ NHIỆM VẬN HÀNH & CHÉP DỮ LIỆU THỰC TẾ (DML SIMULATION)
-- -----------------------------------------------------------------------------

-- Chèn dữ liệu xe mẫu
INSERT INTO Cars (car_id, model_name, license_plate) VALUES 
(1, 'Toyota Camry 2024', '30K-123.45'),
(2, 'VinFast VF8', '51H-999.88');

-- =============================================================================
-- MÔ PHỎNG QUY TRÌNH THUÊ VÀ TRẢ XE CÓ SỰ CỐ HƯ HỎNG
-- =============================================================================

-- Bước 1: Khách hàng "Nguyen Van A" đặt thuê xe, đóng cọc 10.000.000 VNĐ. Trạng thái ACTIVE
INSERT INTO Rentals (rental_id, car_id, customer_name, rent_date, return_date, status, security_deposit)
VALUES (1001, 1, 'Nguyen Van A', '2026-10-01 08:00:00', '2026-10-03 18:00:00', 'ACTIVE', 10000000.00);

-- Bước 2: Khách trả xe. Nhân viên "Tran Van B" kiểm tra phát hiện vỡ đèn pha trái
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1001, '2026-10-03 17:45:00', 'Vỡ đèn pha trái do va chạm nhẹ', 'Tran Van B');

-- Bước 3: Cập nhật hợp đồng Rentals: Trạng thái COMPLETED, late_fee = 0đ, damage_fee = 2.000.000 VNĐ
UPDATE Rentals 
SET status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1001;


-- =============================================================================
-- 5. TRUY VẤN TÍNH TOÁN TIỀN HOÀN TRẢ VÀ BÁO CÁO DOANH THU (SELECT QUERY)
-- -----------------------------------------------------------------------------
-- Tiền hoàn lại cho khách = Tiền cọc - Phí phạt trễ - Phí sửa chữa
-- =============================================================================
SELECT 
    r.rental_id AS 'Mã Hợp Đồng',
    r.customer_name AS 'Tên Khách Hàng',
    c.model_name AS 'Mẫu Xe',
    c.license_plate AS 'Biển Số',
    r.status AS 'Trạng Thái',
    r.security_deposit AS 'Tiền Cọc (VND)',
    COALESCE(r.late_fee, 0.00) AS 'Phí Phạt Trễ (VND)',
    COALESCE(r.damage_fee, 0.00) AS 'Phí Sửa Chữa (VND)',
    (r.security_deposit - COALESCE(r.late_fee, 0.00) - COALESCE(r.damage_fee, 0.00)) AS 'Tiền Cọc Hoàn Lại (VND)',
    i.damage_description AS 'Ghi Chú Hư Hỏng'
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1001;
