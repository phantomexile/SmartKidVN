import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartkid_vn/app.dart';
import 'package:smartkid_vn/domain/app_store.dart';

// Đi qua các nút thật thay vì sửa trạng thái màn hình từ bên ngoài.
Future<void> press(WidgetTester tester, String label) async {
  final finder = find.text(label).last;
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Con gửi việc, đổi vai trò, bố mẹ ghi nhận và ví nhận đúng xu', (
    tester,
  ) async {
    final store = AppStore.seed()..onboarded = true;
    await tester.pumpWidget(SmartKidApp(store: store, initialScreen: 22));
    await press(tester, 'Chuẩn bị cặp sách');
    for (final step in [
      'Xem thời khóa biểu',
      'Xếp sách vở',
      'Kiểm tra hộp bút',
    ]) {
      await press(tester, step);
    }
    await press(tester, 'Mình đã làm xong');
    await tester.enterText(
      find.byType(TextField).first,
      'Con đã tự xếp đủ sách rồi!',
    );
    await press(tester, 'Mình đã hoàn thành');
    await press(tester, 'Gửi cho mẹ xem');
    expect(store.task('bag').status, 'pending');
    expect(store.gold, 340);
    await tester.tap(find.byTooltip('Chọn không gian'));
    await tester.pumpAndSettle();
    await press(tester, 'Bố mẹ');
    await press(tester, 'Chờ ghi nhận');
    await press(tester, 'Chuẩn bị cặp sách');
    await press(tester, 'Ghi nhận nỗ lực');
    expect(store.task('bag').status, 'approved');
    expect(store.gold, 360);
    expect(store.blue, 90);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mở bước tiếp theo không mang ghi chú của nhiệm vụ trước', (
    tester,
  ) async {
    final store = AppStore.seed();
    store.task('bag').note = 'Ghi chú chỉ thuộc cặp sách';
    await tester.pumpWidget(SmartKidApp(store: store, initialScreen: 22));
    await press(tester, 'Chuẩn bị cặp sách');
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();
    await press(tester, 'Mục tiêu');
    await press(tester, 'Đọc 10 cuốn sách');
    await press(tester, 'Làm bước tiếp theo');
    for (final step in [
      'Chọn cuốn sách yêu thích',
      'Đọc trong 15 phút',
      'Kể lại điều con thích',
    ]) {
      await press(tester, step);
    }
    await press(tester, 'Mình đã làm xong');
    final input = tester.widget<TextField>(find.byType(TextField).first);
    expect(input.controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
