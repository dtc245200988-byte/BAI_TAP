-- ============================================================
-- BÀI TẬP: THÊM DỮ LIỆU VÀO CSDL QUẢN LÝ SINH VIÊN (INSERT INTO)
-- Database: QuanLySinhVien
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- Bước 1: Chọn cơ sở dữ liệu QuanLySinhVien
USE QuanLySinhVien;

-- Đảm bảo xóa dữ liệu cũ (nếu có) trước khi chèn mới để tránh trùng lặp khóa chính/khóa ngoại
DELETE FROM Mark;
DELETE FROM Student;
DELETE FROM Subject;
DELETE FROM Class;

-- Bước 2: Thêm lần lượt các bản ghi vào trong bảng Class
INSERT INTO Class (ClassID, ClassName, StartDate, Status) VALUES 
(1, 'A1', '2008-12-20', 1),
(2, 'A2', '2008-12-22', 1),
(3, 'B3', CURRENT_DATE, 0);

-- Bước 3: Thêm dữ liệu vào trong bảng Student
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES 
('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassId) VALUES 
('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES 
('Manh', 'HCM', '0123123123', 0, 2);

-- Bước 4: Thêm dữ liệu nhanh vào trong bảng Subject
INSERT INTO Subject (SubId, SubName, Credit, Status) VALUES 
(1, 'CF', 5, 1),
(2, 'C', 6, 1),
(3, 'HDJ', 5, 1),
(4, 'RDBMS', 10, 1);

-- Bước 5: Thêm dữ liệu vào trong bảng Mark
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes) VALUES 
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

-- -----------------------------------------------------------------------------
-- TRUY VẤN KIỂM TRA DỮ LIỆU VỪA CHÈN (SELECT VERIFICATION)
-- -----------------------------------------------------------------------------
SELECT * FROM Class;
SELECT * FROM Student;
SELECT * FROM Subject;
SELECT * FROM Mark;
