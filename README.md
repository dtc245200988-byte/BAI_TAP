# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu, tái cấu trúc hệ thống và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 8: THÊM DỮ LIỆU VÀO CSDL `QuanLySinhVien` (INSERT INTO)

### 1. Mô tả bài toán
Sử dụng các câu lệnh `INSERT INTO` để chèn dữ liệu mẫu vào 4 bảng của cơ sở dữ liệu **`QuanLySinhVien`**:
- **Bảng `Class`**: Thêm các lớp `A1`, `A2`, `B3`.
- **Bảng `Student`**: Thêm các sinh viên `Hung`, `Hoa`, `Manh`.
- **Bảng `Subject`**: Thêm các môn `CF`, `C`, `HDJ`, `RDBMS`.
- **Bảng `Mark`**: Thêm các điểm thi sinh viên.

### 2. Danh sách file nộp cho Bài 8:
- 📄 **`them_du_lieu_quan_ly_sinh_vien.sql`**: Mã SQL DML thực thi chèn dữ liệu mẫu vào 4 bảng theo các bước hướng dẫn.
- 📄 **`quan_ly_sinh_vien.sql`**: File tổng hợp cả DDL (tạo CSDL, bảng) và DML (chèn dữ liệu).

---

## 📌 BÀI 7: KHỦNG HOẢNG TẠI STARTUP AUTORIDE (SYSTEM RE-ENGINEERING)
- 📄 `autoride_db.sql`: Schema, Trigger, DML kịch bản mô phỏng hư hỏng xe & SELECT tính hoàn cọc.
- 📝 `er_activity_mapping.md`: Phân tích tính bắt buộc của `damage_fee` & 3 câu trả lời vấn đáp.
- 🤖 `ai_prompt_log.md`: Nhật ký thảo luận AI.

---

## 📌 BÀI 6: XÂY DỰNG CƠ SỞ DỮ LIỆU `QuanLyBanHang` (SQL)
- 📄 `quan_ly_ban_hang.sql`: Mã DDL 4 bảng (`Customer`, `Order`, `Product`, `OrderDetail`) & DML mẫu.
- 📝 `quan_ly_ban_hang_report.md`: Báo cáo thiết kế cấu trúc CSDL.

---

## 📌 BÀI 5: CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ
- 📄 `chuyen_doi_erd_report.md`: Phân tích 4 bước chuyển đổi ERD Vật tư sang 9 bảng quan hệ.
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
git commit -m "Hoan thanh bai tap Them du lieu voi INSERT INTO CSDL QuanLySinhVien"
git push origin main
```
