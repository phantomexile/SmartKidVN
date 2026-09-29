import 'package:flutter_test/flutter_test.dart';
import 'package:smartkid_vn/domain/app_store.dart';

void main() {
  test('Mã giao dịch khác nhau ngay cả khi tạo liên tiếp', () {
    final store = AppStore.seed();
    final ids = List.generate(100, (_) => store.newId());
    expect(ids.toSet().length, 100);
  });

  test('Nhiệm vụ chỉ hiện đúng lịch và có lượt mới vào ngày tiếp theo', () {
    var day = DateTime(2026, 9, 28);
    final store = AppStore.seed(clock: () => day);
    store.addGoal(
      'Việc Chủ nhật',
      '',
      'Tự lập',
      '2 tuần',
      ['Tưới cây'],
      [7],
      '08:00',
      10,
      2,
      false,
    );
    final sundayId = store.tasks.last.id;
    expect(store.todayTasks.any((t) => t.id == sundayId), isFalse);
    store.submitTask('bag', 'Thứ hai', null);
    store.approveTask('bag', 'Tốt lắm');
    expect(store.progress(store.goal('school')), 8);
    day = DateTime(2026, 9, 29);
    store.syncDay();
    expect(store.task('bag').status, 'todo');
    store.submitTask('bag', 'Thứ ba', null);
    store.approveTask('bag', 'Con đã tiến bộ');
    expect(store.gold, 380);
    expect(store.progress(store.goal('school')), 9);
    day = DateTime(2026, 10, 4);
    store.syncDay();
    expect(store.todayTasks.any((t) => t.id == sundayId), isTrue);
  });

  test('Phần thưởng được chọn làm ước mơ còn sau khi đọc bản lưu', () {
    final store = AppStore.seed();
    store.selectDream('colors');
    expect(AppStore.fromJson(store.toJson()).dreamRewardId, 'colors');
  });

  // Kiểm tra từ hành động thực tế để phát hiện việc cộng/trừ xu sai.
  test('Gửi kết quả chưa cộng xu; ghi nhận chỉ thưởng một lần', () {
    final store = AppStore.seed();
    store.submitTask('bag', 'Con đã xếp đủ sách rồi!', null);
    expect(store.gold, 340);
    expect(store.blue, 85);
    store.approveTask('bag', 'Mẹ rất tự hào về con!');
    expect(store.gold, 360);
    expect(store.blue, 90);
    expect(() => store.approveTask('bag', 'Lần nữa'), throwsStateError);
    expect(store.gold, 360);
  });

  test('Thử lại không thưởng xu và cho phép gửi bổ sung', () {
    final store = AppStore.seed();
    store.submitTask('bag', 'Con đã làm xong', null);
    store.retryTask('bag', 'Mình kiểm tra thêm hộp bút nhé!');
    expect(store.gold, 340);
    store.submitTask('bag', 'Con bổ sung hộp bút rồi', null);
    store.approveTask('bag', 'Tốt lắm con');
    expect(store.gold, 360);
  });

  test('Không đủ xu không tạo yêu cầu; xác nhận ngày không trừ lần hai', () {
    final store = AppStore.seed();
    expect(() => store.redeemReward('picnic'), throwsStateError);
    expect(store.gold, 340);
    store.redeemReward('dinner');
    expect(store.gold, 140);
    store.confirmRedemption(store.redemptions.last.id, '2026-10-04');
    expect(store.gold, 140);
  });

  test('Mua và dùng thức ăn; từ chối thiếu xu hoặc không còn vật phẩm', () {
    final store = AppStore.seed();
    store.purchaseItem('carrot');
    expect(store.blue, 75);
    store.feedPet('carrot');
    expect(store.hunger, 90);
    expect(() => store.feedPet('carrot'), throwsStateError);
    store.purchaseItem('carrot');
    store.feedPet('carrot');
    expect(store.hunger, 100);
    expect(() => store.purchaseItem('space'), throwsStateError);
    expect(store.blue, 65);
    expect(store.gold, 340);
  });

  test('Không mua trang phục trùng và chỉ mặc vật phẩm thuộc sở hữu', () {
    final store = AppStore.seed();
    expect(() => store.equipItem('hat'), throwsStateError);
    store.purchaseItem('hat');
    store.equipItem('hat');
    expect(store.equipped, 'hat');
    expect(() => store.purchaseItem('hat'), throwsStateError);
    expect(store.blue, 35);
  });

  test('Trận đấu chỉ phát thưởng một lần và giới hạn hai lượt mỗi ngày', () {
    final store = AppStore.seed();
    final id = store.startBattle();
    store.completeBattle(id);
    expect(store.petPoints, 375);
    expect(() => store.completeBattle(id), throwsStateError);
    final second = store.startBattle();
    store.completeBattle(second);
    expect(() => store.startBattle(), throwsStateError);
  });

  test('Đọc lại dữ liệu giữ số dư, lời nhắn và trạng thái đã ghi nhận', () {
    final store = AppStore.seed();
    store.submitTask('bag', 'Con xong rồi', null);
    store.approveTask('bag', 'Mẹ đã xem');
    store.sendMessage('Con cảm ơn mẹ!');
    final loaded = AppStore.fromJson(store.toJson());
    expect(loaded.gold, 360);
    expect(loaded.messages.last['text'], 'Con cảm ơn mẹ!');
    expect(() => loaded.approveTask('bag', 'Lần nữa'), throwsStateError);
  });

  test('Dữ liệu sai phiên bản hoặc số dư âm bị từ chối', () {
    expect(() => AppStore.fromJson({'version': -1}), throwsFormatException);
    final data = AppStore.seed().toJson()..['gold'] = -1;
    expect(() => AppStore.fromJson(data), throwsFormatException);
  });
}
