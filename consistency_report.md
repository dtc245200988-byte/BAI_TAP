# BÁO CÁO CHẨN ĐOÁN CẢI TIẾN CƠ SỞ DỮ LIỆU HEALTHSYNC (GAP ANALYSIS REPORT)

**Dự án:** Hệ thống Quản lý Khám bệnh HealthSync  
**Tác giả:** System Analyst & Database Administrator  
**Mục tiêu:** Phân tích sự bất nhất giữa UML Activity Diagram của BA và Legacy Database, đề xuất mô hình tái cấu trúc tối ưu.

---

## 🛠️ PHẦN 1: BÁO CÁO PHÂN TÍCH LỖ HỔNG DỮ LIỆU (GAP ANALYSIS - TRÊN 200 TỪ)

Sau khi rà soát lưu đồ hoạt động (UML Activity Diagram) do Chuyên viên Phân tích Nghiệp vụ (BA) xây dựng cho quy trình "Đặt lịch và Khám bệnh" tại phòng khám HealthSync, đối chiếu với cơ sở dữ liệu MySQL legacy do Lập trình viên Backend thiết kế ban đầu, chúng tôi phát hiện **4 lỗ hổng nghiêm trọng (Data Gaps)** khiến hệ thống liên tục phát sinh lỗi trong quá trình thử nghiệm:

### 1. Dùng cột `BOOLEAN (is_active)` biểu diễn quy trình đa trạng thái (Anti-Pattern)
- **Thực trạng cũ:** Cột `is_active` kiểu `BOOLEAN` chỉ có 2 giá trị (`TRUE`/`FALSE`), hoàn toàn không thể thể hiện được vòng đời 5 bước phức tạp của lịch hẹn: `PENDING` (Chờ duyệt) $\rightarrow$ `CONFIRMED` (Đã cọc) $\rightarrow$ `CHECKED_IN` (Đã đến) $\rightarrow$ `COMPLETED` (Khám xong) hoặc `CANCELLED` (Đã hủy).
- **Giải pháp:** Loại bỏ `is_active`, thay thế bằng kiểu dữ liệu `ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')` để quản lý chặt chẽ trạng thái chuyển đổi.

### 2. Thiếu hụt hoàn toàn các cột theo dõi tài chính (`deposit_amount`, `penalty_fee`)
- **Thực trạng cũ:** Bảng `Appointments` cũ hoàn toàn không lưu tiền đặt cọc và phí phạt hủy lịch. Khi bệnh nhân hủy lịch sau khi đã `CONFIRMED`, hệ thống không có dữ liệu để khấu trừ phí phạt từ tiền cọc.
- **Giải pháp:** Bổ sung cột `deposit_amount DECIMAL(10,2)` và `penalty_fee DECIMAL(10,2)`. Sử dụng kiểu `DECIMAL` thay vì `FLOAT/DOUBLE` nhằm tránh lỗi sai số làm tròn số thực trong giao dịch tài chính.

### 3. Thiếu cột ghi nhận lý do hủy lịch (`cancel_reason`)
- **Thực trạng cũ:** Khi bệnh nhân hoặc phòng khám hủy lịch, thông tin lý do bị thất thoát hoàn toàn, gây khó khăn cho việc chăm sóc khách hàng và đối soát tranh chấp.
- **Giải pháp:** Bổ sung cột `cancel_reason VARCHAR(255)` để lưu trữ nguyên nhân hủy.

### 4. Vắng mặt hoàn toàn thực thể Đơn thuốc (`Prescriptions`)
- **Thực trạng cũ:** Bác sĩ khám xong (`COMPLETED`) không thể kê đơn thuốc do cơ sở dữ liệu không có bảng lưu trữ đơn thuốc liên kết với lịch hẹn.
- **Giải pháp:** Tạo bảng mới `Prescriptions` chứa `prescription_id`, `appointment_id` (Foreign Key), `medication_details` và `issued_date`.

---

## 🎯 PHẦN 2: BẢO VỆ THIẾT KẾ & VẤN ĐÁP GIẢNG VIÊN (INTERVIEW DEFENSE)

### Câu hỏi 1: Dựa vào ERD hiện tại, nếu một lịch hẹn đang ở trạng thái `PENDING` (chưa khám), nhưng có người cố tình chèn (INSERT) một đơn thuốc vào bảng `Prescriptions`, làm thế nào để chặn hành động phi logic này ở tầng CSDL?
> **Trả lời:**  
> Ràng buộc khóa ngoại (Foreign Key) thông thường chỉ đảm bảo `appointment_id` tồn tại, chứ không thể kiểm tra được **trạng thái logic** của lịch hẹn đó. Để ngăn chặn hoàn toàn ở tầng CSDL (đảm bảo tính toàn vẹn hệ thống độc lập với code backend), em sử dụng **Database Trigger (`BEFORE INSERT ON Prescriptions`)**.  
> Trigger này sẽ truy vấn cột `status` của lịch hẹn tương ứng trong bảng `Appointments`. Nếu `status != 'COMPLETED'`, Trigger sẽ chủ động phát lỗi `SIGNAL SQLSTATE '45000'` với thông điệp cảnh báo và hủy bỏ giao dịch INSERT ngay lập tức.

### Câu hỏi 2: Tại sao việc lưu `penalty_fee` lại quan trọng đối với tính toàn vẹn hệ thống? Nếu kế toán muốn đối soát doanh thu cuối tháng, sự thiếu hụt cột này trong bản thiết kế cũ sẽ gây ra hậu quả gì?
> **Trả lời:**  
> `penalty_fee` phản ánh khoản thu nhập thực tế của phòng khám giữ lại từ tiền đặt cọc của bệnh nhân khi họ vi phạm quy định hủy lịch.  
> Nếu thiếu cột `penalty_fee`:
> 1. **Mất cân đối sổ sách tài chính:** Kế toán chỉ biết bệnh nhân đã cọc 300.000đ và hủy lịch, nhưng không thể biết phòng khám đã thu phạt 150.000đ hay hoàn lại 100%.
> 2. **Rủi ro thất thoát doanh thu:** Không thể tính toán dòng tiền ròng ($\text{Tiền cọc hoàn lại} = \text{Tiền cọc} - \text{Phí phạt}$). Dẫn đến báo cáo doanh thu cuối tháng bị sai lệch nghiêm trọng, gây thất thoát tài sản hoặc tranh chấp với khách hàng mà không có vết dữ liệu (Audit Trail) để đối soát.

### Câu hỏi 3: Sự nhất quán (Consistency) giữa UML Activity Diagram và ERD đóng vai trò gì trong việc chuyển giao công việc giữa bộ phận Phân tích (BA) và bộ phận Lập trình (Dev)?
> **Trả lời:**  
> UML Activity Diagram đại diện cho **luồng nghiệp vụ thực tế (Behavioral Model)**, còn ERD đại diện cho **cấu trúc dữ liệu tĩnh (Structural Model)**.
> - **Ngăn ngừa lỗi "Vênh" hệ thống:** Nếu ERD không phản ánh đúng các trạng thái và dữ liệu phát sinh trong Activity Diagram, Dev sẽ không có chỗ lưu dữ liệu khi viết code, dẫn đến lỗi runtime hàng loạt như sự cố tại HealthSync.
> - **Tiêu chuẩn giao tiếp chung:** Sự nhất quán tạo ra một ngôn ngữ chung giúp Dev triển khai đúng và đủ 100% yêu cầu của BA mà không phải tự "đoán" hay bỏ sót nghiệp vụ.
