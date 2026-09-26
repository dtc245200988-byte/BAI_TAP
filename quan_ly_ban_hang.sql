-- ============================================================
-- BÀI TẬP: XÂY DỰNG CƠ SỞ DỮ LIỆU QUẢN LÝ BÁN HÀNG (SQL)
-- Database: QuanLyBanHang
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- Bước 1: Tạo cơ sở dữ liệu QuanLyBanHang
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;

-- Bước 2: Chọn Database QuanLyBanHang để thao tác
USE QuanLyBanHang;

-- Bước 3: Tạo bảng Customer (Khách hàng)
CREATE TABLE IF NOT EXISTS Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge TINYINT
);

-- Bước 4: Tạo bảng Order (Hóa đơn - Lưu ý 'Order' là từ khóa hệ thống SQL nên dùng dấu backtick `Order`)
CREATE TABLE IF NOT EXISTS `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice DECIMAL(15,2) DEFAULT NULL,
    CONSTRAINT FK_Order_Customer FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- Bước 5: Tạo bảng Product (Sản phẩm)
CREATE TABLE IF NOT EXISTS Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(15,2) NOT NULL CHECK (pPrice >= 0)
);

-- Bước 6: Tạo bảng trung gian OrderDetail (Chi tiết hóa đơn - Quan hệ N-N giữa Order và Product)
CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (oID) REFERENCES `Order`(oID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (pID) REFERENCES Product(pID) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- DỮ LIỆU MẪU CHÈN THỬ NHIỆM (DML TESTING)
-- -----------------------------------------------------------------------------
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(2, 3, 8),
(2, 5, 4),
(3, 2, 4);
