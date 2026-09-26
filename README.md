# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu, tái cấu trúc hệ thống và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 7: KHỦNG HOẢNG TẠI STARTUP AUTORIDE (SYSTEM RE-ENGINEERING)

### 1. Mô tả bài toán & Giải pháp
Tái cấu trúc CSDL ứng dụng thuê xe tự lái **AutoRide** khắc phục tình trạng thất thoát tiền cọc và không ghi nhận phí đền bù:
- **Tái cấu trúc bảng `Rentals`**: Khóa trạng thái `status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED')`.
- **Bổ sung quản lý tài chính**: `security_deposit DECIMAL(12,2)`, `late_fee DECIMAL(12,2)` và `damage_fee DECIMAL(12,2)`.
- **Bảng mới `Inspections`**: Lưu biên bản kiểm tra tình trạng xe (vỡ đèn, va chạm) liên kết với hợp đồng thuê xe.
- **Ràng buộc Trigger toàn vẹn**: Trigger `trg_prevent_invalid_inspection` ngăn tạo biên bản kiểm tra cho hợp đồng đang `BOOKED`.
- **Công thức hoàn cọc**: $\text{Refund} = \text{Deposit} - \text{Late Fee} - \text{Damage Fee}$.

### 2. Danh sách file nộp cho Bài 7:
- 📄 **`autoride_db.sql`**: Mã DDL, Trigger, DML kịch bản mô phỏng khách "Nguyen Van A" hư hỏng đèn pha & SELECT tính hoàn cọc.
- 📝 **`er_activity_mapping.md`**: Báo cáo phân tích tính bắt buộc của `damage_fee` (< 200 từ) & 3 câu trả lời vấn đáp.
- 🤖 **`ai_prompt_log.md`**: Nhật ký sử dụng AI thảo luận về `DECIMAL`, `COALESCE` và `Trigger`.

---

## 📌 BÀI 6: XÂY DỰNG CƠ SỞ DỮ LIỆU `QuanLyBanHang` (SQL)
- 📄 `quan_ly_ban_hang.sql`: Mã DDL 4 bảng (`Customer`, `Order`, `Product`, `OrderDetail`) & DML mẫu.
- 📝 `quan_ly_ban_hang_report.md`: Báo cáo thiết kế cấu trúc CSDL.

---

## 📌 BÀI 5: CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ
- 📄 `chuyen_doi_erd_report.md`: Báo cáo phân tích 4 bước chuyển đổi sơ đồ ERD Vật tư sang 9 bảng quan hệ.
- 💻 `chuyen_doi_erd_sang_quan_he.sql`: Mã DDL khởi tạo 9 bảng quan hệ.

---

## 📌 BÀI 4: KHỦNG HOẢNG TẠI PHÒNG KHÁM HEALTHSYNC
- 📄 `healthsync_db.sql`: Schema, Trigger, DML kịch bản & SELECT báo cáo.
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
git commit -m "Hoan thanh bai thuc hanh Khung Hoang Tai Startup AutoRide"
git push origin main
```
