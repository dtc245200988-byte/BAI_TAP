-- ============================================================
-- BÀI TẬP: LUYỆN TẬP CÁC CÂU LỆNH TRUY VẤN DỮ LIỆU NÂNG CAO & UPDATE
-- Database: QuanLySinhVien
-- Target Repo: https://github.com/dtc245200988-byte/BAI_TAP.git
-- ============================================================

-- Chọn cơ sở dữ liệu QuanLySinhVien
USE QuanLySinhVien;

-- -----------------------------------------------------------------------------
-- CÁC CÂU LỆNH TRUY VẤN VÀ CẬP NHẬT DỮ LIỆU ACCORDING TO REQS
-- -----------------------------------------------------------------------------

-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' (hoặc 'H')
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%' OR StudentName LIKE 'H%';

-- 2. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- 3. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3 đến 5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
UPDATE Student 
SET ClassID = 2 
WHERE StudentName = 'Hung';

-- 5. Hiển thị các thông tin: StudentName, SubName, Mark.
-- Dữ liệu sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng sắp xếp theo tên (StudentName) tăng dần.
SELECT 
    S.StudentName AS 'Tên Sinh Viên',
    Sub.SubName AS 'Tên Môn Học',
    M.Mark AS 'Điểm Thi'
FROM Student S 
JOIN Mark M ON S.StudentID = M.StudentID 
JOIN Subject Sub ON M.SubID = Sub.SubID 
ORDER BY M.Mark DESC, S.StudentName ASC;
