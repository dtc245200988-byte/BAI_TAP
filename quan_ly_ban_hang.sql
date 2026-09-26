-- ============================================================
-- BÀI TẬP: TẠO BẢNG VÀ TRUY VẤN DỮ LIỆU CSDL QUẢN LÝ BÁN HÀNG (SQL)
-- Database: QuanLyBanHang
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- 1. KỊCH BẢN DDL: TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- Bảng Customer
CREATE TABLE IF NOT EXISTS Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge TINYINT
);

-- Bảng Order
CREATE TABLE IF NOT EXISTS `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice DECIMAL(15,2) DEFAULT NULL,
    CONSTRAINT FK_Order_Customer FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- Bảng Product
CREATE TABLE IF NOT EXISTS Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(15,2) NOT NULL CHECK (pPrice >= 0)
);

-- Bảng OrderDetail
CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (oID) REFERENCES `Order`(oID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (pID) REFERENCES Product(pID) ON DELETE CASCADE
);

-- 2. KỊCH BẢN DML: CHÈN DỮ LIỆU MẪU (INSERT INTO)
DELETE FROM OrderDetail;
DELETE FROM `Order`;
DELETE FROM Product;
DELETE FROM Customer;

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
(3, 1, 8),
(3, 2, 4);

-- 3. CÁC CÂU LỆNH TRUY VẤN DỮ LIỆU (SELECT QUERIES)

-- Yêu cầu 1: Hiển thị oID, oDate, oTotalPrice của tất cả hóa đơn
SELECT oID, oDate, oTotalPrice FROM `Order`;

-- Yêu cầu 2: Hiển thị danh sách khách hàng đã mua hàng và sản phẩm tương ứng
SELECT DISTINCT c.cName, p.pName 
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- Yêu cầu 3: Hiển thị tên những khách hàng KHÔNG mua bất kỳ sản phẩm nào
SELECT c.cName 
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- Yêu cầu 4: Hiển thị oID, oDate và oTotalPrice được tính toán = SUM(odQTY * pPrice)
SELECT 
    o.oID,
    o.oDate,
    SUM(od.odQTY * p.pPrice) AS oTotalPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
