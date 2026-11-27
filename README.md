# Quản lý thư viện

Ứng dụng giúp bạn đọc tìm sách, gửi yêu cầu mượn và theo dõi hạn trả. Thủ thư quản lý từng cuốn theo mã vạch, từ lúc nhập kho đến lúc giao và nhận lại sách. Quản trị viên phụ trách tài khoản và quyền truy cập.

**Trạng thái dự án:** Repo hiện có khung giao diện React chạy bằng Vite. Các màn hình và quy tắc dưới đây là phạm vi nhóm dự kiến triển khai với React, API Node.js và MySQL. Thư mục `server/` dành cho API, `database/` dành cho script tạo bảng và dữ liệu mẫu. Xem [yêu cầu dự án](MOCK_PROJECT_REQUIREMENTS.md).

## Màn hình và quyền sử dụng

| Màn hình | Ai được dùng | Chức năng |
| --- | --- | --- |
| Danh mục và chi tiết sách | Tất cả, kể cả khách | Tìm theo tên, lọc theo thể loại, sắp xếp danh sách. Xem tác giả, mô tả, số bản còn, điểm trung bình và đánh giá công khai. |
| Đăng ký, đăng nhập và hồ sơ | Khách đăng ký hoặc đăng nhập. Người đã đăng nhập quản lý hồ sơ | Đăng ký luôn tạo tài khoản bạn đọc (`member`). Chủ tài khoản cập nhật hồ sơ, đổi mật khẩu và đăng xuất. |
| Phiếu mượn của tôi | Bạn đọc | Gửi yêu cầu từ trang chi tiết sách. Xem trạng thái, hạn trả, lý do từ chối và lịch sử của mình. Hủy phiếu còn chờ duyệt. |
| Đánh giá trên trang sách | Bạn đọc đã trả sách | Chấm từ 1 đến 5 sao, viết nhận xét, sửa hoặc xóa đánh giá của mình. Mỗi bạn đọc có một đánh giá cho mỗi đầu sách. |
| Quản lý kho | Thủ thư (`librarian`) | Thêm, xem, sửa, xóa đầu sách. Quản lý tác giả, thể loại, nhập bản sao theo mã vạch và ghi nhận sách hỏng hoặc mất. Chỉ xóa đầu sách khi các bản sao và lịch sử mượn cho phép. |
| Duyệt mượn và nhận trả | Thủ thư xử lý. Admin được xem lịch sử | Thủ thư chọn bản sao để giao, đặt hạn trả hoặc từ chối kèm lý do. Khi nhận trả, ghi ngày trả và tình trạng bản sao. |
| Kiểm duyệt đánh giá | Thủ thư | Ẩn hoặc hiện đánh giá và ghi lý do. Chỉ đánh giá đang hiển thị mới được tính vào điểm trung bình. |
| Danh sách bạn đọc và quản lý tài khoản | Thủ thư xem danh sách bạn đọc. Admin quản lý tài khoản | Admin tạo tài khoản thủ thư, đổi vai trò, khóa hoặc mở tài khoản. Hệ thống chặn thao tác tự khóa hoặc tự hạ quyền của admin. |
| Thống kê | Thủ thư và admin xem nghiệp vụ. Riêng admin xem thống kê tài khoản | Theo dõi số phiếu chờ duyệt, đang mượn và quá hạn. Admin xem thêm số người dùng theo vai trò và số tài khoản mới. |

## Vòng đời một phiếu mượn

1. **Gửi yêu cầu.** Bạn đọc chọn đầu sách còn bản có thể mượn. Phiếu ở trạng thái `pending`, chưa gán mã bản sao. Mỗi bạn đọc có tối đa 3 phiếu chờ và đang mượn cộng lại. Hệ thống chặn yêu cầu mới khi có sách quá hạn hoặc đã có phiếu chờ/đang mượn cho cùng đầu sách.
2. **Xử lý tại quầy.** Bạn đọc có thể hủy phiếu chờ (`cancelled`). Thủ thư có thể từ chối (`rejected`) hoặc giao một bản còn sẵn của đúng đầu sách. Khi giao, hệ thống cập nhật phiếu thành `borrowing`, lưu hạn trả và chuyển bản sao thành `borrowed` trong cùng một giao dịch.
3. **Nhận trả.** Thủ thư đóng phiếu thành `returned` và cập nhật bản sao thành `available`, `damaged` hoặc `lost`. Phiếu còn đang mượn và đã qua hạn trả được hiển thị là quá hạn.

## Cấu trúc MySQL

| Bảng | Nội dung |
| --- | --- |
| `users` | Tài khoản, mật khẩu đã hash, vai trò và trạng thái khóa. Khách chưa đăng nhập không có bản ghi. |
| `authors`, `categories` | Danh mục tác giả và thể loại dùng chung cho các đầu sách. |
| `books` | Thông tin đầu sách gồm tên, ISBN, tác giả, thể loại, ảnh bìa và mô tả. |
| `book_copies` | Từng cuốn vật lý thuộc một đầu sách, có mã vạch duy nhất và tình trạng riêng. |
| `borrow_records` | Người mượn, đầu sách yêu cầu, bản sao thực giao, người xử lý, hạn trả và ngày trả. |
| `reviews` | Điểm sao, nhận xét, người viết và trạng thái kiểm duyệt của từng đánh giá. |

## Khởi tạo MySQL trên máy cá nhân

### Kết nối và nạp database

Cài MySQL Community Server 8.4 cùng công cụ dòng lệnh `mysql`, rồi khởi động dịch vụ MySQL. Trên Windows, mở **Services**, tìm dịch vụ MySQL đã cài và chọn **Start** nếu dịch vụ đang dừng.

Mở terminal tại thư mục gốc repo và kết nối đến MySQL local. Ví dụ dưới đây dùng cổng mặc định 3306 và tài khoản `root` để khởi tạo. Nhập mật khẩu MySQL của máy khi được hỏi.

```sh
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Tại dấu nhắc `mysql>`, chạy hai file theo thứ tự dưới đây. [schema.sql](database/schema.sql) tạo database `library_db` và 7 bảng. [seed.sql](database/seed.sql) nạp dữ liệu demo cho môi trường local.

```sql
SOURCE database/schema.sql
SHOW TABLES;
SOURCE database/seed.sql
SELECT title FROM books ORDER BY title;
```

Trên database mới, kết quả gồm 7 bảng và hai đầu sách **Dế Mèn phiêu lưu ký**, **Lược sử thời gian**. Seed cũng có ba bản sao, một phiếu đã trả và một đánh giá. Hai tài khoản bạn đọc và thủ thư ở trạng thái khóa để minh họa lịch sử.

**Admin demo local** có email `admin@demo.invalid` và mặc định bị khóa. Để tạo admin hoạt động, tự tạo hash bcrypt cho mật khẩu riêng, gán hash cho biến MySQL `@demo_admin_hash` trong cùng phiên trước lần nạp seed đầu tiên. Nếu admin đã tồn tại, seed giữ nguyên mật khẩu và trạng thái. Để kích hoạt tài khoản mẫu đã khóa, đặt biến trên rồi chạy:

```sql
UPDATE users SET password_hash = @demo_admin_hash, status = 'active'
WHERE email = 'admin@demo.invalid' AND role = 'admin' AND @demo_admin_hash IS NOT NULL;
```

Lệnh `SOURCE` chạy bên trong MySQL CLI. [Hướng dẫn chạy file SQL của MySQL](https://dev.mysql.com/doc/refman/8.4/en/batch-mode.html)

## Chạy giao diện React

Cài Node.js và npm. Từ thư mục gốc của repo, chạy:

```sh
cd client
npm ci
npm run dev
```

Mở địa chỉ Vite hiển thị trong terminal. Component đầu tiên nằm tại `client/src/App.jsx`. Khung giao diện hiện chạy độc lập với MySQL.
