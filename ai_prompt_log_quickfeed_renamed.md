# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)

**Dự án:** Tối ưu hóa dung lượng Index hệ thống QuickFeed

### Prompt 1: Tác hại của việc lạm dụng Index trên các cột TEXT và BOOLEAN
> "Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (TEXT) và một cột kiểu BOOLEAN (0 và 1), thì điều này gây hại như thế nào đến bộ nhớ RAM, dung lượng Disk và bộ tối ưu hóa (Query Optimizer)?"

**Tóm tắt giải đáp từ AI:**
- **RAM và Disk:** Tạo B-Tree index cho văn bản cực kỳ ngốn dung lượng bộ nhớ. Thậm chí Index còn phình to hơn kích thước bảng thực tế. Khi đó Buffer Pool của InnoDB bị đầy bởi các trang Index vô giá trị, làm chậm quá trình cache.
- **Query Optimizer:** Cột Boolean chỉ chứa 2 giá trị. Khi độ phân giải dữ liệu (Cardinality) quá thấp (ví dụ: tìm tất cả `is_visible = 1` chiếm 90% số bài viết), Optimizer sẽ chọn **Full Table Scan** thay vì **Index Scan** vì đọc tuần tự nhanh hơn là quét Index rồi phải làm tra cứu ngược lại đĩa cứng.

### Prompt 2: Truy vấn thông tin dung lượng bảng
> "Hãy cho tôi xem truy vấn SQL sử dụng bảng information_schema.TABLES để in ra kích thước Data và kích thước Index của bảng 'Posts' tính theo đơn vị Megabyte (MB)."

**Tóm tắt giải đáp từ AI:**
AI cung cấp câu truy vấn SELECT lấy từ `data_length` và `index_length` của bảng `information_schema.TABLES` chia cho `1024 * 1024` để làm tròn ra dung lượng Megabyte. 

### Prompt 3: Giải pháp tìm kiếm thay thế cho cột TEXT
> "Nếu muốn tìm kiếm từ khóa bên trong cột content (kiểu TEXT) mà không bị tốn quá nhiều dung lượng như B-Tree Index, tôi nên sử dụng cơ chế nào của MySQL?"

**Tóm tắt giải đáp từ AI:**
Nên dùng cơ chế `FULLTEXT Index`. Khác với B-Tree lưu nguyên chuỗi hoặc một phần (prefix), FULLTEXT tạo một "Inverted Index" phân tách các từ khóa (tokens) và lưu trữ chúng, giúp tiết kiệm bộ nhớ và hỗ trợ tối ưu các thao tác tìm kiếm nội dung bằng mệnh đề `MATCH() ... AGAINST()`.
