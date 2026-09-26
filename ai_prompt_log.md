# NHẬT KÝ TƯƠNG TÁC VÀ SỬ DỤNG AI (AI PROMPT LOG)

**Dự án:** Database Re-Engineering & Tuning Portfolio  
**Vai trò:** Data Architect & Data Engineer

---

## 📌 PHẦN A: DỰ ÁN HEALTHSYNC (PHÒNG KHÁM HEALTHSYNC)

### 1. Prompt về ENUM Lifecycle Status:
> "Trong thiết kế cơ sở dữ liệu quan hệ MySQL, tại sao việc dùng một cột `is_active` (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng hoặc Lịch hẹn lại là một thiết kế tồi (Anti-pattern)? Tôi nên thay thế bằng cấu trúc nào để phản ánh 5 trạng thái PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED?"

### 2. Prompt về Kiểu Dữ Liệu Tài Chính (`DECIMAL` vs `FLOAT`):
> "Khi thiết kế cột `deposit_amount` (tiền cọc) và `penalty_fee` (phí phạt) trong MySQL phục vụ tính toán tài chính và đối soát sổ sách, tôi nên dùng kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"

### 3. Prompt về Database Trigger:
> "Hãy viết cú pháp chuẩn trong MySQL để tạo một Trigger chặn việc chèn (INSERT) đơn thuốc vào bảng `Prescriptions` nếu lịch hẹn tương ứng trong bảng `Appointments` chưa ở trạng thái `COMPLETED`."

---

## 📌 PHẦN B: DỰ ÁN AUTORIDE (THUÊ XE TỰ LÁI AUTORIDE)

### 1. Prompt về Thiết kế Chuẩn hóa và Quan hệ 1-N cho Biên bản Kiểm tra xe:
> "Khi thiết kế bảng lưu trữ Biên bản kiểm tra tình trạng xe (Inspections) liên kết với Hợp đồng thuê xe (Rentals), việc tách thành bảng riêng (quan hệ 1-N) mang lại lợi ích gì so với việc thêm trực tiếp cột `damage_description` vào bảng Rentals?"

### 2. Prompt về Xử lý Giá trị NULL khi tính toán Tiền hoàn cọc:
> "Trong câu lệnh SQL SELECT tính toán tiền cọc hoàn lại: `security_deposit - late_fee - damage_fee`, nếu cột `late_fee` hoặc `damage_fee` bị NULL thì kết quả phép trừ sẽ bị NULL. Làm cách nào để xử lý an toàn bằng hàm `COALESCE` trong MySQL?"

### 3. Prompt về Trigger ngăn chặn tạo Biên bản cho hợp đồng BOOKED:
> "Hãy cho tôi xem ví dụ tạo Trigger trong MySQL chặn không cho phép INSERT vào bảng `Inspections` nếu hợp đồng thuê xe trong bảng `Rentals` có `status = 'BOOKED'`."

---

## 📌 PHẦN C: DỰ ÁN FLASHMART (TỐI ƯU TRUY VẤN JOIN & ANTI-JOIN)

### 1. Prompt về Sự khác biệt giữa `COUNT(*)` và `COUNT(column)` khi dùng `LEFT JOIN`:
> "Khi tôi sử dụng LEFT JOIN và đếm số lượng đơn hàng bằng hàm COUNT kết hợp GROUP BY, tôi nên dùng COUNT(*) hay COUNT(o.order_id)? Sự khác biệt khi kết quả bảng bên phải trả về NULL là gì?"

**Tóm tắt phản hồi & Ứng dụng:**
- **Giải thích:** `COUNT(*)` đếm tất cả các dòng kết quả (kể cả dòng chứa `NULL` ở bảng phải do `LEFT JOIN` sinh ra), dẫn đến kết quả bằng 1 thay vì 0. `COUNT(o.order_id)` chỉ đếm các giá trị không phải `NULL`, trả về đúng 0 cho khách hàng chưa từng mua hàng.
- **Ứng dụng:** Sửa câu truy vấn Báo cáo Marketing sử dụng `COUNT(o.order_id)`.

### 2. Prompt về Phân tích Hiệu năng Anti-Join (`LEFT JOIN ... WHERE IS NULL` vs `NOT IN` / `NOT EXISTS`):
> "Hãy phân tích hiệu năng (Performance) của việc dùng `LEFT JOIN` kết hợp `IS NULL` so with việc dùng subquery `NOT IN` hay `NOT EXISTS` khi muốn tìm kiếm các bản ghi không tồn tại trong bảng khác."

**Tóm tắt phản hồi & Ứng dụng:**
- **Giải thích:** Trong MySQL Optimizer, `LEFT JOIN ... WHERE IS NULL` và `NOT EXISTS` có thể được tối ưu hóa sử dụng thuật toán **Nested-Loop Join** với chỉ mục (Index) hiệu quả. Trong khi đó, `NOT IN` có thể gặp nguy cơ không dùng được Index nếu có chứa giá trị `NULL`.
- **Ứng dụng:** Sử dụng kỹ thuật Anti-Join `LEFT JOIN ... WHERE o.order_id IS NULL` cho Báo cáo Kho vận tìm sản phẩm ế.

### 3. Prompt về Thuật toán Tối ưu hóa JOIN trong MySQL:
> "Giải thích cách MySQL Optimizer tối ưu hóa các lệnh JOIN bằng thuật toán Nested-Loop Join và cách Index giúp tăng tốc độ truy vấn."

**Tóm tắt phản hồi & Ứng dụng:**
- Hiểu rõ cơ chế quét bảng Driving table và dùng Index lookup trên bảng thứ hai để tối ưu hóa truy vấn JOIN trên hệ thống thực tế.
