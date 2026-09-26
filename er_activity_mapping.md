# BÁO CÁO PHÂN TÍCH ĐỐI CHIẾU ERD VÀ ACTIVITY DIAGRAM (AUTORIDE)

**Dự án:** Hệ thống Quản lý Thuê xe AutoRide  
**Vai trò:** Data Architect

---

## 📌 PHẦN 1: BÁO CÁO PHÂN TÍCH TÍNH TOÀN VẸN CỦA CỘT `damage_fee` (< 200 TỪ)

Trong quy trình "Thuê và Trả xe" (Activity Diagram), khi khách hàng trả xe bị trầy xước/hư hỏng, hệ thống bắt buộc phải ghi nhận chi phí đền bù. 

Cột `damage_fee` là **mắt xích bắt buộc** để đảm bảo tính toàn vẹn hệ thống và toàn vẹn tài chính:
1. **Bảo vệ dòng tiền doanh nghiệp:** Nếu thiếu `damage_fee`, công thức tính tiền hoàn lại ($\text{Refund} = \text{Deposit} - \text{Late Fee} - \text{Damage Fee}$) bị đứt gãy. Nhân viên buộc phải trả lại 100% tiền cọc dù xe vỡ đèn, gây thua lỗ trực tiếp cho phòng khám/startup.
2. **Minh bạch tài chính & Audit Trail:** `damage_fee` giúp lưu vết rõ ràng khoản tiền đền bù thu từ cọc, phục vụ đối soát kế toán và giải quyết tranh chấp với khách hàng.

---

## 🎯 PHẦN 2: BẢO VỆ THIẾT KẾ & VẤN ĐÁP GIÁM ĐỐC VẬN HÀNH (INTERVIEW DEFENSE)

### Câu hỏi 1: Tại sao việc tách dữ liệu kiểm tra xe ra một bảng riêng (`Inspections`) lại tốt hơn việc nhồi nhét một cột `damage_description` trực tiếp vào bảng `Rentals`?
> **Trả lời:**  
> 1. **Đáp ứng quan hệ 1-N (Chuẩn hóa CSDL):** Một hợp đồng thuê xe có thể phát sinh nhiều lần kiểm tra (Ví dụ: Kiểm tra lúc nhận xe, kiểm tra giữa chừng khi gặp sự cố, kiểm tra lúc trả xe). Nhồi nhét cột `damage_description` vào `Rentals` sẽ làm vi phạm Dạng chuẩn 1NF/2NF và không thể lưu vết lịch sử kiểm tra nhiều lần.
> 2. **Tối ưu hiệu năng & Quản lý vai trò:** Tách riêng bảng `Inspections` giúp bảng `Rentals` gọn nhẹ, đồng thời phân quyền rõ ràng: Nhân viên kỹ thuật chỉ thao tác trên bảng `Inspections` (ghi nhận hư hỏng, người kiểm tra), còn Thu ngân/Kế toán thao tác trên bảng `Rentals` (tính tiền, hoàn cọc).

### Câu hỏi 2: Nếu muốn quy định: Khi hợp đồng đang ở trạng thái `BOOKED` (khách chưa nhận xe) thì không ai được phép INSERT dữ liệu vào bảng `Inspections`. Em sẽ dùng cơ chế nào của Database để chặn điều này?
> **Trả lời:**  
> Em sử dụng cơ chế **Database Trigger (`BEFORE INSERT ON Inspections`)** ở tầng CSDL.  
> Trigger này sẽ truy vấn trạng thái `status` của hợp đồng trong bảng `Rentals`. Nếu `status = 'BOOKED'`, Trigger phát lỗi `SIGNAL SQLSTATE '45000'` kèm thông điệp báo lỗi và hủy bỏ thao tác `INSERT`. Cơ chế này đảm bảo quy tắc nghiệp vụ luôn được thực thi 100% dù truy vấn được gọi từ ứng dụng hay chèn trực tiếp bằng SQL.

### Câu hỏi 3: Sự thiếu đồng bộ giữa Activity Diagram do BA vẽ và ERD do Dev thiết kế thường dẫn đến những hậu quả gì về mặt trải nghiệm người dùng cuối trên ứng dụng?
> **Trả lời:**  
> 1. **Lỗi ứng dụng (Runtime Crash / UI Freeze):** Khi người dùng bấm nút "Xác nhận trả xe bị trầy xước", ứng dụng gọi API gửi `damage_fee` nhưng CSDL không có cột tương ứng, dẫn đến lỗi Server 500 hoặc treo ứng dụng.
> 2. **Trải nghiệm tiêu cực & Mất niềm tin:** Khách hàng không nhận được hóa đơn minh bạch chi tiết tiền phạt và cọc hoàn lại; nhân viên phải ghi sổ tay thủ công, gây phiền hà, kéo dài thời gian chờ đợi và gây tranh chấp.
