# TỔNG HỢP BÀI TẬP LẬP TRÌNH & CƠ SỞ DỮ LIỆU (PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế giao diện Web (HTML/CSS/JS Layout), thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu, tái cấu trúc hệ thống, tối ưu hóa truy vấn JOIN, tối ưu chỉ mục B-Tree Index và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI TẬP FRONTEND: THIẾT KẾ GIAO DIỆN FACEBOOK (FIXED HEADER & SIDEBAR)

### 1. Mục tiêu & Mô tả
Thiết kế giao diện giản lược của Facebook đáp ứng các yêu cầu:
- **Fixed Header ở trên cùng**: Cố định hoàn toàn trên viewport với `position: fixed; top: 0; left: 0; width: 100%; z-index: 1000;`, chứa Logo Facebook, ô tìm kiếm thông minh, thanh điều hướng Tabs trung tâm và các nút tiện ích (Menu, Messenger, Thông báo, Avatar).
- **Các phần Sidebar**:
  - **Left Sidebar**: Cố định hoặc cuộn độc lập, gồm Trang cá nhân, Bạn bè, Kỷ niệm, Đã lưu, Nhóm, Video, Marketplace, Lối tắt và nút Xem thêm.
  - **Right Sidebar**: Cố định bên phải, gồm mục Được tài trợ (Quảng cáo), Sinh nhật, Danh bạ bạn bè trực tuyến (với trạng thái chấm xanh Online) và Cuộc trò chuyện nhóm.
- **Phần nội dung chính (Main Content)**: Căn giữa, cuộn nội dung mượt mà, bao gồm Thanh Tin/Stories, Hộp tạo bài viết nhanh và Danh sách các bài đăng (Feed Posts) tương tác sinh động.

### 2. Danh sách file nộp:
- 📄 [`fixed_header_layout/index.html`](./fixed_header_layout/index.html): Mã nguồn HTML5 chuẩn ngữ nghĩa.
- 🎨 [`fixed_header_layout/style.css`](./fixed_header_layout/style.css): Bộ stylesheet CSS hiện đại, màu sắc chuẩn Facebook, Flexbox layout và hiệu ứng tương tác.
- ⚡ [`fixed_header_layout/script.js`](./fixed_header_layout/script.js): Xử lý tương tác Tabs, Đăng bài mới, Like bài viết và Thêm bình luận theo thời gian thực.

---

## 📌 BÀI 13: TỐI ƯU HÓA HIỆU NĂNG TRUY VẤN VÀ B-TREE INDEX (PAYFLOW)

### 1. Mô tả bài toán & Giải pháp
Khắc phục sự cố sập server Ví điện tử **PayFlow** do truy vấn báo cáo của Kế toán chạy mất 45 giây và làm vọt CPU lên 100%:
- **Loại bỏ truy vấn Non-SARGable**: Thay thế `YEAR(created_at) = 2026 AND MONTH(created_at) = 6` bằng phép so sánh khoảng thời gian chuẩn SARGable: `created_at >= '2026-06-01 00:00:00' AND created_at < '2026-07-01 00:00:00'`.
- **Tạo Composite B-Tree Index**: Khai báo `CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at)`.
- **Kết quả EXPLAIN**: Chuyển chỉ số `type` từ `ALL` (Full Table Scan) sang `range` / `ref`, giảm số dòng quét từ 5.000.000 dòng xuống vài nghìn dòng, thời gian thực thi giảm từ 45 giây xuống vài miligiây.

### 2. Danh sách file nộp cho Bài 13:
- 📄 **`payflow_optimized.sql`**: Mã DDL tạo bảng, Composite Index, truy vấn legacy EXPLAIN và truy vấn SARGable EXPLAIN đã tối ưu.
- 📝 **`explain_analysis.md`**: Báo cáo so sánh các chỉ số EXPLAIN trước & sau khi tối ưu (< 200 từ) và 3 câu trả lời vấn đáp với CTO.
- 🤖 **`ai_prompt_log.md`**: Nhật ký sử dụng AI thảo luận về SARGable, thứ tự cột trong Composite Index và EXPLAIN profiling.

---

## 📌 BÀI 12: TRUY VẤN DỮ LIỆU CSDL `QuanLyBanHang` (SELECT & JOIN)
- 📄 `truy_van_quan_ly_ban_hang.sql`: DML chèn dữ liệu mẫu và 4 câu lệnh truy vấn `SELECT`.

---

## 📌 BÀI 11: LUYỆN TẬP CÁC CÂU LỆNH TRUY VẤN NÂNG CAO CSDL `QuanLySinhVien`
- 📄 `luyen_tap_truy_van_quan_ly_sinh_vien.sql`: Lọc dữ liệu `LIKE`, `BETWEEN`, `MONTH` và `UPDATE`.

---

## 📌 BÀI 10: TỐI ƯU TRUY VẤN JOIN & XỬ LÝ DỮ LIỆU THIẾU HỤT (FLASHMART)
- 📄 `flashmart_reports.sql`: Mã DDL, DML & 2 câu lệnh `SELECT` đã tối ưu hóa.
- 📝 `join_analysis.md`: Giải trình `COUNT(o.order_id)` & 3 câu trả lời vấn đáp với CDO.

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
git commit -m "Hoan thanh bai thuc hanh Toi uu truy van SQL PayFlow"
git push origin main
```
