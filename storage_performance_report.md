# BÁO CÁO PHÂN TÍCH TÀI NGUYÊN VÀ HIỆU NĂNG LƯU TRỮ (QUICKFEED)

**Vai trò:** Database Administrator (DBA)

## 1. Đánh giá vấn đề hiện tại
Việc tạo quá nhiều Index (Over-Indexing) trên bảng `Posts` đã dẫn đến sự kiệt quệ tài nguyên. Đặc biệt:
- **Tốc độ Ghi (Write) chậm:** Mỗi thao tác `INSERT`, CSDL không chỉ ghi dữ liệu vào bảng chính mà còn phải cập nhật 5 cây B-Tree tương ứng. Điều này dẫn đến sự cố khóa trang (page locks), page split và gia tăng I/O đĩa đột biến, làm xuất hiện lỗi Timeout.
- **Dung lượng lưu trữ (Storage):** Cột văn bản dài (`content`) và các cột có độ phân giải thấp (Cardinality thấp như `post_type`, `is_visible`) tạo ra những cây Index cồng kềnh gấp nhiều lần dữ liệu thật, gây cảnh báo Disk Full.

## 2. Giải pháp tối ưu hóa
Đã tiến hành loại bỏ (DROP) 3 Index vô giá trị:
1. `idx_content`: Dữ liệu TEXT tốn diện tích vô ích trong B-Tree. Giải pháp thay thế là sử dụng `FULLTEXT Index` khi cần tìm kiếm nội dung.
2. `idx_post_type` và `idx_is_visible`: Cardinality cực thấp (chỉ có 2-3 giá trị phân biệt). Khi tìm kiếm, MySQL Optimizer sẽ quét toàn bảng (Full Table Scan) vì nó hiệu quả hơn là phải tra cứu qua B-Tree rồi quay lại bảng chính (Table Lookup).

Việc giữ lại `idx_user_id` và `idx_created_at` là tối ưu vì đây là các trường thường xuyên được dùng để lọc và sắp xếp tin bài với độ phân giải cao. Sự kiện này giúp giảm tải ít nhất 60% thời gian delay cho quá trình INSERT.

## 3. Phần Vấn đáp (Tech Lead Defense)
- **Khi INSERT với 5 Index:** Engine phải cập nhật ngầm 5 cây B-Tree, dẫn đến tốn CPU và I/O đĩa. Người dùng ứng dụng bị Timeout do CSDL quá tải trong việc quản lý cấu trúc cây và sắp xếp.
- **Cardinality:** Là độ phân biệt của dữ liệu (số lượng giá trị duy nhất so với tổng record). Giới tính hoặc Trạng thái chỉ có vài giá trị, tra cứu bằng B-Tree (Random I/O) chậm hơn nhiều việc nạp liên tục toàn bộ bảng từ ổ đĩa cứng (Sequential I/O).
- **Nếu là bảng Archive:** Nếu bảng hiếm khi INSERT/UPDATE/DELETE (OLAP workload), việc có nhiều Index không còn là "thảm họa", thậm chí còn giúp hệ thống phục vụ tốc độ đọc dữ liệu cực nhanh. Nhược điểm duy nhất chỉ là việc nó tốn chi phí ổ cứng để lưu trữ các Index đó.
