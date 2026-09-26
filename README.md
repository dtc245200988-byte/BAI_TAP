# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 6: XÂY DỰNG CƠ SỞ DỮ LIỆU `QuanLyBanHang` (SQL)

### 1. Mô tả bài toán
Tạo cơ sở dữ liệu quản lý bán hàng siêu thị có tên **`QuanLyBanHang`** gồm 4 bảng:
- **`Customer`**: Lưu trữ danh sách khách hàng (`cID`, `cName`, `cAge`).
- **`Order`**: Lưu các hóa đơn bán hàng (`oID`, `cID`, `oDate`, `oTotalPrice`).
- **`Product`**: Lưu thông tin sản phẩm (`pID`, `pName`, `pPrice`).
- **`OrderDetail`**: Bảng trung gian quan hệ N-N lưu chi tiết hóa đơn (`oID`, `pID`, `odQTY`).

### 2. Danh sách file nộp cho Bài 6:
- 📄 **`quan_ly_ban_hang.sql`**: Mã nguồn DDL tạo CSDL, 4 bảng dữ liệu kèm các ràng buộc `PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `DEFAULT` và dữ liệu mẫu DML.
- 📝 **`quan_ly_ban_hang_report.md`**: Báo cáo tài liệu thiết kế chi tiết cấu trúc bảng và ràng buộc.

---

## 📌 BÀI 5: CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ
- 📄 `chuyen_doi_erd_report.md`: Báo cáo phân tích 4 bước chuyển đổi.
- 💻 `chuyen_doi_erd_sang_quan_he.sql`: Mã DDL khởi tạo 9 bảng quan hệ.

---

## 📌 BÀI 4: KHỦNG HOẢNG TẠI PHÒNG KHÁM HEALTHSYNC
- 📄 `healthsync_db.sql`: Schema, Trigger, DML kịch bản & SELECT báo cáo.
- 📝 `consistency_report.md`: Gap Analysis & Bảo vệ thiết kế.
- 🤖 `ai_prompt_log.md`: Nhật ký thảo luận AI.

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
git commit -m "Hoan thanh bai tap tao CSDL QuanLyBanHang"
git push origin main
```
