# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuẩn hóa cơ sở dữ liệu và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 4: KHỦNG HOẢNG TẠI PHÒNG KHÁM HEALTHSYNC (SYSTEM RE-ENGINEERING)

### 1. Mô tả bài toán & Giải pháp
Tái cấu trúc cơ sở dữ liệu phòng khám **HealthSync** nhằm giải quyết tình trạng "vênh" giữa UML Activity Diagram của BA và CSDL legacy:
- **Tái cấu trúc bảng `Appointments`**: Bỏ cột `is_active` (BOOLEAN), thay bằng `status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')`.
- **Bổ sung quản lý tài chính & hủy lịch**: Cột `deposit_amount DECIMAL(10,2)`, `penalty_fee DECIMAL(10,2)` và `cancel_reason VARCHAR(255)`.
- **Thực thể Đơn thuốc mới (`Prescriptions`)**: Bổ sung bảng kê đơn thuốc kết nối với lịch hẹn hoàn thành.
- **Ràng buộc Trigger toàn vẹn**: Trigger `trg_prevent_invalid_prescription` ngăn chặn kê đơn thuốc khi lịch hẹn chưa `COMPLETED`.

### 2. Danh sách file nộp cho Bài 4:
- 📄 **`healthsync_db.sql`**: Mã nguồn DDL, Trigger, DML kịch bản vận hành & truy vấn báo cáo tài chính.
- 📝 **`consistency_report.md`**: Báo cáo phân tích 4 lỗ hổng dữ liệu (Gap Analysis) & 3 câu trả lời bảo vệ thiết kế.
- 🤖 **`ai_prompt_log.md`**: Nhật ký sử dụng AI thảo luận về thiết kế `ENUM`, kiểu `DECIMAL` và `Trigger`.

---

## 📌 BÀI 3: TẠO CƠ SỞ DỮ LIỆU `QuanLySinhVien` VÀ RÀNG BUỘC (SQL)
File mã nguồn: [`quan_ly_sinh_vien.sql`](./quan_ly_sinh_vien.sql) (Bao gồm các bảng `Class`, `Student`, `Subject`, `Mark` với các ràng buộc `AUTO_INCREMENT`, `FOREIGN KEY`, `DEFAULT`, `CHECK`, `UNIQUE`).

---

## 📌 BÀI 2: TẠO BẢNG TRONG CSDL `QuanLyDiemThi` (SQL)
File mã nguồn: [`quan_ly_diem_thi.sql`](./quan_ly_diem_thi.sql) (Bao gồm các bảng `HocSinh`, `GiaoVien`, `MonHoc`, `BangDiem`).

---

## 📌 BÀI 1: THIẾT KẾ SƠ ĐỒ ERD QUẢN LÝ ĐƠN ĐẶT HÀNG & PHIẾU GIAO HÀNG
Hình ảnh sơ đồ ERD chuẩn hóa: [`erd_step5_simplified.jpg`](./erd_step5_simplified.jpg) & Giao diện tương tác: [`index.html`](./index.html).

---

## 🚀 LỆNH GIT ĐẨY BÀI LÊN GITHUB

```bash
cd "c:\Users\Admin\OneDrive\Desktop\công việc\BAI_TAP"

git add .
git commit -m "Hoan thanh bai thuc hanh Khung Hoang Tai Phong Kham HealthSync"
git push origin main
```
