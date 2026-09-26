# BÁO CÁO PHÂN TÍCH KỸ THUẬT SQL JOIN (FLASHMART)

**Dự án:** Sàn thương mại điện tử FlashMart  
**Vai trò:** Data Engineer

---

## 📌 PHẦN 1: BÁO CÁO GIẢI TRÌNH `COUNT(o.order_id)` VS `COUNT(*)` (< 150 TỪ)

Khi thực hiện `LEFT JOIN` giữa bảng `Customers` (bảng trái) và `Orders` (bảng phải) để thống kê số đơn hàng của từng khách hàng:

1. **`COUNT(*)` đếm số dòng (Row count):** Khi khách hàng Charlie chưa từng mua hàng, `LEFT JOIN` vẫn giữ lại dòng của Charlie và ghép với các giá trị `NULL` ở bảng `Orders`. `COUNT(*)` sẽ đếm dòng `NULL` này thành **1 đơn hàng**, dẫn đến kết quả sai lệch nghiêm trọng.
2. **`COUNT(o.order_id)` đếm giá trị phi NULL (Non-NULL count):** Hàm đếm theo cột cụ thể sẽ bỏ qua các giá trị `NULL`. Do đó, đối với dòng của Charlie có `o.order_id IS NULL`, `COUNT(o.order_id)` sẽ trả về **0 đơn hàng** hoàn toàn chuẩn xác.

---

## 🎯 PHẦN 2: BẢO VỆ LỰA CHỌN & VẤN ĐÁP VỚI GIÁM ĐỐC DỮ LIỆU (CDO DEFENSE)

### Câu hỏi 1: Giải thích sự khác biệt giữa `INNER JOIN` và `LEFT JOIN`. Nếu trong bài toán Marketing, anh vô tình viết `RIGHT JOIN` nhưng vẫn giữ nguyên thứ tự các bảng (`Customers RIGHT JOIN Orders`) thì chuyện gì sẽ xảy ra?
> **Trả lời:**  
> - **Khác biệt:** `INNER JOIN` chỉ trả về tập giao (kết quả trùng khớp ở cả 2 bảng). `LEFT JOIN` giữ lại **tất cả** bản ghi của bảng bên trái, dù không có bản ghi tương ứng ở bảng bên phải.
> - **Nếu dùng `RIGHT JOIN`:** Truy vấn `Customers RIGHT JOIN Orders` sẽ lấy bảng `Orders` làm bảng gốc (Driving table). Do đó, những khách hàng chưa mua hàng như Charlie (`order_id IS NULL`) sẽ **bị loại bỏ hoàn toàn khỏi báo cáo**, kết quả trả về hoàn toàn giống như `INNER JOIN`, thất bại trong việc tìm kiếm khách hàng tiềm năng để tặng Voucher.

### Câu hỏi 2: Trong câu lệnh lấy sản phẩm ế, tại sao điều kiện `WHERE o.order_id IS NULL` lại bắt buộc phải đi kèm với `LEFT JOIN`? Nếu đổi thành `INNER JOIN` thì mệnh đề `WHERE` đó có còn ý nghĩa không?
> **Trả lời:**  
> - Kỹ thuật này gọi là **Anti-Join**. `LEFT JOIN` giữ lại tất cả sản phẩm trong bảng `Products`, và với sản phẩm chưa từng bán (như Keyboard), trường `o.order_id` từ bảng `Orders` sẽ mang giá trị `NULL`. Mệnh đề `WHERE o.order_id IS NULL` giúp lọc ra chính xác các dòng mồ côi này.
> - **Nếu đổi thành `INNER JOIN`:** `INNER JOIN` đã tự động lọc bỏ mọi dòng có `NULL` ngay từ bước ghép bảng. Kết quả của `INNER JOIN` chỉ chứa các dòng có `o.order_id` hợp lệ, nên điều kiện `WHERE o.order_id IS NULL` trở nên mâu thuẫn và truy vấn sẽ trả về **0 kết quả (báo cáo trống trơn)**.

### Câu hỏi 3: `Cross Join` (Cartesian Product) là gì và khi nào một câu lệnh `JOIN` vô tình biến thành `Cross Join` gây treo hệ thống?
> **Trả lời:**  
> - **Cross Join (Tích Đề-các):** Là phép kết hợp mọi dòng của bảng A với mọi dòng của bảng B. Số dòng kết quả bằng $\text{Số dòng A} \times \text{Số dòng B}$.
> - **Nguyên nhân vô tình gây treo hệ thống:** Khi lập trình viên viết lệnh `JOIN` nhưng **bỏ quên mệnh đề `ON`** (hoặc điều kiện `ON` bị sai logic như `ON 1=1`), MySQL sẽ tự động thực thi `Cross Join`. Ví dụ bảng Customers có 1.000.000 dòng và bảng Orders có 10.000.000 dòng, truy vấn sẽ tạo ra $10^{13}$ dòng dữ liệu, tràn bộ nhớ RAM và làm tràn đĩa (I/O Bottleneck), gây treo hệ thống CSDL ngay lập tức.
