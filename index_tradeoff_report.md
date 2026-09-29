# BÁO CÁO ĐÁNH GIÁ SỰ ĐÁNH ĐỔI (TRADE-OFF) TỐI ƯU HÓA INDEX

**Vai trò:** Database Optimization Expert

## 1. Tại sao chấp nhận đánh đổi?
- **Nguyên nhân hệ thống kiệt quệ:** Việc nhét toàn bộ các cột liên tục biến động (`temperature`, `humidity`, `status`) vào `idx_fat_covering` đã tạo ra hiện tượng **Write Penalty** cực lớn. Mỗi giây có hàng chục nghìn thao tác INSERT từ cảm biến đẩy vào, MySQL phải tái cấu trúc lại một lượng lớn dữ liệu trong cây B-Tree của Index này, gây thắt cổ chai luồng Ghi và làm phình to bộ nhớ (Disk Space).
- **Giải pháp Lean Index:** Chúng tôi đã thay thế "Fat Index" bằng `idx_lean_search` chỉ chứa `(sensor_id, recorded_at)` để phục vụ cho thao tác lộc dữ liệu (WHERE).
- **Sự đánh đổi (Trade-off):** Việc làm này sẽ khiến lệnh SELECT của Dashboard mất đi "Covering Index" (Chữ `Using index` biến mất trong EXPLAIN) vì hệ thống phải truy vấn ngược từ cây B-Tree về bảng gốc để lấy các thông số vật lý (Lookup Table). Tốc độ đọc sẽ tăng độ trễ lên khoảng một phần nghìn giây. Tuy nhiên, nó đổi lại việc giải cứu hàng chục GB dung lượng lưu trữ và trả lại tốc độ tối đa cho luồng ghi dữ liệu IoT khổng lồ.

## 2. Vấn đáp (Cloud Financial Controller Defense)
- **Truy vấn danh mục (Ví dụ bảng Countries):** Nếu dữ liệu ít khi cập nhật (hiếm khi INSERT/UPDATE), việc tạo Covering Index không còn là "tội ác" vì không phải gánh Write Penalty. Lúc này, tốc độ Read được tối ưu hóa tối đa mà không gây nghẽn cổ chai hệ thống Ghi.
- **Write Penalty là gì?** Cứ mỗi khi thêm một bản ghi vào Database, nó không chỉ ghi vào bảng gốc mà còn phải ghi vào tất cả các cấu trúc cây Index liên quan. Càng nhiều cột trong Index thì thao tác lưu trữ (và quá trình Page Split của cây B-Tree) càng nặng, dẫn tới delay (hình phạt ghi).
- **VARCHAR(20) vs TINYINT:** VARCHAR(20) lưu `status` tốn bộ nhớ hơn rất nhiều so với `TINYINT` (1 byte). Nếu lỡ đưa VARCHAR(20) vào Index, cả Data Length và Index Length đều sẽ phình to ra theo số ký tự thực tế + overhead, làm tiêu tốn dung lượng RAM (Buffer Pool) một cách vô nghĩa.
