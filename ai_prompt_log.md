# NHẬT KÝ TƯƠNG TÁC VÀ SỬ DỤNG AI (AI PROMPT LOG)

**Dự án:** Database Re-Engineering & Tuning Portfolio  
**Vai trò:** Data Architect & Database Administrator

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

**Tóm tắt phản hồi & Ứng dụng:**
- **Lợi ích chuẩn hóa (Normalization):** Một hợp đồng thuê xe có thể có nhiều đợt kiểm tra (bàn giao xe đầu ca, kiểm tra sự cố dọc đường, kiểm tra khi trả xe). Tách thành bảng `Inspections` đảm bảo tuân thủ Dạng chuẩn (1NF/2NF/3NF).
- **Ứng dụng:** Thiết kế bảng `Inspections` độc lập với khóa ngoại `rental_id` trỏ về `Rentals(rental_id)`.

### 2. Prompt về Xử lý Giá trị NULL khi tính toán Tiền hoàn cọc:
> "Trong câu lệnh SQL SELECT tính toán tiền cọc hoàn lại: `security_deposit - late_fee - damage_fee`, nếu cột `late_fee` hoặc `damage_fee` bị NULL thì kết quả phép trừ sẽ bị NULL. Làm cách nào để xử lý an toàn bằng hàm `COALESCE` trong MySQL?"

**Tóm tắt phản hồi & Ứng dụng:**
- **Hàm `COALESCE`:** Sử dụng `COALESCE(late_fee, 0.00)` và `COALESCE(damage_fee, 0.00)` để ép giá trị NULL về `0.00`, giúp phép tính `security_deposit - COALESCE(late_fee, 0.00) - COALESCE(damage_fee, 0.00)` luôn trả về kết quả chính xác tuyệt đối.

### 3. Prompt về Trigger ngăn chặn tạo Biên bản cho hợp đồng BOOKED:
> "Hãy cho tôi xem ví dụ tạo Trigger trong MySQL chặn không cho phép INSERT vào bảng `Inspections` nếu hợp đồng thuê xe trong bảng `Rentals` có `status = 'BOOKED'`."

**Tóm tắt phản hồi & Ứng dụng:**
- Đã cài đặt Trigger `trg_prevent_invalid_inspection` trong `autoride_db.sql` phát lỗi `SIGNAL SQLSTATE '45000'` nếu vi phạm quy tắc nghiệp vụ.
