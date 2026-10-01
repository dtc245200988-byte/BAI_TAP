# Nhật ký Tương tác AI (AI Prompt Log)

Dưới đây là ghi chép các câu lệnh prompt được sử dụng trong quá trình tìm kiếm giải pháp thiết kế thay thế kỹ thuật float và absolute:

1. **Phân tích lỗi Float (Brainstorming):**
   *"Tại sao việc dùng thẻ float cho layout lại bắt buộc phải đi kèm với kỹ thuật clearfix (như overflow: hidden) ở thẻ cha? Nếu không dùng thuộc tính clear này thì chuyện gì sẽ xảy ra với các phần tử nằm bên dưới?"*

2. **Khám phá CSS Grid Mosaic (Pair-Programming):**
   *"Hướng dẫn tôi cách sử dụng CSS Grid để tạo một Mosaic Gallery có 3 ảnh. Ảnh thứ nhất to gấp đôi, chiếm 2 hàng bên trái, và 2 ảnh nhỏ nằm xếp chồng lên nhau ở cột bên phải. Tôi muốn khoảng cách giữa chúng tự co giãn mà không dùng pixel tĩnh cứng ngắc."*

3. **Bootstrap Flex Utilities (Tuning):**
   *"Thay vì viết thuộc tính Flexbox bằng CSS thuần, tôi có thể dùng những class tiện ích Bootstrap 5 nào (d-..., align-..., justify-...) để căn giữa dọc (vertical alignment) avatar tác giả và ép các nút chia sẻ mạng xã hội dạt hẳn sang lề phải?"*

4. **Kiểm tra Breakpoints Bootstrap (Testing):**
   *"Khi dùng Bootstrap Grid system cho phần 'Recommended Articles' với yêu cầu: Desktop hiển thị 4 thẻ/dòng, Tablet hiển thị 2 thẻ/dòng, Mobile hiển thị 1 thẻ/dòng. Tôi nên kết hợp chuỗi class cột (col-...) như thế nào ở từng thẻ card để đạt hiệu ứng rớt dòng hoàn hảo này?"*

5. **Xử lý Responsive cho Grid (Mở rộng):**
   *"Đối với cấu trúc Mosaic Gallery được xây bằng CSS Grid ở trên, làm thế nào viết một Media Query để khi màn hình điện thoại dưới 768px, bức ảnh chính không còn chiếm 2 hàng (span 2) nữa mà tất cả 3 ảnh sẽ tự động xếp thành 1 cột dọc thẳng tắp?"*
