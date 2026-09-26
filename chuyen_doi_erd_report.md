# BÁO CÁO CHUYỂN ĐỔI SƠ ĐỒ ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ

**Dự án:** Quản Lý Vật Tư & Đơn Đặt Hàng  
**Mục tiêu:** Chuyển đổi sơ đồ ERD cho trước sang Mô hình Dữ liệu Quan hệ (Relational Database Schema) qua 4 bước phân tích tiêu chuẩn.

---

## 📌 BƯỚC 1: XÁC ĐỊNH CÁC THỰC THỂ TRONG MÔ HÌNH ERD

Dựa trên sơ đồ ERD cho trước, ta trích xuất được **5 thực thể chính** và các thuộc tính đơn tương ứng:

1. **Thực thể `PHIEUXUAT`**:
   - `SoPX` (Khóa chính - Underline)
   - `NgayXuat`
2. **Thực thể `VATTU`**:
   - `MaVTU` (Khóa chính - Underline)
   - `TenVTU`
3. **Thực thể `PHIEUNHAP`**:
   - `SoPN` (Khóa chính - Underline)
   - `NgayNhap`
4. **Thực thể `DONDH`** (Đơn đặt hàng):
   - `SoDH` (Khóa chính - Underline)
   - `NgayDH`
5. **Thực thể `NHACC`** (Nhà cung cấp):
   - `MaNCC` (Khóa chính - Underline)
   - `TenNCC`
   - `DiaChi`
   - `SĐT` (Thuộc tính đa trị - Elip viền đôi)

---

## 📌 BƯỚC 2: XÁC ĐỊNH CÁC MỐI QUAN HỆ VÀ SINH CÁC BẢNG / TRƯỜNG TƯƠNG ỨNG

### 1. Quan hệ 1 - N (1 Nhà cung cấp Cung cấp N Đơn đặt hàng):
- **Mối quan hệ 4 (`Cung cấp`):** Kết nối thực thể `NHACC` (bên 1) và `DONDH` (bên N).
- **Quy tắc chuyển đổi:** Đưa khóa chính `MaNCC` của `NHACC` sang làm **Khóa ngoại (Foreign Key - FK)** trong bảng `DONDH`.
- **Kết quả:** Bảng `DONDH` có trường `MaNCC` (FK).

### 2. Quan hệ N - N (Nhiều - Nhiều):
Các quan hệ N - N sẽ sinh ra **bảng mới** với khóa chính phức hợp kết hợp từ khóa chính của 2 thực thể tham gia:

- **Mối quan hệ 1 (`Chi tiết phiếu xuất`):** Giữa `PHIEUXUAT` (N) và `VATTU` (N).
  - Có các thuộc tính mối quan hệ: `DGXuat`, `SLXuat`.
  - **Sinh ra bảng mới:** `ChiTietPhieuXuat` ($\underline{\text{SoPX}}, \underline{\text{MaVTU}}, \text{DGXuat}, \text{SLXuat}$).
  - Khóa chính: `(SoPX, MaVTU)`. Khóa ngoại: `SoPX` $\rightarrow$ `PHIEUXUAT(SoPX)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`.

- **Mối quan hệ 2 (`Chi tiết phiếu nhập`):** Giữa `PHIEUNHAP` (N) và `VATTU` (N).
  - Có các thuộc tính mối quan hệ: `DGNhap`, `SLNhap`.
  - **Sinh ra bảng mới:** `ChiTietPhieuNhap` ($\underline{\text{SoPN}}, \underline{\text{MaVTU}}, \text{DGNhap}, \text{SLNhap}$).
  - Khóa chính: `(SoPN, MaVTU)`. Khóa ngoại: `SoPN` $\rightarrow$ `PHIEUNHAP(SoPN)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`.

- **Mối quan hệ 3 (`Chi tiết đơn đặt hàng`):** Giữa `DONDH` (N) và `VATTU` (N).
  - **Sinh ra bảng mới:** `ChiTietDonDatHang` ($\underline{\text{SoDH}}, \underline{\text{MaVTU}}$).
  - Khóa chính: `(SoDH, MaVTU)`. Khóa ngoại: `SoDH` $\rightarrow$ `DONDH(SoDH)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`.

---

## 📌 BƯỚC 3: XÁC ĐỊNH THUỘC TÍNH ĐA TRỊ VÀ TẠO BẢNG MỚI

- **Thuộc tính đa trị:** Trong thực thể `NHACC`, thuộc tính `SĐT` (Số điện thoại) là thuộc tính đa trị (vẽ hình oval viền đôi), thể hiện một nhà cung cấp có thể có nhiều số điện thoại liên lạc.
- **Quy tắc chuyển đổi:** Tách thuộc tính `SĐT` thành **1 bảng riêng biệt** tên là `NHACC_SDT`.
- **Cấu trúc bảng mới:** `NHACC_SDT` ($\underline{\text{MaNCC}}, \underline{\text{SDT}}$).
  - Khóa chính phức hợp: `(MaNCC, SDT)`.
  - Khóa ngoại: `MaNCC` $\rightarrow$ `NHACC(MaNCC)`.

---

## 📌 BƯỚC 4: DANH SÁCH CÁC BẢNG QUAN HỆ SAU KHI CHUYỂN ĐỔI HOÀN CHỈNH

Sau khi thực hiện đầy đủ 4 bước chuẩn hóa, mô hình ERD được chuyển đổi thành **9 bảng quan hệ** như sau:

1. **`PHIEUXUAT`** ($\underline{\text{SoPX}}, \text{NgayXuat}$)
2. **`VATTU`** ($\underline{\text{MaVTU}}, \text{TenVTU}$)
3. **`PHIEUNHAP`** ($\underline{\text{SoPN}}, \text{NgayNhap}$)
4. **`NHACC`** ($\underline{\text{MaNCC}}, \text{TenNCC}, \text{DiaChi}$)
5. **`NHACC_SDT`** ($\underline{\text{MaNCC}}, \underline{\text{SDT}}$) *(FK: `MaNCC` $\rightarrow$ `NHACC(MaNCC)`)*
6. **`DONDH`** ($\underline{\text{SoDH}}, \text{NgayDH}, \text{MaNCC}$) *(FK: `MaNCC` $\rightarrow$ `NHACC(MaNCC)`)*
7. **`ChiTietPhieuXuat`** ($\underline{\text{SoPX}}, \underline{\text{MaVTU}}, \text{DGXuat}, \text{SLXuat}$) *(FK: `SoPX` $\rightarrow$ `PHIEUXUAT(SoPX)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`)*
8. **`ChiTietPhieuNhap`** ($\underline{\text{SoPN}}, \underline{\text{MaVTU}}, \text{DGNhap}, \text{SLNhap}$) *(FK: `SoPN` $\rightarrow$ `PHIEUNHAP(SoPN)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`)*
9. **`ChiTietDonDatHang`** ($\underline{\text{SoDH}}, \underline{\text{MaVTU}}$) *(FK: `SoDH` $\rightarrow$ `DONDH(SoDH)`, `MaVTU` $\rightarrow$ `VATTU(MaVTU)`)*
