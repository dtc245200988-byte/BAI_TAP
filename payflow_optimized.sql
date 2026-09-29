-- =============================================================================
-- DỰ ÁN PAYFLOW: TỐI ƯU HÓA HIỆU NĂNG TRUY VẤN CSDL VÀ CHỈ MỤC B-TREE
-- DATABASE OPTIMIZATION, SARGABLE REFACTORING & EXPLAIN PROFILING SCRIPT
-- Target Database: payflow_db
-- Target Repository: https://github.com/dtc245200988-byte/BAI_TAP.git
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU VÀ BẢNG TRANSACTIONS
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL, -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME NOT NULL
);

-- -----------------------------------------------------------------------------
-- 2. CHÈN DỮ LIỆU MẪU MÔ PHỎNG HỆ THỐNG GIAO DỊCH
-- -----------------------------------------------------------------------------
INSERT INTO Transactions (user_id, amount, transaction_type, created_at) VALUES 
(1001, 500000.00, 'DEPOSIT', '2026-06-01 08:15:00'),
(1002, 1200000.00, 'DEPOSIT', '2026-06-15 14:30:00'),
(1003, 300000.00, 'WITHDRAW', '2026-06-20 09:10:00'),
(1001, 200000.00, 'TRANSFER', '2026-06-25 18:00:00'),
(1004, 2500000.00, 'DEPOSIT', '2026-06-30 23:55:00'),
(1005, 1000000.00, 'DEPOSIT', '2026-07-01 00:05:00'); -- Tháng 7 (ngoài khoảng)


-- =============================================================================
-- 3. BƯỚC 1: ĐÁNH GIÁ CÂU TRUY VẤN LEGACY CỦA KẾ TOÁN (NON-SARGABLE QUERY)
-- Vấn đề: Dùng hàm YEAR(created_at) và MONTH(created_at) làm vô hiệu hóa Index,
-- ép MySQL phải thực hiện Quét toàn bộ bảng (Full Table Scan - type = ALL).
-- =============================================================================

-- Kiểm tra kế hoạch thực thi của câu lệnh cũ (Chưa có Index + Non-SARGable):
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;


-- =============================================================================
-- 4. BƯỚC 2: TẠO COMPOSITE B-TREE INDEX TỐI ƯU HÓA HỆ THỐNG
-- Quy tắc: Đặt cột lọc bằng (Equality - transaction_type) đứng trước, 
-- cột lọc khoảng (Range - created_at) đứng sau.
-- =============================================================================

CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);


-- =============================================================================
-- 5. BƯỚC 3: TÁI CẤU TRÚC TRUY VẤN THÀNH DẠNG SARGABLE & KIỂM TRA EXPLAIN
-- Giải pháp: Loại bỏ hàm YEAR() / MONTH(), chuyển sang phép so sánh khoảng thời gian:
-- created_at >= '2026-06-01 00:00:00' AND created_at < '2026-07-01 00:00:00'
-- Kết quả EXPLAIN: type chuyển từ 'ALL' sang 'range' / 'ref', rows quét cực nhỏ!
-- =============================================================================

-- Kiểm tra kế hoạch thực thi mới sau khi tối ưu:
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at < '2026-07-01 00:00:00';

-- -----------------------------------------------------------------------------
-- 6. THỰC THI TRUY VẤN TÍNH TỔNG DÒNG TIỀN NẠP THÁNG 6/2026
-- -----------------------------------------------------------------------------
SELECT 
    SUM(amount) AS total_deposit_june_2026
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at < '2026-07-01 00:00:00';
