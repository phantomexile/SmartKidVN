import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkid_vn/data/local_repository.dart';
import 'package:smartkid_vn/domain/app_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Hai lần lưu liên tiếp giữ bản mới nhất sau khi mở ứng dụng lại',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repository = LocalRepository();
      final store = AppStore.seed();
      final first = repository.save(store);
      store.selectDream('colors');
      store.sendMessage('Mẹ yêu con!');
      final second = repository.save(store);
      await Future.wait([first, second]);
      final reopened = await LocalRepository().load();
      expect(reopened.dreamRewardId, 'colors');
      expect(reopened.messages.last['text'], 'Mẹ yêu con!');
    },
  );

  test('JSON hỏng được giữ bản sao phục hồi và báo lỗi rõ ràng', () async {
    SharedPreferences.setMockInitialValues({
      LocalRepository.key: '{dữ liệu lỗi',
    });
    final reopened = await LocalRepository().load();
    expect(reopened.storageError, isNotNull);
    expect(reopened.gold, 340);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('${LocalRepository.key}.recovery'), '{dữ liệu lỗi');
  });

  test('Ngày thưởng vẫn được giữ sau khi đọc lại dữ liệu', () async {
    SharedPreferences.setMockInitialValues({});
    final store = AppStore.seed();
    store.submitTask('bag', 'Con làm xong', null);
    store.approveTask('bag', 'Mẹ đã xem rồi');
    await LocalRepository().save(store);
    final reopened = await LocalRepository().load();
    expect(reopened.task('bag').completedDays, [store.today]);
    expect(jsonEncode(reopened.toJson()), contains('Mẹ đã xem rồi'));
  });
}
