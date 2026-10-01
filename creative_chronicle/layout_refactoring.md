# Báo cáo Phân tích Refactoring Layout

## 1. Tác hại của `position: absolute` đối với Responsive Design
Kỹ thuật `position: absolute` rút hoàn toàn phần tử ra khỏi "luồng tài liệu chuẩn" (Normal Document Flow). Hệ lụy là phần tử cha (ở đây là khối Gallery) không thể nhận biết được chiều cao thực của các khối ảnh con bên trong. Để tránh nội dung văn bản bên dưới bị các ảnh này đè lên, lập trình viên buộc phải gán "cứng" (hard-code) một chiều cao cố định cho khối cha (ví dụ `height: 400px`). Tuy nhiên, trên giao diện Mobile hẹp, ảnh bắt buộc phải co bóp và có thể dẫn đến việc các ảnh xếp lộn xộn, vượt ra khỏi mức 400px, từ đó đè bẹp lên chữ bên dưới một cách thảm họa.

## 2. Giải pháp CSS Grid cứu cánh
CSS Grid giải quyết triệt để lỗi này vì Grid hoạt động ngay bên trong luồng tài liệu chuẩn. Grid có khả năng tự động tính toán (auto-sizing) chiều cao của container dựa trên tỷ lệ nội dung (ví dụ `grid-auto-rows`). Khi thu nhỏ trên màn hình Mobile, khối Grid tự động phình to (hoặc co lại) và tự động đẩy các đoạn văn bản bên dưới xuống một cách an toàn mà không bao giờ bị đè lấn. Thêm vào đó, việc sử dụng các thuộc tính như `span 2` giúp dễ dàng xếp đặt bố cục bất đối xứng mà không cần đo đạc tỉ mỉ bằng pixel.
