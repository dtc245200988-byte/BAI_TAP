# TỔNG HỢP BÀI TẬP CƠ SỞ DỮ LIỆU & SQL (DATABASE PORTFOLIO)

Repository lưu trữ toàn bộ các bài tập thực hành thiết kế mô hình ERD, chuyển đổi mô hình quan hệ, chuẩn hóa CSDL và lập trình SQL.

Link Repository GitHub: [https://github.com/dtc245200988-byte/BAI_TAP.git](https://github.com/dtc245200988-byte/BAI_TAP.git)

---

## 📌 BÀI 5: CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ

### 1. Phân tích chuyển đổi 4 bước:
- 📄 **`chuyen_doi_erd_report.md`**: Thuyết minh phân tích 4 bước (Xác định thực thể, mối quan hệ 1-N / N-N, chuyển đổi thuộc tính đa trị `SĐT` và liệt kê 9 bảng quan hệ).
- 💻 **`chuyen_doi_erd_sang_quan_he.sql`**: Mã SQL DDL tạo 9 bảng chuẩn hóa (`PHIEUXUAT`, `VATTU`, `PHIEUNHAP`, `NHACC`, `NHACC_SDT`, `DONDH`, `ChiTietPhieuXuat`, `ChiTietPhieuNhap`, `ChiTietDonDatHang`).

### 2. Danh sách 9 bảng sau khi chuyển đổi:
1. `PHIEUXUAT` ($\underline{\text{SoPX}}, \text{NgayXuat}$)
2. `VATTU` ($\underline{\text{MaVTU}}, \text{TenVTU}$)
3. `PHIEUNHAP` ($\underline{\text{SoPN}}, \text{NgayNhap}$)
4. `NHACC` ($\underline{\text{MaNCC}}, \text{TenNCC}, \text{DiaChi}$)
5. `NHACC_SDT` ($\underline{\text{MaNCC}}, \underline{\text{SDT}}$)
6. `DONDH` ($\underline{\text{SoDH}}, \text{NgayDH}, \text{MaNCC}$)
7. `ChiTietPhieuXuat` ($\underline{\text{SoPX}}, \underline{\text{MaVTU}}, \text{DGXuat}, \text{SLXuat}$)
8. `ChiTietPhieuNhap` ($\underline{\text{SoPN}}, \underline{\text{MaVTU}}, \text{DGNhap}, \text{SLNhap}$)
9. `ChiTietDonDatHang` ($\underline{\text{SoDH}}, \underline{\text{MaVTU}}$)

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
git commit -m "Hoan thanh bai tap Chuyen doi ERD sang mo hinh quan he"
git push origin main
```
