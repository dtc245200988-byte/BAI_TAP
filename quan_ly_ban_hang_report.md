# BÁO CÁO THIẾT KẾ CƠ SỞ DỮ LIỆU QUẢN LÝ BÁN HÀNG (`QuanLyBanHang`)

**Dự án:** Cơ sở dữ liệu Quản lý bán hàng siêu thị (`QuanLyBanHang`)  
**Mục tiêu:** Khởi tạo CSDL, định nghĩa cấu trúc 4 bảng dữ liệu kèm theo các ràng buộc khóa chính (PK), khóa ngoại (FK) và kiểm tra miền giá trị.

---

## 📌 1. CẤU TRÚC VÀ RÀNG BUỘC CÁC BẢNG DỮ LIỆU

### **1. Bảng `Customer` (Khách hàng)**
Lưu trữ danh sách khách hàng đến siêu thị.
- `cID`: Kiểu `INT`, `AUTO_INCREMENT`, **Khóa chính (Primary Key)**.
- `cName`: Kiểu `VARCHAR(50)`, `NOT NULL` - Tên khách hàng.
- `cAge`: Kiểu `TINYINT` - Tuổi khách hàng.

### **2. Bảng `Order` (Hóa đơn mua hàng)**
Lưu các hóa đơn mua hàng của khách hàng.
- `oID`: Kiểu `INT`, `AUTO_INCREMENT`, **Khóa chính (Primary Key)**.
- `cID`: Kiểu `INT`, `NOT NULL`, **Khóa ngoại (Foreign Key)** liên kết tới `Customer(cID)`.
- `oDate`: Kiểu `DATETIME`, `NOT NULL` - Ngày mua hàng.
- `oTotalPrice`: Kiểu `DECIMAL(15,2)`, `DEFAULT NULL` - Tổng giá trị hóa đơn.

### **3. Bảng `Product` (Sản phẩm)**
Lưu thông tin sản phẩm có tại siêu thị.
- `pID`: Kiểu `INT`, `AUTO_INCREMENT`, **Khóa chính (Primary Key)**.
- `pName`: Kiểu `VARCHAR(100)`, `NOT NULL` - Tên sản phẩm.
- `pPrice`: Kiểu `DECIMAL(15,2)`, `NOT NULL`, `CHECK (pPrice >= 0)` - Đơn giá sản phẩm.

### **4. Bảng `OrderDetail` (Chi tiết hóa đơn - Bảng trung gian N:N)**
Lưu danh sách sản phẩm và số lượng mua tương ứng cho từng hóa đơn.
- `oID`: Kiểu `INT`, `NOT NULL`, **Khóa ngoại (FK)** liên kết tới `` `Order`(oID) ``.
- `pID`: Kiểu `INT`, `NOT NULL`, **Khóa ngoại (FK)** liên kết tới `Product(pID)`.
- `odQTY`: Kiểu `INT`, `NOT NULL`, `CHECK (odQTY > 0)` - Số lượng sản phẩm mua.
- **Khóa chính phức hợp:** `PRIMARY KEY (oID, pID)`.

---

## 💻 2. MÃ NGUỒN SQL KHỞI TẠO CSDL (`quan_ly_ban_hang.sql`)

```sql
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- 1. Bảng Customer
CREATE TABLE IF NOT EXISTS Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge TINYINT
);

-- 2. Bảng Order
CREATE TABLE IF NOT EXISTS `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice DECIMAL(15,2) DEFAULT NULL,
    CONSTRAINT FK_Order_Customer FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 3. Bảng Product
CREATE TABLE IF NOT EXISTS Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(15,2) NOT NULL CHECK (pPrice >= 0)
);

-- 4. Bảng OrderDetail
CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (oID) REFERENCES `Order`(oID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (pID) REFERENCES Product(pID) ON DELETE CASCADE
);
```

---

## 🔗 LINK NỘP BÀI GITHUB
👉 **[https://github.com/dtc245200988-byte/BAI_TAP](https://github.com/dtc245200988-byte/BAI_TAP)**
