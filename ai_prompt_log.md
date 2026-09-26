# NHẬT KÝ TƯƠNG TÁC VÀ SỬ DỤNG AI (AI PROMPT LOG)

**Dự án:** HealthSync Database Re-Engineering  
**Vai trò:** System Analyst & Database Administrator

---

## 📌 PROMPT LOG 1: BẢO VỆ THIẾT KẾ VÒNG ĐỜI TRẠNG THÁI (LIFECYCLE STATUS)

### ❓ Prompt đầu vào:
> "Trong thiết kế cơ sở dữ liệu quan hệ MySQL, tại sao việc dùng một cột `is_active` (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng hoặc Lịch hẹn lại là một thiết kế tồi (Anti-pattern)? Tôi nên thay thế bằng cấu trúc nào để phản ánh 5 trạng thái PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED?"

### 💡 Tóm tắt phản hồi từ AI & Ứng dụng vào bài tập:
- **Tác hại của `BOOLEAN`:** Kiểu `BOOLEAN` chỉ đại diện cho 2 trạng thái nhị phân (Đúng/Sai). Khi quy trình có từ 3 trạng thái trở lên, `BOOLEAN` buộc nhà phát triển phải tạo thêm nhiều cột cờ (flags) như `is_confirmed`, `is_checked_in`, `is_completed`, gây bùng nổ số cột và tạo ra các trạng thái xung đột phi logic (Ví dụ: vừa `is_completed = TRUE` vừa `is_cancelled = TRUE`).
- **Giải pháp áp dụng:** Thay thế bằng kiểu `ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')` trong bảng `Appointments`, vừa tiết kiệm bộ nhớ vừa đảm bảo tính toàn vẹn trạng thái.

---

## 📌 PROMPT LOG 2: LỰA CHỌN KIỂU DỮ LIỆU TÀI CHÍNH (`FLOAT` vs `DECIMAL`)

### ❓ Prompt đầu vào:
> "Khi thiết kế cột `deposit_amount` (tiền cọc) và `penalty_fee` (phí phạt) trong MySQL phục vụ tính toán tài chính và đối soát sổ sách, tôi nên dùng kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"

### 💡 Tóm tắt phản hồi từ AI & Ứng dụng vào bài tập:
- **Rủi ro sai số số thực (`FLOAT`/`DOUBLE`):** `FLOAT` và `DOUBLE` sử dụng biểu diễn dấu chấm động nhị phân (Binary Floating-Point), dẫn đến lỗi sai số làm tròn khi thực hiện các phép cộng/trừ số tiền (Ví dụ: `0.1 + 0.2 = 0.30000000000000004`).
- **Ưu điểm của `DECIMAL`:** Kiểu `DECIMAL(p, s)` lưu trữ dữ liệu dưới dạng số thập phân chính xác tuyệt đối (Exact Numeric Data Type).
- **Giải pháp áp dụng:** Sử dụng `DECIMAL(10,2)` cho `deposit_amount` và `penalty_fee` để hỗ trợ lưu trữ số tiền lên đến 99,999,999.99 VNĐ mà không xảy ra sai số tài chính.

---

## 📌 PROMPT LOG 3: BẢO VỆ TẦNG CSDL BẰNG DATABASE TRIGGER

### ❓ Prompt đầu vào:
> "Hãy viết cú pháp chuẩn trong MySQL để tạo một Trigger chặn việc chèn (INSERT) đơn thuốc vào bảng `Prescriptions` nếu lịch hẹn tương ứng trong bảng `Appointments` chưa ở trạng thái `COMPLETED`."

### 💡 Tóm tắt phản hồi từ AI & Ứng dụng vào bài tập:
- **Nguyên lý Trigger:** Sử dụng `BEFORE INSERT ON Prescriptions`, khai báo biến cục bộ kiểm tra `status` của lịch hẹn. Nếu `status != 'COMPLETED'`, gọi hàm `SIGNAL SQLSTATE '45000'` để hủy giao dịch và thông báo lỗi.
- **Giải pháp áp dụng:** Đã cài đặt thành công Trigger `trg_prevent_invalid_prescription` trong mã SQL `healthsync_db.sql`.
