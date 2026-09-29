# SmartKidVN — Bản thiết kế ứng dụng theo 42 màn hình tham chiếu

Ngày: 28/09/2026. Trạng thái: đã triển khai bản tương tác cục bộ theo chỉ dẫn tiếp tục của người dùng; bàn giao ngày 29/09/2026. Xem README để biết phạm vi kiểm chứng.

## 1. Yêu cầu và giả định

Người dùng yêu cầu tạo ứng dụng theo bảy ảnh tham chiếu, mỗi ảnh gồm sáu màn hình. Giữ phong cách minh họa gia đình Việt Nam và Cáo Cam, nền kem, điểm nhấn cam, cây xanh, thẻ bo tròn và nội dung tiếng Việt có dấu. Tất cả tệp văn bản dùng UTF-8 không BOM; mã nguồn có chú thích tiếng Việt cho logic quan trọng. Không commit nếu người dùng chưa yêu cầu.

Thư mục dự án ban đầu trống. Người dùng đã chọn Flutter để xây dựng ứng dụng Android/iOS. Thiết kế ưu tiên điện thoại; có thể dùng bản chạy trên trình duyệt để xem trước trong quá trình phát triển nếu bộ công cụ hỗ trợ.

## 2. Hai phương án triển khai

**Phương án đề xuất — bản tương tác đầy đủ trên một thiết bị:** dựng các màn hình, điều hướng và quy tắc nghiệp vụ cốt lõi; dùng dữ liệu mẫu được ghi rõ; lưu trạng thái trên thiết bị để dùng lại sau khi tải trang. Có thể đánh giá giao diện và toàn bộ hành trình trước khi xây dựng dịch vụ trực tuyến. Đăng nhập, tin nhắn và thi đấu trong bản này chỉ là trải nghiệm mô phỏng, không trình bày như dịch vụ thật.

**Phương án ứng dụng kết nối thực:** thêm máy chủ, cơ sở dữ liệu, xác thực, tải ảnh, phân quyền gia đình và đồng bộ giữa thiết bị bố mẹ–con. Cần xác định môi trường triển khai và tài khoản dịch vụ trước khi đưa lên mạng. Giao diện và quy tắc nghiệp vụ vẫn dựa trên cùng bộ mẫu.

## 3. Danh mục màn hình

| Nhóm | Màn hình |
| --- | --- |
| Bắt đầu hành trình | 01 Chào mừng; 02 Cách hoạt động; 03 Tạo tài khoản; 04 Hồ sơ của con; 05 Chọn không gian; 06 Trang chủ phụ huynh |
| Cùng con đạt mục tiêu | 07 Danh sách mục tiêu; 08 Tạo mục tiêu; 09 Chia nhỏ mục tiêu; 10 Lịch & cách ghi nhận; 11 Hộp chờ ghi nhận; 12 Xem ảnh & ghi nhận |
| Phần thưởng & hành trình | 13 Cùng con thử lại; 14 Phần thưởng gia đình; 15 Tạo phần thưởng; 16 Yêu cầu đổi thưởng; 17 Hành trình của con; 18 Lịch gia đình |
| Gia đình & việc hôm nay | 19 Lời nhắn gia đình; 20 Cài đặt gia đình; 21 Trang chủ của con; 22 Việc hôm nay; 23 Chi tiết nhiệm vụ; 24 Chụp ảnh & gửi kết quả |
| Nỗ lực & ước mơ của con | 25 Đã gửi kết quả; 26 Lời ghi nhận từ mẹ; 27 Mục tiêu của con; 28 Tiến độ mục tiêu; 29 Con đề xuất mục tiêu; 30 Ước mơ & cửa hàng |
| Phần thưởng & Cáo Cam | 31 Chi tiết phần thưởng; 32 Xác nhận đổi thưởng; 33 Ví của con; 34 Bộ sưu tập; 35 Nhà của pet; 36 Cửa hàng pet |
| Pet, thi đấu & bảng xếp hạng | 37 Chi tiết vật phẩm; 38 Tủ đồ của pet; 39 Chuẩn bị thi đấu; 40 Trận đấu pet; 41 Kết quả trận đấu; 42 Bảng xếp hạng pet |

## 4. Thiết kế giao diện

- Điện thoại: nội dung một cột, thanh điều hướng dưới, nút hành động lớn, vùng cuộn tránh bị thanh điều hướng che.
- Màn hình lớn và bản xem trước: giới hạn chiều rộng để giữ tỷ lệ hợp lý; tránh kéo giãn hình minh họa và biểu mẫu.
- Nền kem ấm; chữ xanh đậm; cam cho hành động chính; xanh lá cho tiến bộ; xanh dương cho xu chăm sóc pet.
- Dùng phông hỗ trợ đầy đủ tiếng Việt, tiêu đề tròn và đậm, nội dung rõ ràng.
- Hình minh họa là tài sản riêng từng cảnh, không đặt nguyên ảnh chụp nhiều màn hình lên ứng dụng. Ưu tiên tạo hình nhất quán với Cáo Cam trong mẫu.
- Giữ nguyên nhãn và câu chữ trong mẫu khi sử dụng. Các dữ liệu mâu thuẫn trong ảnh cần thống nhất bằng trạng thái thật: ví dụ số xu ở chi tiết và xác nhận đổi thưởng phải cùng một số dư.
- Biểu mẫu có nhãn, thông báo lỗi tiếng Việt, trạng thái trống và trạng thái thành công. Có hỗ trợ bàn phím và giảm chuyển động theo thiết lập của thiết bị.

## 5. Quy tắc nghiệp vụ của bản tương tác

### Mục tiêu và việc hằng ngày

Bố mẹ tạo mục tiêu gồm tên, điều con mong muốn, kỹ năng, thời hạn và các bước nhỏ. Mỗi bước có lịch, xu vàng, xu xanh và cách ghi nhận. Con thực hiện và gửi ghi chú, ảnh tùy chọn. Tiến độ mục tiêu tính từ các bước đã được ghi nhận.

Trạng thái kết quả: chưa làm → chờ ghi nhận → đã ghi nhận, hoặc cần thử lại. Gửi kết quả chưa làm tăng số xu. Ghi nhận chỉ cộng xu một lần cho mỗi kết quả; thao tác lặp lại không tạo thưởng trùng. Lời động viên khi thử lại giữ nguyên kết quả và cho phép con bổ sung.

### Ví và phần thưởng

Xu vàng dùng đổi phần thưởng gia đình; xu xanh dùng cho pet. Hai loại xu có sổ giao dịch riêng. Mọi khoản chi kiểm tra đủ số dư và không cho số dư âm. Khi con xác nhận đổi phần thưởng, trừ xu một lần và tạo yêu cầu chờ bố mẹ sắp xếp. Bố mẹ xác nhận ngày thực hiện sẽ không trừ thêm xu.

### Cáo Cam

Cửa hàng gồm thức ăn và trang phục. Mua vật phẩm trừ xu xanh và thêm vào kho. Cho ăn tiêu hao vật phẩm đang có; chỉ số được giới hạn trong khoảng 0–100. Mặc trang phục cập nhật vật phẩm đang sử dụng. Thi đấu mẫu có tiến trình, kết quả và phần thưởng một lần; bảng xếp hạng được ghi rõ là dữ liệu minh họa trong bản dùng thử.

### Gia đình và lưu dữ liệu

Chuyển vai trò để trải nghiệm bố mẹ và con trong cùng gia đình mẫu. Thay đổi hồ sơ, mục tiêu, kết quả, số dư, kho pet và lời nhắn được lưu trên thiết bị. Không lưu mật khẩu thật. Nếu triển khai máy chủ, mã vào không gian và việc phân quyền phải được kiểm tra ở máy chủ; mã PIN phía giao diện chỉ phục vụ trải nghiệm mẫu.

Ảnh người dùng chọn được xem trước và có thể thay hoặc xóa trước khi gửi. Bản dùng thử không tải ảnh lên dịch vụ bên ngoài. Nếu bộ nhớ thiết bị đầy, phải báo rõ và không âm thầm làm mất dữ liệu.

## 6. Cấu trúc kỹ thuật đề xuất cho Flutter

- Flutter + Dart, một mã nguồn cho Android/iOS. Windows có thể phát triển và tạo bản Android; bản iOS cần macOS và Xcode để biên dịch/ký ứng dụng.
- Thành phần dùng chung cho thanh điều hướng, tiêu đề, thẻ, nút, số xu, thanh tiến độ và biểu mẫu.
- Các mô-đun riêng cho khởi đầu, phụ huynh, trẻ em, mục tiêu, phần thưởng, gia đình và pet.
- Bộ xử lý nghiệp vụ tập trung cho ghi nhận, cộng/trừ xu, đổi thưởng và mua vật phẩm; giao diện không tự sửa số dư ở nhiều nơi.
- Lớp lưu trữ cục bộ có phiên bản dữ liệu, kiểm tra dữ liệu lỗi và khả năng đặt lại dữ liệu mẫu qua hành động được xác nhận. Ảnh dùng thử được lưu trong vùng dữ liệu của ứng dụng khi chạy trên thiết bị.
- Điều hướng Flutter có định danh từng màn hình; xử lý nút quay lại Android, vùng an toàn, bàn phím và vòng đời ứng dụng.

## 7. Tiêu chí nghiệm thu

1. Có thể đi qua cả 42 màn hình theo các hành trình hợp lý, không có nút hành động giả hoặc liên kết cụt.
2. Hoàn thành luồng tạo mục tiêu → gửi kết quả → ghi nhận → tăng số dư → đổi thưởng.
3. Hoàn thành luồng mua thức ăn/trang phục → chăm sóc/mặc cho Cáo Cam → thi đấu mẫu → xem kết quả.
4. Kiểm tra số dư không âm, thưởng không trùng, dữ liệu còn sau khi tải lại, và biểu mẫu từ chối dữ liệu không hợp lệ.
5. Kiểm tra hiển thị trên kích thước điện thoại và máy tính, chữ tiếng Việt, ảnh, cuộn, điều hướng và bàn phím.
6. Chạy `flutter analyze`, kiểm thử Dart/Flutter tập trung vào các quy tắc nghiệp vụ, kiểm thử widget cần thiết và bản dựng Android nếu SDK sẵn sàng. Phải nêu rõ hạng mục chưa kiểm tra được trên iOS khi làm việc bằng Windows.
7. Khi bàn giao, nêu rõ phần hoạt động thật trên thiết bị và phần cần máy chủ để sử dụng giữa nhiều thiết bị.

## 8. Điểm cần chốt

- Nền tảng đã chốt: Flutter cho Android/iOS.
- Phạm vi lần đầu: bản tương tác lưu trên thiết bị (đề xuất) hay ứng dụng có máy chủ và đồng bộ thật.

Chưa có mã nguồn sản phẩm, phụ thuộc, máy chủ, tài khoản dịch vụ hoặc commit nào được tạo ở giai đoạn thiết kế này.
