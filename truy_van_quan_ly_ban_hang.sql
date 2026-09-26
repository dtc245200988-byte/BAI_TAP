-- ============================================================
-- BÀI TẬP: TRUY VẤN DỮ LIỆU CSDL QUẢN LÝ BÁN HÀNG (SELECT QUERIES)
-- Database: QuanLyBanHang
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

USE QuanLyBanHang;

-- -----------------------------------------------------------------------------
-- 1. CHÈN VÀ CẬP NHẬT DỮ LIỆU MẪU CHUẨN ĐỀ BÀI (DML INSERT)
-- -----------------------------------------------------------------------------
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


-- =============================================================================
-- 2. CÁC CÂU LỆNH TRUY VẤN DỮ LIỆU NÂNG CAO (SELECT QUERIES)
-- =============================================================================

-- Query 1: Hiển thị các thông tin gồm oID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Order
SELECT oID, oDate, oTotalPrice 
FROM `Order`;


-- Query 2: Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách hàng đó
SELECT DISTINCT 
    c.cID AS 'Mã KH',
    c.cName AS 'Tên Khách Hàng', 
    p.pName AS 'Tên Sản Phẩm Đã Mua'
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
ORDER BY c.cID, p.pName;


-- Query 3: Hiển thị tên những khách hàng KHÔNG mua bất kỳ một sản phẩm nào (Anti-Join sử dụng LEFT JOIN ... WHERE IS NULL)
SELECT 
    c.cID AS 'Mã KH',
    c.cName AS 'Tên Khách Hàng Chưa Mua Hàng'
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;


-- Query 4: Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn
-- (Giá một hóa đơn = Tổng (odQTY * pPrice) của các sản phẩm thuộc hóa đơn đó)
SELECT 
    o.oID AS 'Mã Hóa Đơn',
    o.oDate AS 'Ngày Bán',
    SUM(od.odQTY * p.pPrice) AS 'Giá Tiền Hóa Đơn (oTotalPrice)'
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
