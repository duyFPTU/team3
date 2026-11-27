# MOCK PROJECT – YÊU CẦU CƠ BẢN

## 1. Mục tiêu
Mỗi nhóm **2–3 thành viên** xây dựng một website nhỏ với **chủ đề tự chọn**, áp dụng đầy đủ kiến thức **ReactJS + Node.js + Database**.

## 2. Yêu cầu chức năng
- Có ít nhất **2 loại người dùng**: Guest/User hoặc User/Admin.
- **Đăng ký, đăng nhập, đăng xuất**; mật khẩu phải được hash, không lưu plain text.
- Có ít nhất **1 nghiệp vụ CRUD chính**: Create / Read / Update / Delete.
- Có **danh sách + trang chi tiết** cho dữ liệu chính.
- Có **Search** và ít nhất **1 Filter hoặc Sort**.
- Có **phân quyền cơ bản**: người dùng không được thực hiện chức năng không có quyền.
- Có **validation** ở cả frontend và backend cho dữ liệu quan trọng.
- Có xử lý và hiển thị trạng thái **loading / empty / error / success** hợp lý.

## 3. Frontend – ReactJS
- Dùng **ReactJS** và chia UI thành các component hợp lý.
- Sử dụng **React Router** để điều hướng trang.
- Sử dụng **state, props, hooks** đúng mục đích.
- Gọi Backend thông qua **REST API**; không hard-code dữ liệu nghiệp vụ trong frontend.
- Giao diện dễ sử dụng và **responsive cơ bản** cho desktop/mobile.

## 4. Backend – Node.js
- Xây dựng **REST API** bằng Node.js (có thể dùng Express.js).
- Tách cấu trúc code hợp lý, ví dụ: **routes / controllers / services / models**.
- API sử dụng HTTP method/status code phù hợp: **GET, POST, PUT/PATCH, DELETE**.
- Có xử lý lỗi tập trung và trả response rõ ràng.
- Thông tin nhạy cảm như DB password, JWT secret phải đặt trong **environment variables (.env)** và không commit lên Git.
- Note: chấp nhận sử dụng những ngôn ngữ khác phía Backend như Java, .net,...

## 5. Database
Có thể dùng **MySQL, PostgreSQL hoặc MongoDB**.

- Có ít nhất **3 bảng/collection chính** ngoài các bảng kỹ thuật nếu cần.
- Với SQL, cần có **Primary Key, Foreign Key** và relationship hợp lý.
- Thiết kế database tránh lưu dữ liệu dư thừa không cần thiết.
- Có dữ liệu mẫu đủ để demo các chức năng chính.

## 6. Git & làm việc nhóm
- Source code quản lý bằng **Git/GitHub**.
- Mỗi thành viên phải có contribution/commit vào repository.
- Không làm toàn bộ trên một branch rồi mới push cuối bài.
- README cần có hướng dẫn **cài đặt, cấu hình .env, chạy frontend/backend và database**.
- Note: Khi đặt tên repo, branch, commit,... không sử dụng bất cứ keyword nào liên quan đến FPT (hãy coi đây là project nhóm độc lập)

## 7. Sản phẩm cần bàn giao
1. Source code trên GitHub.
2. File **README.md** hướng dẫn chạy project.
3. FUNCTIONAL_SPECIFICATION.md => Project làm được gì?
4. IMPLEMENTATION_GUIDE.md => Project được xây dựng với các bước như nào?
5. Database schema/ERD đơn giản.
6. File `.env.example` (không chứa secret thật).
7. Slide ngắn gọn (3-5 slides gồm danh sách thành viên, phân chia công việc, chức năng chính website, các technical sử dụng)
8. Demo các chức năng chính.
9. Mỗi thành viên trình bày phần mình đã thực hiện.

## 8. Tiêu chí hoàn thành tối thiểu
Project được xem là hoàn thành khi:
- Frontend → Backend → Database kết nối và chạy được end-to-end.
- Authentication và CRUD chính hoạt động.
- Có validation, error handling và phân quyền cơ bản.
- Không có lỗi nghiêm trọng làm gián đoạn luồng chính.
- Người khác có thể clone repository và chạy project theo README.

## Điểm cộng: 
1. Có các features sử dụng AI như AI Chatbot, AI Generate Content, Semantic Search,...
2. Có deploy lên môi trường public

> **Lưu ý:** Ưu tiên sản phẩm **nhỏ nhưng hoàn chỉnh** hơn một hệ thống nhiều chức năng nhưng chưa hoàn thiện.
