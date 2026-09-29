# SmartKidVN

Ứng dụng Flutter dành cho Android/iOS, phát triển theo 42 màn hình tham chiếu của SmartKidVN. Giao diện tiếng Việt với nền kem, màu cam, minh họa gia đình và Cáo Cam. Đây là bản tương tác dùng dữ liệu lưu trên một thiết bị.

## Dùng thử

- APK Android: `artifacts/SmartKidVN-android-arm64.apk` — bản debug dành cho điện thoại Android ARM64, dùng để cài thử.
- Bản xem trước: mở `http://127.0.0.1:4173` trên máy đang chạy dự án. Nếu máy chủ chưa chạy, thực hiện `node tools/preview.mjs` sau khi dựng web.
- Lần đầu, chọn **Bắt đầu**, tạo hồ sơ và chọn không gian **Bố mẹ** hoặc **Bóng**. Biểu tượng gia đình ở góc trên cho phép đổi không gian.
- Dữ liệu khởi đầu: 340 xu vàng, 85 xu xanh; ước mơ “Cả nhà đi picnic” cần 500 xu vàng.

## Những luồng đã có

- Tạo hồ sơ và chuyển vai trò trên cùng thiết bị.
- Tạo mục tiêu, chia bước, chọn ngày lặp lại, giờ nhắc và mức thưởng.
- Con làm nhiệm vụ, chọn/chụp ảnh, viết lời nhắn và gửi kết quả. Bố mẹ ghi nhận hoặc động viên con thử lại.
- Chỉ ghi nhận mới cộng xu; ghi nhận lặp lại không phát thưởng thêm. Nhiệm vụ có lượt mới theo lịch ngày, giữ lịch sử đã hoàn thành.
- Tạo phần thưởng, chọn ước mơ, yêu cầu đổi thưởng và chọn ngày cùng thực hiện. Xu vàng dùng cho phần thưởng; xu xanh dùng cho Cáo Cam.
- Ví và giao dịch, bộ sưu tập, hành trình, lịch gia đình và lời nhắn cục bộ.
- Mua thức ăn, cho pet ăn, mua/mặc trang phục với hình minh họa tương ứng.
- Trận đấu mô phỏng, kết quả và bảng xếp hạng mẫu; giới hạn hai trận mỗi ngày.
- Lưu dữ liệu sau mỗi thay đổi, ghi tuần tự để tránh ghi đè sai thứ tự; giữ bản sao phục hồi nếu dữ liệu cũ bị hỏng.

## Phạm vi của bản này

Hồ sơ, lời nhắn, duyệt nhiệm vụ và ví được lưu trên thiết bị. Chưa có máy chủ, tài khoản trực tuyến, đồng bộ giữa điện thoại bố mẹ và con, thông báo đẩy hay ghép trận thật. Mã vào không gian và màn hình tài khoản phục vụ trải nghiệm mẫu, chưa phải cơ chế bảo mật cho bản phát hành. Giờ nhắc được lưu và hiển thị trong lịch, chưa tạo thông báo của hệ điều hành.

Ảnh được chọn qua `image_picker`, giảm kích thước và giới hạn khoảng 1 MB trước khi lưu. Xóa dữ liệu ứng dụng hoặc dữ liệu trang web sẽ xóa hồ sơ trên thiết bị. Không nên dùng bản thử này để lưu dữ liệu quan trọng.

Minh họa được tạo riêng dựa trên phong cách ảnh tham chiếu; bố cục đã điều chỉnh để có thể tương tác và co giãn theo màn hình. Đây không phải bản sao từng điểm ảnh.

## Chạy trên Windows

Bộ Flutter và Android SDK dùng trong phiên xây dựng nằm tại `.tools/` (không đưa vào mã nguồn). Script sau thiết lập đường dẫn cho tiến trình hiện tại, không đổi cấu hình toàn máy:

```powershell
.\tools\flutter.ps1 pub get
.\tools\flutter.ps1 devices
.\tools\flutter.ps1 run -d <device-id>
```

Nếu dùng Flutter cài riêng, có thể chạy các lệnh `flutter` thông thường. Cần Flutter tương thích Dart 3.9 trở lên; bản này được dựng bằng Flutter 3.47.5 / Dart 3.13.4. Android cần SDK và JDK tương thích; script ưu tiên JDK 17 tại `C:/Program Files/Java/jdk-17` khi có sẵn.

### Kiểm tra và đóng gói

```powershell
.\tools\flutter.ps1 analyze --no-pub
.\tools\flutter.ps1 test --no-pub
.\tools\flutter.ps1 build apk --debug --target-platform android-arm64 --no-pub
.\tools\flutter.ps1 build web --no-pub
node tools/preview.mjs
```

APK gốc được tạo tại `build/app/outputs/flutter-apk/app-debug.apk`. Bản sao dễ lấy nằm trong `artifacts/`. APK debug dùng khóa phát triển, chưa dành cho Google Play. Muốn chạy trình giả lập x86_64, dùng `flutter run` với thiết bị tương ứng hoặc dựng lại cho kiến trúc đó.

### iOS

Thư mục `ios/` có dự án Flutter, biểu tượng và mô tả quyền máy ảnh/thư viện ảnh. Cần macOS, Xcode, thiết bị hoặc trình giả lập iOS để chạy; cần tài khoản và chứng chỉ Apple thích hợp để ký bản phân phối. Chưa biên dịch hoặc kiểm thử iOS trong môi trường Windows này.

```sh
flutter pub get
flutter run -d <ios-device-id>
```

## Cấu trúc mã nguồn

| Vị trí | Vai trò |
| --- | --- |
| `lib/main.dart` | Đọc dữ liệu và khởi động ứng dụng |
| `lib/app.dart` | Điều hướng, trạng thái biểu mẫu và kết nối lưu trữ |
| `lib/domain/` | Mô hình và quy tắc nhiệm vụ, xu, đổi thưởng, pet |
| `lib/data/local_repository.dart` | Đọc/ghi JSON trong bộ nhớ thiết bị |
| `lib/screens/` | Sáu nhóm màn hình theo hành trình sử dụng |
| `lib/ui/` | Màu sắc, kiểu chữ và thành phần giao diện dùng chung |
| `assets/` | Minh họa, trang phục, biểu tượng và phông Nunito kèm giấy phép |
| `test/` | Kiểm thử nghiệp vụ, lưu trữ, luồng gia đình và 42 màn hình |
| `docs/superpowers/specs/` | Đặc tả và danh mục màn hình tham chiếu |

Mọi tệp văn bản của dự án dùng UTF-8 không BOM; giữ tiếng Việt có dấu trong nội dung và chú thích.

## Kiểm chứng

Bộ kiểm thử bao gồm chống cộng xu trùng, thiếu xu, dùng vật phẩm, đổi ngày nhiệm vụ, lưu/đọc và phục hồi dữ liệu lỗi, luồng con gửi → bố mẹ ghi nhận, không mang nhầm bản nháp giữa nhiệm vụ, và dựng cả 42 màn hình ở kích thước 320×640. Giao diện cũng đã được xem trực tiếp ở 390×844 qua bản web.

Việc dựng APK xác nhận mã nguồn có thể đóng gói cho Android; chưa thay thế kiểm thử trên điện thoại thật, đặc biệt là camera, quyền truy cập ảnh và vòng đời ứng dụng. Bản web dùng để xem trước giao diện và luồng thao tác.
