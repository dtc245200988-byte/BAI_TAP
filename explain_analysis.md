# BÁO CÁO PHÂN TÍCH KẾ HOẠCH THỰC THI EXPLAIN (PAYFLOW)

**Dự án:** Ví điện tử PayFlow  
**Vai trò:** Database Performance Engineer

---

## 📌 PHẦN 1: BÁO CÁO SO SÁNH CHỈ SỐ EXPLAIN TRƯỚC VÀ SAU TỐI ƯU (< 200 TỪ)

Khi Kế toán chạy truy vấn báo cáo cũ sử dụng `YEAR(created_at)` và `MONTH(created_at)`, hàm bọc quanh cột làm câu lệnh rơi vào dạng **Non-SARGable**, vô hiệu hóa cơ sở dữ liệu:

| Chỉ số EXPLAIN | Trước tối ưu (Legacy) | Sau tối ưu (Refactored) | Ý nghĩa cải tiến |
|:---|:---|:---|:---|
| **`type`** | **`ALL`** (Full Table Scan) | **`range`** / **`ref`** | Loại bỏ hoàn toàn quét toàn bảng, chuyển sang tìm kiếm nhị phân B-Tree. |
| **`possible_keys`** | `NULL` | `idx_type_date` | Hệ thống đã nhận diện được Index khả thi. |
| **`key`** | `NULL` | `idx_type_date` | Chính thức sử dụng Composite Index `(transaction_type, created_at)`. |
| **`rows`** | 5,000,000 dòng (quét 100%) | Vài nghìn dòng (giảm > 99.9%) | Giảm thiểu I/O đĩa và CPU từ 45 giây xuống vài miligiây, hết treo server. |

---

## 🎯 PHẦN 2: BẢO VỆ GIẢI PHÁP & VẤN ĐÁP VỚI GIÁM ĐỐC CÔNG NGHỆ (CTO DEFENSE)

### Câu hỏi 1: Hãy trình bày thứ tự thực thi thực tế (Logical Execution Order) của các mệnh đề trong một câu lệnh SQL. Tại sao `WHERE` lại được chạy trước `SELECT`?
> **Trả lời:**  
> - **Thứ tự thực thi thực tế:** `FROM` $\rightarrow$ `ON` $\rightarrow$ `JOIN` $\rightarrow$ `WHERE` $\rightarrow$ `GROUP BY` $\rightarrow$ `HAVING` $\rightarrow$ `SELECT` $\rightarrow$ `DISTINCT` $\rightarrow$ `ORDER BY` $\rightarrow$ `LIMIT`.
> - **Lý do `WHERE` chạy trước `SELECT`:** Mệnh đề `WHERE` đóng vai trò lọc bộ dữ liệu thô ngay từ nguồn (`FROM`/`JOIN`) để giảm thiểu số lượng bản ghi cần xử lý. `SELECT` chỉ là bước chiếu (Projection) chọn và định dạng các cột hiển thị từ tập dữ liệu đã qua bộ lọc `WHERE`. Do đó, `WHERE` buộc phải chạy trước `SELECT` (và đó là lý do ta không thể dùng biệt danh `ALias` tạo ở `SELECT` ngay trong mệnh đề `WHERE`).

### Câu hỏi 2: Full Table Scan là gì? Trong trường hợp nào Full Table Scan lại chạy nhanh hơn Index Scan?
> **Trả lời:**  
> - **Full Table Scan:** Là hành vi Engine CSDL phải đọc lần lượt toàn bộ các khối dữ liệu (Data Blocks) từ đĩa cứng để kiểm tra từng dòng một.
> - **Khi nào Full Table Scan nhanh hơn Index Scan:** 
>   1. **Bảng có kích thước quá nhỏ:** Khi bảng chỉ có vài chục đến vài trăm dòng, việc đọc thẳng toàn bộ bảng bằng **Sequential I/O** (đọc tuần tự) nhanh hơn nhiều so với việc phải đọc Index B-Tree (Random I/O) rồi mới quay lại bảng chính (Bookmark Lookup/Table Access).
>   2. **Truy vấn lấy ra tỷ lệ dữ liệu quá lớn (> 20% - 30% tổng số dòng):** Khi truy vấn cần đọc hầu hết dữ liệu trong bảng, chi phí tra cứu B-Tree và nhảy đĩa ngẫu nhiên (Random I/O) sẽ cao hơn chi phí đọc tuần tự liên tục toàn bộ bảng.

### Câu hỏi 3: Nếu bảng `Transactions` bị thao tác INSERT/UPDATE/DELETE liên tục hàng nghìn lần mỗi giây, việc tạo thêm nhiều Index sẽ gây ra rủi ro gì cho hệ thống?
> **Trả lời:**  
> 1. **Giảm hiệu năng ghi (Write Amplification):** Mỗi khi có câu lệnh `INSERT`/`DELETE`/`UPDATE` làm thay đổi cột indexed, CSDL không chỉ ghi dữ liệu vào bảng chính mà còn phải cập nhật, sắp xếp lại tất cả các cây B-Tree Index tương ứng.
> 2. **Phân trang B-Tree (B-Tree Page Split) & Khóa hàng:** Quá trình cập nhật cây B-Tree gây ra hiện tượng tách trang (Page Split), tiêu tốn CPU, tăng dung lượng ghi đĩa I/O và tăng rủi ro tranh chấp khóa (Lock Contention/Deadlock).
> 3. **Tốn dung lượng bộ nhớ RAM (Buffer Pool Bloat):** Nhiều Index chiếm dụng diện tích RAM lớn trong InnoDB Buffer Pool, làm giảm dung lượng RAM dành cho việc cache các bảng dữ liệu nóng.
