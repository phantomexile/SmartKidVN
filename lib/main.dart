import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/local_repository.dart';
import 'domain/app_store.dart';

/// Đọc dữ liệu trước khi hiển thị để ví xu không nhảy từ số mẫu sang số thật.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFFBF3),
    ),
  );
  final repository = LocalRepository();
  AppStore store;
  try {
    store = await repository.load();
  } catch (_) {
    store = AppStore.seed()
      ..storageError =
          'Chưa đọc được bộ nhớ thiết bị. Những thay đổi sẽ được thử lưu lại.';
  }
  runApp(SmartKidApp(store: store, onSave: repository.save));
}
