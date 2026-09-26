# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu, tái cấu trúc hệ thống, tối ưu hóa truy vấn JOIN và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 11: LUYỆN TẬP CÁC CÂU LỆNH TRUY VẤN NÂNG CAO CSDL `QuanLySinhVien`

### 1. Mô tả bài toán
Thực hiện các yêu cầu truy vấn lọc dữ liệu phức tạp và cập nhật dữ liệu trên CSDL **`QuanLySinhVien`**:
- Tìm sinh viên có tên bắt đầu bằng ký tự `'h'` (`LIKE 'h%'`).
- Tìm các lớp học khai giảng vào tháng 12 (`MONTH(StartDate) = 12`).
- Tìm môn học có số tín chỉ trong khoảng 3 đến 5 (`Credit BETWEEN 3 AND 5`).
- Cập nhật `ClassID = 2` cho sinh viên tên `'Hung'` (`UPDATE Student`).
- Hiển thị bảng điểm gồm `StudentName`, `SubName`, `Mark`, sắp xếp theo điểm giảm dần (`ORDER BY Mark DESC, StudentName ASC`).

### 2. Danh sách file nộp cho Bài 11:
- 📄 **`luyen_tap_truy_van_quan_ly_sinh_vien.sql`**: Mã SQL DML thực thi 5 yêu cầu truy vấn & cập nhật dữ liệu.

---

## 📌 BÀI 10: TỐI ƯU TRUY VẤN JOIN & XỬ LÝ DỮ LIỆU THIẾU HỤT (FLASHMART)
- 📄 `flashmart_reports.sql`: Mã DDL, DML & 2 câu lệnh `SELECT` đã tối ưu hóa.
- 📝 `join_analysis.md`: Giải trình `COUNT(o.order_id)` & 3 câu trả lời vấn đáp với CDO.
- 🤖 `ai_prompt_log.md`: Nhật ký thảo luận AI.

---

## 📌 BÀI 9: TRUY VẤN DỮ LIỆU TỪ CSDL `QuanLySinhVien` (SELECT)
- 📄 `truy_van_quan_ly_sinh_vien.sql`: Các câu lệnh `SELECT` lọc dữ liệu và `JOIN` nhiều bảng.

---

## 📌 BÀI 8: THÊM DỮ LIỆU VÀO CSDL `QuanLySinhVien` (INSERT INTO)
- 📄 `them_du_lieu_quan_ly_sinh_vien.sql`: Mã SQL DML chèn dữ liệu mẫu vào 4 bảng.

---

## 📌 BÀI 7: KHỦNG HOẢNG TẠI STARTUP AUTORIDE (SYSTEM RE-ENGINEERING)
- 📄 `autoride_db.sql`: Schema, Trigger, DML & SELECT tính cọc hoàn lại.
- 📝 `er_activity_mapping.md`: Phân tích `damage_fee` & 3 câu trả lời vấn đáp.

---

## 📌 BÀI 6: XÂY DỰNG CƠ SỞ DỮ LIỆU `QuanLyBanHang` (SQL)
- 📄 `quan_ly_ban_hang.sql`: Mã DDL 4 bảng (`Customer`, `Order`, `Product`, `OrderDetail`) & DML.
- 📝 `quan_ly_ban_hang_report.md`: Báo cáo thiết kế CSDL.

---

## 📌 BÀI 5: CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ
- 📄 `chuyen_doi_erd_report.md`: Phân tích 4 bước chuyển đổi ERD sang 9 bảng quan hệ.
- 💻 `chuyen_doi_erd_sang_quan_he.sql`: Mã DDL 9 bảng.

---

## 📌 BÀI 4: KHỦNG HOẢNG TẠI PHÒNG KHÁM HEALTHSYNC
- 📄 `healthsync_db.sql`: Schema, Trigger, DML & SELECT báo cáo.
- 📝 `consistency_report.md`: Gap Analysis & Bảo vệ thiết kế.

---

## 📌 BÀI 3: TẠO CƠ SỞ DỮ LIỆU `QuanLySinhVien` VÀ RÀNG BUỘC (SQL)
File mã nguồn: [`quan_ly_sinh_vien.sql`](./quan_ly_sinh_vien.sql)

---

## 📌 BÀI 2: TẠO BẢNG TRONG CSDL `QuanLyDiemThi` (SQL)
File mã nguồn: [`quan_ly_diem_thi.sql`](./quan_ly_diem_thi.sql)

---

## 📌 BÀI 1: THIẾT KẾ SƠ ĐỒ ERD QUẢN LÝ ĐƠN ĐẶT HÀNG & PHIẾU GIAO HÀNG
Hình ảnh sơ đồ ERD chuẩn hóa: [`erd_step5_simplified.jpg`](./erd_step5_simplified.jpg) & Giao diện tương tác: [`index.html`](./index.html).

---

## 🚀 LỆNH GIT ĐẨY BÀI LÊN GITHUB

```bash
cd "c:\Users\Admin\OneDrive\Desktop\công việc\BAI_TAP"

git add .
git commit -m "Hoan thanh bai tap Luyen tap truy van nang cao QuanLySinhVien"
git push origin main
```
