# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU (DATABASE & SQL)

Repository lưu trữ các bài tập thực hành thiết kế mô hình ERD và câu lệnh SQL khởi tạo cơ sở dữ liệu.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 2: TẠO BẢNG TRONG CSDL `QuanLyDiemThi` (SQL)

### 1. Mô tả bài toán
Tạo cơ sở dữ liệu có tên **`QuanLyDiemThi`** gồm 4 bảng:
- **`HocSinh`**: Quản lý thông tin học sinh (`MaHS`, `TenHS`, `NgaySinh`, `Lop`, `GT`).
- **`GiaoVien`**: Quản lý thông tin giáo viên (`MaGV`, `TenGV`, `SDT`).
- **`MonHoc`**: Quản lý danh mục môn học (`MaMH`, `TenMH`, `MaGV`).
- **`BangDiem`**: Bảng trung gian quản lý điểm thi (`MaHS`, `MaMH`, `DiemThi`, `NgayKT`).

### 2. Sơ đồ liên kết thực thể (ERD) & Cấu trúc khóa:
- **Khóa chính (Primary Key):**
  - `HocSinh`: `MaHS`
  - `GiaoVien`: `MaGV`
  - `MonHoc`: `MaMH`
  - `BangDiem`: Khóa phức hợp `(MaHS, MaMH)`
- **Khóa ngoại (Foreign Key):**
  - `BangDiem(MaHS)` $\rightarrow$ `HocSinh(MaHS)`
  - `BangDiem(MaMH)` $\rightarrow$ `MonHoc(MaMH)`
  - `MonHoc(MaGV)` $\rightarrow$ `GiaoVien(MaGV)`

### 3. Mã nguồn SQL (`quan_ly_diem_thi.sql`)

```sql
-- Bước 1: Tạo cơ sở dữ liệu QuanLyDiemThi
CREATE DATABASE IF NOT EXISTS QuanLyDiemThi;

-- Bước 2: Chọn Database QuanLyDiemThi
USE QuanLyDiemThi;

-- Bước 3: Tạo bảng HocSinh
CREATE TABLE IF NOT EXISTS HocSinh (
    MaHS VARCHAR(20) PRIMARY KEY,
    TenHS VARCHAR(50),
    NgaySinh DATETIME,
    Lop VARCHAR(20),
    GT VARCHAR(20)
);

-- Bước 4: Tạo bảng MonHoc
CREATE TABLE IF NOT EXISTS MonHoc (
    MaMH VARCHAR(20) PRIMARY KEY,
    TenMH VARCHAR(50),
    MaGV VARCHAR(20)
);

-- Bước 5: Tạo bảng trung gian BangDiem
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

-- Bước 7: Chỉnh sửa bảng MonHoc bổ sung khóa ngoại FK_MaGV
ALTER TABLE MonHoc 
ADD CONSTRAINT FK_MaGV FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV);
```

---

## 📌 BÀI 1: THIẾT KẾ SƠ ĐỒ ERD QUẢN LÝ ĐƠN ĐẶT HÀNG & PHIẾU GIAO HÀNG

### 1. Sơ đồ ERD Ban Đầu (Bước 4):
![ERD Full](./erd_step4_full.jpg)

### 2. Sơ đồ ERD Rút Gọn / Chuẩn Hóa (Bước 5):
![ERD Simplified](./erd_step5_simplified.jpg)

---

## 🚀 HƯỚNG DẪN ĐẨY BÀI NỘP LÊN GITHUB

```bash
cd "c:\Users\Admin\OneDrive\Desktop\công việc\BAI_TAP"

git add .
git commit -m "Bo sung bai tap tao bang CSDL QuanLyDiemThi"
git push origin main
```
