-- ============================================================
-- BÀI TẬP: XÂY DỰNG CƠ SỞ DỮ LIỆU VÀ CHÈN DỮ LIỆU QUẢN LÝ SINH VIÊN (SQL)
-- Database: QuanLySinhVien
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- -----------------------------------------------------------------------------
-- 1. KỊCH BẢN DDL: TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;

-- Tạo bảng Class
CREATE TABLE IF NOT EXISTS Class (
    ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

-- Tạo bảng Student
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class (ClassID)
);

-- Tạo bảng Subject
CREATE TABLE IF NOT EXISTS Subject (
    SubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

-- Tạo bảng Mark
CREATE TABLE IF NOT EXISTS Mark (
    MarkID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubID, StudentID),
    FOREIGN KEY (SubID) REFERENCES Subject (SubID),
    FOREIGN KEY (StudentID) REFERENCES Student (StudentID)
);

-- -----------------------------------------------------------------------------
-- 2. KỊCH BẢN DML: CHÈN DỮ LIỆU (INSERT INTO)
-- -----------------------------------------------------------------------------

-- Xóa dữ liệu cũ nếu đã tồn tại trước khi chèn lại
DELETE FROM Mark;
DELETE FROM Student;
DELETE FROM Subject;
DELETE FROM Class;

-- Thêm bản ghi vào bảng Class
INSERT INTO Class (ClassID, ClassName, StartDate, Status) VALUES 
(1, 'A1', '2008-12-20', 1),
(2, 'A2', '22/12/2008', 1), -- hoặc '2008-12-22'
(3, 'B3', CURRENT_DATE, 0);

-- Thêm bản ghi vào bảng Student
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES 
('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassId) VALUES 
('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES 
('Manh', 'HCM', '0123123123', 0, 2);

-- Thêm bản ghi vào bảng Subject
INSERT INTO Subject (SubId, SubName, Credit, Status) VALUES 
(1, 'CF', 5, 1),
(2, 'C', 6, 1),
(3, 'HDJ', 5, 1),
(4, 'RDBMS', 10, 1);

-- Thêm bản ghi vào bảng Mark
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes) VALUES 
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);
