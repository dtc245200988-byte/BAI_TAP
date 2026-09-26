-- =============================================================================
-- DỰ ÁN HEALTHSYNC: KHỦNG HOẢNG TẠI PHÒNG KHÁM HEALTHSYNC
-- DATABASE RE-ENGINEERING & DML SIMULATION SCRIPT
-- Target Database: healthsync_db
-- Target Repository: https://github.com/dtc245200988-byte/BAI_TAP.git
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- Xóa các bảng cũ nếu đã tồn tại để tránh xung đột cấu trúc
DROP TRIGGER IF EXISTS trg_prevent_invalid_prescription;
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

-- -----------------------------------------------------------------------------
-- 2. TẠO CÁC BẢNG THEO THIẾT KẾ CHUẨN HÓA (ALIGNED WITH ACTIVITY DIAGRAM)
-- -----------------------------------------------------------------------------

-- 2.1. Bảng Patients (Bệnh nhân)
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2.2. Bảng Doctors (Bác sĩ)
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 2.3. Bảng Appointments (Lịch hẹn - Đã tái cấu trúc bỏ is_active BOOLEAN)
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    
    -- Thay thế cột is_active BOOLEAN bằng ENUM chuẩn hóa 5 trạng thái vòng đời
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') 
           NOT NULL DEFAULT 'PENDING',
    
    -- Bổ sung các cột theo dõi tiền cọc, phí phạt và lý do hủy (Kiểu DECIMAL chống sai số)
    deposit_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT
);

-- 2.4. Bảng Prescriptions (Đơn thuốc - Thực thể mới bổ sung)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- Mỗi lịch hẹn COMPLETED chỉ có 1 đơn thuốc chính thức (Quan hệ 1-1)
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- 3. RÀNG BUỘC TOÀN VẸN NGHIỆP VỤ (DATABASE TRIGGER BẢO VỆ TẦNG CSDL)
-- Chặn hành vi phi logic: Không cho phép tạo đơn thuốc khi lịch hẹn chưa ở trạng thái COMPLETED
-- -----------------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER trg_prevent_invalid_prescription
BEFORE INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    DECLARE current_app_status VARCHAR(20);
    
    -- Lấy trạng thái hiện tại của lịch hẹn
    SELECT status INTO current_app_status
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id;
    
    -- Kiểm tra nếu lịch hẹn chưa hoàn tất (khác 'COMPLETED') thì chặn lại và phát lỗi
    IF current_app_status IS NULL OR current_app_status != 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI NGHIỆP VỤ CSDL: Chỉ có thể kê đơn thuốc cho lịch hẹn đã hoàn thành (status = COMPLETED)!';
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- 4. KỊCH BẢN THỦ NHIỆM VẬN HÀNH & CHÉP DỮ LIỆU THỰC TẾ (DML SIMULATION)
-- -----------------------------------------------------------------------------

-- Chèn dữ liệu mẫu cho Bệnh nhân và Bác sĩ
INSERT INTO Patients (patient_id, full_name, phone) VALUES 
(1, 'Nguyễn Văn An', '0901234567'),
(2, 'Trần Thị Bình', '0912345678');

INSERT INTO Doctors (doctor_id, full_name, specialty) VALUES 
(1, 'BS. Lê Hoài Nam', 'Tim mạch'),
(2, 'BS. Phạm Minh Tuấn', 'Nội khoa');

-- =============================================================================
-- KỊCH BẢN 1: QUY TRÌNH KHÁM BỆNH THÀNH CÔNG RỰC RỠ (COMPLETED & KÊ ĐƠN THUỐC)
-- =============================================================================

-- Bước 1.1: Bệnh nhân Nguyễn Văn An đặt lịch thành công, đặt cọc 500.000đ (Trạng thái: PENDING)
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (101, 1, 1, '2026-10-01 09:00:00', 'PENDING', 500000.00);

-- Bước 1.2: Bệnh nhân đến phòng khám và check-in (Trạng thái -> CHECKED_IN)
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = 101;

-- Bước 1.3: Bác sĩ khám xong (Trạng thái -> COMPLETED)
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = 101;

-- Bước 1.4: Bác sĩ kê đơn thuốc cho lịch hẹn 101 (Thành công vì status = COMPLETED)
INSERT INTO Prescriptions (appointment_id, medication_details, issued_date)
VALUES (101, 'Paracetamol 500mg (20 viên, 2 viên/ngày), Amoxicillin 500mg (14 viên, 2 viên/ngày), Vitamin C 1000mg', NOW());


-- =============================================================================
-- KỊCH BẢN 2: BỆNH NHÂN HỦY LỊCH VÀ TÍNH PHÍ PHẠT (CANCELLED & PENALTY FEE)
-- =============================================================================

-- Bước 2.1: Bệnh nhân Trần Thị Bình đặt lịch và đã xác nhận cọc 300.000đ (Trạng thái: CONFIRMED)
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (102, 2, 2, '2026-10-02 14:30:00', 'CONFIRMED', 300000.00);

-- Bước 2.2: Bệnh nhân báo hủy lịch sau khi đã CONFIRMED
-- Hệ thống cập nhật: status = CANCELLED, cancel_reason = "Bận việc đột xuất", penalty_fee = 150.000đ
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Bận việc đột xuất',
    penalty_fee = 150000.00
WHERE appointment_id = 102;


-- =============================================================================
-- 5. TRUY VẤN KIỂM TRA TOÀN VẸN DỮ LIỆU & BÁO CÁO DOANH THU (SELECT QUERIES)
-- =============================================================================

-- Truy vấn 1: Danh sách chi tiết bệnh nhân đã hoàn tất khám bệnh kèm Đơn thuốc
SELECT 
    a.appointment_id AS 'Mã Lịch Hẹn',
    p.full_name AS 'Tên Bệnh Nhân',
    p.phone AS 'Số Điện Thoại',
    d.full_name AS 'Bác Sĩ Kê Đơn',
    a.appointment_date AS 'Ngày Khám',
    a.status AS 'Trạng Thái',
    pr.medication_details AS 'Chi Tiết Đơn Thuốc',
    pr.issued_date AS 'Ngày Kê Đơn'
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';

-- Truy vấn 2: Báo cáo thống kê tiền cọc, phí phạt hủy lịch và số tiền hoàn lại cho bệnh nhân
SELECT 
    a.appointment_id AS 'Mã Lịch Hẹn',
    p.full_name AS 'Tên Bệnh Nhân',
    a.status AS 'Trạng Thái',
    a.deposit_amount AS 'Tiền Cọc (VND)',
    a.penalty_fee AS 'Phí Phạt Hủy Lịch (VND)',
    (a.deposit_amount - a.penalty_fee) AS 'Tiền Cọc Hoàn Lại (VND)',
    a.cancel_reason AS 'Lý Do Hủy'
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.status = 'CANCELLED';
