# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE ASSIGNMENTS)

Repository tổng hợp đầy đủ các bài tập thực hành thiết kế cơ sở dữ liệu (ERD) và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 3: TẠO CƠ SỞ DỮ LIỆU `QuanLySinhVien` VÀ RÀNG BUỘC (SQL)

### 1. Mô tả bài toán
Xây dựng cơ sở dữ liệu có tên **`QuanLySinhVien`** gồm 4 bảng:
- **`Class`**: Quản lý lớp học (`ClassID`, `ClassName`, `StartDate`, `Status`).
- **`Student`**: Quản lý sinh viên (`StudentID`, `StudentName`, `Address`, `Phone`, `Status`, `ClassID`).
- **`Subject`**: Quản lý môn học (`SubID`, `SubName`, `Credit`, `Status`).
- **`Mark`**: Quản lý điểm thi sinh viên (`MarkID`, `SubID`, `StudentID`, `Mark`, `ExamTimes`).

### 2. Chi tiết các ràng buộc áp dụng:
- **Primary Key & Auto Increment:** Tự động tăng cho tất cả các mã ID chính (`ClassID`, `StudentID`, `SubID`, `MarkID`).
- **Foreign Key:** 
  - `Student(ClassID)` $\rightarrow$ `Class(ClassID)`
  - `Mark(SubID)` $\rightarrow$ `Subject(SubID)`
  - `Mark(StudentID)` $\rightarrow$ `Student(StudentID)`
- **Unique Constraint:** Ràng buộc duy nhất `UNIQUE (SubID, StudentID)` trong bảng `Mark`.
- **Default & Check Constraints:**
  - `Credit`: Mặc định = 1, ĐK `Credit >= 1`
  - `Subject.Status`: Mặc định = 1
  - `Mark.Mark`: Mặc định = 0, ĐK `Mark BETWEEN 0 AND 100`
  - `Mark.ExamTimes`: Mặc định = 1

### 3. Mã nguồn SQL (`quan_ly_sinh_vien.sql`)

```sql
-- Bước 1: Tạo cơ sở dữ liệu QuanLySinhVien
CREATE DATABASE IF NOT EXISTS QuanLySinhVien;

-- Bước 2: Chọn Database QuanLySinhVien
USE QuanLySinhVien;

-- Bước 3: Tạo bảng Class
CREATE TABLE IF NOT EXISTS Class (
    ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

-- Bước 4: Tạo bảng Student
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class (ClassID)
);

-- Bước 5: Tạo bảng Subject
CREATE TABLE IF NOT EXISTS Subject (
    SubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

-- Bước 6: Tạo bảng Mark
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
```

---

## 📌 BÀI 2: TẠO BẢNG TRONG CSDL `QuanLyDiemThi` (SQL)

File mã nguồn: [`quan_ly_diem_thi.sql`](./quan_ly_diem_thi.sql)

```sql
CREATE DATABASE IF NOT EXISTS QuanLyDiemThi;
USE QuanLyDiemThi;

CREATE TABLE IF NOT EXISTS HocSinh (
    MaHS VARCHAR(20) PRIMARY KEY,
    TenHS VARCHAR(50),
    NgaySinh DATETIME,
    Lop VARCHAR(20),
    GT VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS MonHoc (
    MaMH VARCHAR(20) PRIMARY KEY,
    TenMH VARCHAR(50),
    MaGV VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS BangDiem (
    MaHS VARCHAR(20),
    MaMH VARCHAR(20),
    DiemThi INT,
    NgayKT DATETIME,
    PRIMARY KEY (MaHS, MaMH),
    CONSTRAINT FK_BangDiem_HocSinh FOREIGN KEY (MaHS) REFERENCES HocSinh(MaHS),
    CONSTRAINT FK_BangDiem_MonHoc FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);

CREATE TABLE IF NOT EXISTS GiaoVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    TenGV VARCHAR(50),
    SDT VARCHAR(10)
);

ALTER TABLE MonHoc 
ADD CONSTRAINT FK_MaGV FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV);
```

---

## 📌 BÀI 1: THIẾT KẾ SƠ ĐỒ ERD QUẢN LÝ ĐƠN ĐẶT HÀNG & PHIẾU GIAO HÀNG

### Sơ đồ ERD chuẩn hóa:
![ERD Simplified](./erd_step5_simplified.jpg)

---

## 🚀 HƯỚNG DẪN LỆNH GIT

```bash
cd "c:\Users\Admin\OneDrive\Desktop\công việc\BAI_TAP"

git add .
git commit -m "Bo sung bai tap tao CSDL QuanLySinhVien"
git push origin main
```
