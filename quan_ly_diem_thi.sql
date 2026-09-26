-- ============================================================
-- BÀI TẬP: TẠO BẢNG TRONG CƠ SỞ DỮ LIỆU QUẢN LÝ ĐIỂM THI (SQL)
-- Database: QuanLyDiemThi
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- Bước 1: Tạo cơ sở dữ liệu QuanLyDiemThi
CREATE DATABASE IF NOT EXISTS QuanLyDiemThi;

-- Bước 2: Chọn Database QuanLyDiemThi để làm việc
USE QuanLyDiemThi;

-- Bước 3: Tạo bảng HocSinh
CREATE TABLE IF NOT EXISTS HocSinh (
    MaHS VARCHAR(20) PRIMARY KEY,
    TenHS VARCHAR(50),
    NgaySinh DATETIME,
    Lop VARCHAR(20),
    GT VARCHAR(20)
);

-- Bước 4: Tạo bảng MonHoc (chưa có khóa ngoại)
CREATE TABLE IF NOT EXISTS MonHoc (
    MaMH VARCHAR(20) PRIMARY KEY,
    TenMH VARCHAR(50),
    MaGV VARCHAR(20)
);

-- Bước 5: Tạo bảng trung gian BangDiem (quan hệ n - n giữa HocSinh và MonHoc)
CREATE TABLE IF NOT EXISTS BangDiem (
    MaHS VARCHAR(20),
    MaMH VARCHAR(20),
    DiemThi INT,
    NgayKT DATETIME,
    PRIMARY KEY (MaHS, MaMH),
    CONSTRAINT FK_BangDiem_HocSinh FOREIGN KEY (MaHS) REFERENCES HocSinh(MaHS),
    CONSTRAINT FK_BangDiem_MonHoc FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);

-- Bước 6: Tạo bảng GiaoVien
CREATE TABLE IF NOT EXISTS GiaoVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    TenGV VARCHAR(50),
    SDT VARCHAR(10)
);

-- Bước 7: Chỉnh sửa bảng MonHoc bổ sung thêm khóa ngoại FK_MaGV liên kết tới bảng GiaoVien
ALTER TABLE MonHoc 
ADD CONSTRAINT FK_MaGV FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV);
