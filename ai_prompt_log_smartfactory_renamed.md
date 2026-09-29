# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)

**Dự án:** Tối ưu hóa Fat Index - SmartFactory

### Prompt 1: Covering Index là gì?
> "Covering Index (Chỉ mục bao phủ) trong MySQL là gì và tại sao nó làm tăng tốc độ lệnh SELECT lên mức tối đa?"

**Tóm tắt giải đáp từ AI:**
- **Khái niệm:** Covering Index là một Secondary Index (Chỉ mục phụ) mà cấu trúc B-Tree của nó đã chứa đựng *toàn bộ* các cột được yêu cầu trong truy vấn (cả mệnh đề SELECT, WHERE, ORDER BY, GROUP BY).
- **Tốc độ:** Vì mọi thông tin cần thiết đều nằm trên Index, MySQL không cần thực hiện thao tác Bookmark Lookup (nhảy từ Secondary Index về Clustered Index để lấy thêm cột). Từ đó loại bỏ hoàn toàn Random I/O trên bảng chính, mang lại tốc độ cực nhanh (hiển thị `Using index` trong EXPLAIN).

### Prompt 2: Tổ chức Clustered vs Secondary Index
> "Hãy giải thích sự khác biệt cơ bản giữa cách phân bổ dữ liệu trên Clustered Index và Secondary Index trong InnoDB."

**Tóm tắt giải đáp từ AI:**
- **Clustered Index:** Trong InnoDB, mỗi bảng chỉ có một Clustered Index (thường là Primary Key). Các Leaf Node của cây Clustered Index chứa toàn bộ dữ liệu thực (tất cả các cột) của hàng đó.
- **Secondary Index:** Cấu trúc này không chứa toàn bộ dữ liệu. Các Leaf Node của Secondary Index chỉ chứa giá trị của cột được lập chỉ mục và con trỏ (giá trị của Primary Key) trỏ về Clustered Index. Điều này dẫn đến thao tác Lookup nếu các cột trong phần SELECT không nằm trong Secondary Index.

### Prompt 3: Tính toán Byte size của Index
> "Trong MySQL InnoDB, làm thế nào để tính toán chi phí dung lượng tĩnh khi ta thêm cột DECIMAL(5,2) và VARCHAR(20) utf8mb4 vào một Composite Index?"

**Tóm tắt giải đáp từ AI:**
- `DECIMAL(5,2)`: Cần khoảng 3 bytes để lưu trữ.
- `VARCHAR(20)` với charset `utf8mb4`: Cần 20 * 4 = 80 bytes (tối đa), cộng thêm 1 byte cho length prefix. Tổng là khoảng 81 bytes.
- Việc nhét chúng vào Index trên 10 triệu bản ghi nghĩa là bạn đang "copy" gần 85 bytes dữ liệu mỗi bản ghi sang một không gian B-Tree riêng biệt, tiêu thụ cỡ `10,000,000 * 85 bytes ≈ 850 MB` chỉ cho riêng Index Length (chưa kể cấu trúc Tree Overhead).
