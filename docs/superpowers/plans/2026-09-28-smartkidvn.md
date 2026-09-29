# SmartKidVN Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Xây dựng ứng dụng Flutter Android/iOS theo 42 màn hình, có các hành trình tương tác lưu trên thiết bị.

**Architecture:** Widget dùng chung giữ giao diện nhất quán. `AppStore` tập trung các quy tắc và trạng thái; nhóm màn hình nhận cùng một store. Lưu bản chụp JSON có phiên bản và ảnh nhỏ được chọn trên thiết bị; không giả định có máy chủ.

**Tech Stack:** Flutter, Dart, shared_preferences, image_picker; flutter_test.

**Spec:** `docs/superpowers/specs/2026-09-28-smartkidvn-design.md`.

## Global Constraints

- UTF-8 không BOM; giữ nguyên tiếng Việt có dấu.
- Chú thích tiếng Việt cho nghiệp vụ và khối xử lý quan trọng.
- Không commit, không triển khai dịch vụ ngoài.
- Phân biệt rõ trải nghiệm mẫu với xác thực, nhắn tin và thi đấu trực tuyến.
- Flutter Android/iOS; iOS cần kiểm tra bổ sung trên macOS/Xcode.

## Review Focus

- Nhấn ghi nhận hai lần không cộng thưởng trùng (Task 1).
- Thiếu xu, số lượng âm hoặc vật phẩm không có trong kho bị từ chối (Task 1).
- Bản lưu hỏng không gây màn hình trắng; lỗi ghi báo cho người dùng (Task 1).
- Màn hình hẹp hoặc bàn phím mở không che nút xác nhận (Task 2–4).
- Quay lại khi đang thi đấu không phát thưởng thêm lần nữa (Task 4).

## Task 1: Trạng thái nghiệp vụ và lưu trữ

**Files:** `pubspec.yaml`, `lib/domain/app_store.dart`, `lib/domain/models.dart`, `lib/data/local_repository.dart`, `test/app_store_test.dart`.

**Interfaces:** `AppStore` cung cấp `submitTask`, `approveTask`, `retryTask`, `redeemReward`, `purchaseItem`, `feedPet`, `equipItem`, `completeBattle`, `toJson` và `AppStore.fromJson`.

- [x] Viết kiểm thử: gửi việc không tăng xu; ghi nhận một lần tăng 20 xu vàng và 5 xu xanh; ghi nhận lại không đổi số dư; thiếu xu không thể mua; cho ăn không vượt 100; lưu/đọc giữ dữ liệu; dữ liệu lỗi được xử lý rõ ràng.
- [x] Chạy kiểm thử trước phần triển khai để ghi nhận thất bại; nếu thiếu SDK thì ghi rõ hạn chế và chuẩn bị SDK trước khi chạy lại.
- [x] Triển khai mô hình mục tiêu, nhiệm vụ, phần thưởng, giao dịch, pet và kho vật phẩm; lưu trữ tuần tự để tránh bản cũ ghi đè bản mới.
- [x] Chạy `flutter test test/app_store_test.dart`; yêu cầu tất cả kiểm thử vượt qua.

## Task 2: Giao diện chung và bắt đầu hành trình

**Files:** `lib/main.dart`, `lib/app.dart`, `lib/ui/theme.dart`, `lib/ui/components.dart`, `lib/screens/onboarding_screens.dart`, `assets/images/`, `test/widget_test.dart`.

**Interfaces:** `SmartKidApp(store: AppStore)`, `ScreenShell`, `PrimaryButton`, `Illustration`, `CoinBadge`, `ProgressCard`; điều hướng theo số màn hình 01–42 trong ảnh tham chiếu.

- [x] Tạo bộ hình minh họa Cáo Cam/gia đình phù hợp ảnh mẫu và đóng gói trong ứng dụng.
- [x] Viết kiểm thử widget chào mừng → giới thiệu → hồ sơ; luồng đổi không gian và ghi nhận nằm trong family_flow_test.dart; biểu mẫu kiểm tra dữ liệu trước khi chuyển bước.
- [x] Dựng theme kem/cam/xanh, phông tiếng Việt, thành phần chung và màn hình 01–06.
- [x] Kiểm tra kích thước 390×844 và 320×640 không có lỗi tràn.

## Task 3: Mục tiêu, gia đình và phần thưởng

**Files:** `lib/screens/parent_screens.dart`, `lib/screens/child_screens.dart`, `lib/screens/family_screens.dart`, `lib/screens/reward_screens.dart`.

**Interfaces:** mọi hành động thay đổi số dư gọi AppStore của Task 1; dữ liệu lựa chọn được truyền theo id, không dựa vào vị trí trong danh sách.

- [x] Kiểm thử giao diện chọn việc → gửi → bố mẹ ghi nhận → số dư tăng; kiểm thử nghiệp vụ yêu cầu đổi thưởng và xác nhận ngày. Biểu mẫu tạo mục tiêu được kiểm tra dựng màn hình, chưa có kiểm thử xuyên suốt riêng.
- [x] Dựng màn hình 07–34, biểu mẫu mục tiêu/phần thưởng, lịch, tin nhắn cục bộ, hồ sơ, ví và bộ sưu tập.
- [x] Kết nối ảnh từ thiết bị; giới hạn dung lượng và hiển thị lỗi nếu không thể lưu.
- [x] Kiểm thử xác nhận và thử lại không làm sai trạng thái, số dư hoặc tiến độ.

## Task 4: Cáo Cam và kiểm tra bàn giao

**Files:** `lib/screens/pet_screens.dart`, `test/app_store_test.dart`, `README.md`, cấu hình Android/iOS/web được Flutter sinh.

**Interfaces:** cửa hàng, kho và trận đấu dùng `purchaseItem`, `feedPet`, `equipItem`, `completeBattle` của Task 1.

- [x] Viết kiểm thử mua vật phẩm, dùng đúng loại xu, dùng vật phẩm đã hết và nhận thưởng trận đấu một lần.
- [x] Dựng màn hình 35–42; trận đấu mô phỏng có lượt, kết quả và giới hạn mỗi ngày.
- [x] Chạy `flutter analyze`, `flutter test`, `flutter build web`; chạy bản dựng Android nếu Android SDK khả dụng.
- [x] Xem trước giao diện, rà soát điều hướng và tiếng Việt; sửa lỗi đã quan sát.
- [x] Viết README hướng dẫn chạy, phạm vi hoạt động và hạn chế kiểm chứng iOS/Android nếu môi trường thiếu SDK.

## Quyết định thực thi

Người dùng đã trả lời “tiep tuc” cho đề xuất triển khai bản đầu. Tiếp tục trực tiếp trong phiên hiện tại theo ủy quyền đó; không yêu cầu lại cùng một xác nhận. Thư mục mới không phải kho Git nên làm việc trực tiếp tại vị trí người dùng chỉ định, không tạo nhánh/commit.

## Bằng chứng hoàn tất — 29/09/2026

- 18 kiểm thử vượt qua; bao gồm cả 42 màn hình ở 320×640 và các trường hợp nghiệp vụ, lưu trữ, luồng gia đình.
- `flutter analyze --no-pub`: No issues found.
- `flutter build apk --debug --target-platform android-arm64 --no-pub`: thành công; APK sao vào `artifacts/SmartKidVN-android-arm64.apk`.
- Chữ ký APK v2 được `apksigner verify --verbose` xác nhận. Tên hiển thị SmartKidVN, package vn.smartkid.smartkid_vn, phiên bản 1.0.0, Android tối thiểu API 24.
- `flutter build web --no-pub`: thành công; bản xem trước tại 127.0.0.1:4173. Xem giao diện bằng trình duyệt ở 390×844.
- Rà soát độc lập đã tìm và sửa: nhiệm vụ không lặp lại theo ngày; bản nháp ảnh/lời nhắn bị mang sang việc khác; lựa chọn ước mơ chưa lưu; mô tả quyền ảnh iOS còn thiếu.
- Minh họa, biểu tượng Android/iOS/web và ba biến thể trang phục Cáo Cam đã đóng gói cùng ứng dụng.
- Chưa chạy trên điện thoại Android thật; chưa dựng iOS vì môi trường Windows. Chưa kết nối máy chủ, xác thực, thông báo hệ điều hành hoặc thi đấu trực tuyến.
- README ghi rõ cách chạy, phạm vi bản thử và giới hạn kiểm chứng. Không tạo commit.