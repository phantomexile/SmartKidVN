import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/app_store.dart';

/// Lưu tuần tự một bản chụp trạng thái; thao tác mới không bị bản cũ ghi đè.
class LocalRepository {
  static const key = 'smartkid.family.v1';
  Future<void> _queue = Future.value();
  Future<AppStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return AppStore.seed();
    try {
      return AppStore.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Giữ nguyên dữ liệu hỏng ở khóa phục hồi trước khi cho dùng bản mẫu.
      await prefs.setString('$key.recovery', raw);
      return AppStore.seed()
        ..storageError =
            'Bản lưu trước không đọc được. Đã giữ bản sao phục hồi và mở dữ liệu mẫu.';
    }
  }

  Future<void> save(AppStore store) {
    final snapshot = jsonEncode(store.toJson());
    _queue = _queue.catchError((_) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(key, snapshot)) {
        throw StateError('Bộ nhớ thiết bị không đủ.');
      }
    });
    return _queue;
  }
}
