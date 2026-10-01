# Chiến lược Layout: CSS Grid và Flexbox

**CSS Grid** sinh ra để làm Layout tổng thể (Macro-layout) vì nó hỗ trợ dàn trang theo cả 2 chiều (hàng và cột) cùng một lúc. Nó rất mạnh trong việc tạo ra các bố cục bất đối xứng, phức tạp như Bento box (khu vực Dashboard), nơi mà chúng ta cần kiểm soát chính xác vị trí của từng phần tử trên một mặt phẳng 2D và có thể dễ dàng yêu cầu một phần tử chiếm (span) nhiều hàng, nhiều cột.

Ngược lại, **Flexbox** sinh ra để làm Component chi tiết (Micro-layout) bởi vì bản chất của nó là 1 chiều (chỉ chạy theo hàng hoặc cột). Flexbox cực kỳ xuất sắc trong việc phân bổ không gian và căn chỉnh các phần tử tự động (như thanh điều hướng Navbar, căn giữa nội dung trong một Widget) dựa trên lượng không gian và kích thước của nội dung bên trong nó (Content-first). Nó cũng tự động dồn các phần tử xuống dòng (wrap) khi không đủ chỗ.

Sự kết hợp hoàn hảo nhất là dùng **CSS Grid** để chia khung trang web hoặc các vùng bố cục lớn, và dùng **Flexbox** bên trong các khối đó để sắp xếp nội dung chi tiết. Đối với những thành phần phổ thông, chuẩn hóa dạng lưới 12 cột (như khu vực Pricing), sử dụng thư viện như **Bootstrap** mang lại tốc độ triển khai nhanh và tính ổn định cao nhất.
