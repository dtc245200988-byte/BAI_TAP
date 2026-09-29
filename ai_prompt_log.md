# NHẬT KÝ TƯƠNG TÁC VÀ SỬ DỤNG AI (AI PROMPT LOG)

**Dự án:** Database Re-Engineering & Tuning Portfolio  
**Vai trò:** Data Architect & Database Performance Engineer

---

## 📌 PHẦN A: DỰ ÁN HEALTHSYNC (PHÒNG KHÁM HEALTHSYNC)
- **ENUM Status & Financial Data Types**: Thảo luận `ENUM` và `DECIMAL(10,2)`.
- **Database Trigger**: Viết Trigger chặn chèn đơn thuốc phi logic.

---

## 📌 PHẦN B: DỰ ÁN AUTORIDE (THUÊ XE TỰ LÁI AUTORIDE)
- **Chuẩn hóa 1-N Inspections**: Thảo luận lý do tách bảng biên bản kiểm tra xe.
- **Xử lý NULL bằng COALESCE**: Tính toán `security_deposit - COALESCE(late_fee, 0) - COALESCE(damage_fee, 0)`.

---

## 📌 PHẦN C: DỰ ÁN FLASHMART (TỐI ƯU TRUY VẤN JOIN & ANTI-JOIN)
- **`COUNT(*)` vs `COUNT(column)`**: Thảo luận đếm số dòng chứa `NULL` trên `LEFT JOIN`.
- **Anti-Join `WHERE IS NULL`**: Tìm kiếm sản phẩm ế không qua giao dịch.

---

## 📌 PHẦN D: DỰ ÁN PAYFLOW (TỐI ƯU TRUY VẤN SQL & B-TREE INDEX)

### 1. Prompt về Truy vấn Non-SARGable và Tác hại của Hàm bọc cột:
> "Trong MySQL, nếu tôi tạo Index cho một cột ngày tháng `created_at`, nhưng trong mệnh đề WHERE tôi lại viết `WHERE YEAR(created_at) = 2026 AND MONTH(created_at) = 6`, tại sao MySQL lại từ chối sử dụng Index và phải quét toàn bộ bảng (Full Table Scan)?"

**Tóm tắt phản hồi & Ứng dụng:**
- **Giải thích:** Cấu trúc B-Tree lưu trữ các giá trị thời gian thô đã được sắp xếp. Khi bọc hàm `YEAR()` hoặc `MONTH()` quanh cột, Engine không thể tính trước giá trị trả về của hàm cho từng nút B-Tree mà buộc phải duyệt qua từng dòng dữ liệu để tính kết quả hàm, làm vô hiệu hóa khả năng tìm kiếm nhị phân (Index Seek).
- **Ứng dụng:** Chuyển đổi điều kiện sang dạng Range SARGable: `created_at >= '2026-06-01 00:00:00' AND created_at < '2026-07-01 00:00:00'`.

### 2. Prompt về Thứ tự Cột trong Composite Index:
> "Khi thiết kế một Composite Index trong MySQL cho cột (transaction_type, created_at), thứ tự các cột trong Index có quan trọng không? Tôi nên đặt cột nào đứng trước để có hiệu suất lọc dữ liệu (Selectivity) tốt nhất?"

**Tóm tắt phản hồi & Ứng dụng:**
- **Quy tắc Leftmost Prefix:** Luôn đặt cột so sánh bằng (Equality `- transaction_type`) đứng trước, cột so sánh khoảng (Range `- created_at`) đứng sau.
- **Ứng dụng:** Khai báo `CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);`.

### 3. Prompt về Phân biệt `Using index condition` vs `Using index` trong EXPLAIN:
> "Trong kết quả EXPLAIN, cột Extra hiện chữ 'Using index condition' khác gì với 'Using index' (Covering Index)?"

**Tóm tắt phản hồi & Ứng dụng:**
- **`Using index` (Covering Index):** Tất cả các cột trong `SELECT` (bao gồm `WHERE` và `SELECT list`) đều nằm trọn trong Index, không cần phải đọc bảng chính (Bookmark Lookup).
- **`Using index condition` (Index Condition Pushdown - ICP):** Engine đẩy điều kiện lọc xuống tầng Storage Engine kiểm tra trên Index trước khi nạp toàn bộ dòng dữ liệu chính.

### 4. Prompt về Xem thời gian thực thi với `SET profiling = 1`:
> "Làm thế nào để tôi có thể xem được chi tiết thời gian thực thi (Execution Time) của một câu lệnh SQL thay vì chỉ xem Execution Plan trong MySQL?"

**Tóm tắt phản hồi & Ứng dụng:**
- Sử dụng `SET profiling = 1;` chạy câu lệnh và dùng `SHOW PROFILES;` để xem chi tiết thời gian tiêu tốn ở từng bước (Sending data, Sorting, Executing).
