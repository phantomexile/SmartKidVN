import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartkid_vn/app.dart';
import 'package:smartkid_vn/domain/app_store.dart';

void main() {
  testWidgets('Bắt đầu mở phần giới thiệu; tiếp tục mở hồ sơ gia đình', (
    tester,
  ) async {
    await tester.pumpWidget(SmartKidApp(store: AppStore.seed()));
    expect(find.text('Lớn lên\ncùng nhau'), findsOneWidget);
    await tester.tap(find.text('Bắt đầu'));
    await tester.pumpAndSettle();
    expect(find.text('Mỗi cố gắng\nđều đáng quý'), findsOneWidget);
    await tester.ensureVisible(find.text('Tiếp tục'));
    await tester.tap(find.text('Tiếp tục'));
    await tester.pumpAndSettle();
    expect(find.text('Chào bố mẹ!'), findsOneWidget);
  });
  testWidgets('42 màn hình hiển thị trên điện thoại hẹp mà không tràn', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (var page = 1; page <= 42; page++) {
      await tester.pumpWidget(
        SmartKidApp(
          key: ValueKey(page),
          store: AppStore.seed(),
          initialScreen: page,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Màn hình $page');
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
