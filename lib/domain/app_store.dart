import 'package:flutter/foundation.dart';
import 'models.dart';

/// Nguồn trạng thái chung cho hai vai trò; quy tắc xu không đặt trong widget.
class AppStore extends ChangeNotifier {
  AppStore.seed({DateTime Function()? clock}) : _clock = clock ?? DateTime.now {
    goals = [
      KidGoal(
        id: 'school',
        title: 'Tự chuẩn bị đi học',
        wish: 'Con muốn tự lập hơn',
        baseline: 7,
      ),
      KidGoal(
        id: 'books',
        title: 'Đọc 10 cuốn sách',
        icon: '📚',
        baseline: 4,
        skill: 'Kiên nhẫn',
      ),
      KidGoal(
        id: 'plant',
        title: 'Tưới cây mỗi ngày',
        icon: '🌱',
        baseline: 10,
        skill: 'Chia sẻ',
      ),
    ];
    tasks = [
      KidTask(id: 'bag', title: 'Chuẩn bị cặp sách'),
      KidTask(
        id: 'read',
        title: 'Đọc sách 15 phút',
        icon: '📖',
        gold: 15,
        blue: 3,
        goalId: 'books',
        steps: [
          'Chọn cuốn sách yêu thích',
          'Đọc trong 15 phút',
          'Kể lại điều con thích',
        ],
      ),
      KidTask(
        id: 'clothes',
        title: 'Gấp quần áo',
        icon: '👕',
        gold: 10,
        blue: 2,
        status: 'pending',
        note: 'Hôm nay con tự nhớ được!',
        steps: ['Phân loại quần áo', 'Gấp thật gọn', 'Cất vào tủ'],
      ),
    ];
    rewards = [
      FamilyReward(
        id: 'picnic',
        title: 'Cả nhà đi picnic',
        cost: 500,
        description:
            'Cùng cả nhà khám phá thiên nhiên, ăn ngon và có thật nhiều kỷ niệm đẹp!',
      ),
      FamilyReward(
        id: 'dinner',
        title: 'Con chọn bữa tối',
        cost: 200,
        icon: '🍕',
        description: 'Con được chọn món cho bữa tối cuối tuần!',
      ),
      FamilyReward(
        id: 'colors',
        title: 'Bộ màu mới',
        cost: 800,
        icon: '🎨',
        kind: 'Món quà',
        description: 'Thỏa sức sáng tạo với bộ màu xinh xắn!',
      ),
      FamilyReward(
        id: 'badge',
        title: 'Huy hiệu kiên trì',
        cost: 100,
        icon: '🏅',
        kind: 'Phần thưởng ảo',
        description: 'Dành cho những bạn luôn nỗ lực dù có khó khăn!',
      ),
    ];
    messages = [
      {
        'sender': 'parent',
        'text': 'Mẹ thấy con đã tự chuẩn bị cặp. Con thấy thế nào?',
        'time': '08:12',
      },
      {
        'sender': 'child',
        'text': 'Con thấy buổi sáng đỡ vội hơn ạ!',
        'time': '08:16',
      },
      {
        'sender': 'parent',
        'text': 'Mình thử tiếp tối nay nhé!',
        'time': '08:18',
      },
    ];
    for (final t in tasks) {
      t.occurrenceDay = today;
    }
  }
  final DateTime Function() _clock;
  String get today => _clock().toIso8601String().substring(0, 10);
  String dreamRewardId = 'picnic';
  int gold = 340, blue = 85, hunger = 70, energy = 85, petPoints = 350;
  String equipped = 'basic';
  String childName = 'Bống',
      parentName = 'Minh Anh',
      role = 'child',
      avatar = '👧';
  int age = 9, xp = 0;
  bool onboarded = false,
      quiet = true,
      battleAllowed = true,
      notifications = true;
  late List<KidTask> tasks;
  late List<KidGoal> goals;
  late List<FamilyReward> rewards;
  Map<String, int> inventory = {};
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> proposals = [];
  List<String> completedBattles = [];
  String battleDay = '', activeBattle = '';
  int battlesUsed = 0;
  String? storageError;
  bool saving = false;
  List<Redemption> redemptions = [];
  List<Map<String, dynamic>> messages = [];
  static int _lastId = 0;

  /// Đồng hồ Windows có thể trả cùng thời điểm cho hai thao tác rất nhanh.
  /// Dãy tăng đơn điệu bảo đảm mỗi giao dịch/trận đấu có mã riêng trong phiên.
  String newId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    _lastId = now > _lastId ? now : _lastId + 1;
    return _lastId.toString();
  }

  KidTask task(String id) => tasks.firstWhere((t) => t.id == id);
  KidGoal goal(String id) => goals.firstWhere((g) => g.id == id);
  FamilyReward reward(String id) => rewards.firstWhere((r) => r.id == id);
  int progress(KidGoal g) =>
      (g.baseline +
              tasks
                  .where((t) => t.goalId == g.id)
                  .fold<int>(0, (sum, t) => sum + t.completedDays.length))
          .clamp(0, g.total);
  int get pendingCount => tasks.where((t) => t.status == 'pending').length;
  List<KidTask> get todayTasks => tasks
      .where(
        (t) =>
            t.days.contains(_clock().weekday) ||
            t.status == 'pending' ||
            t.status == 'retry',
      )
      .toList();
  int get doneCount => todayTasks
      .where((t) => t.status == 'approved' || t.status == 'pending')
      .length;
  int get battlesLeft =>
      battleDay == DateTime.now().toIso8601String().substring(0, 10)
      ? (2 - battlesUsed).clamp(0, 2)
      : 2;
  void changed() => notifyListeners();

  /// Mỗi ngày có một lượt riêng. Giữ lịch sử các ngày đã thưởng để không mất tiến độ.
  /// Kết quả đang chờ hoặc cần sửa vẫn giữ nguyên để bố mẹ có thể xem muộn.
  void syncDay() {
    bool updated = false;
    for (final t in tasks) {
      if (t.status == 'approved' && t.occurrenceDay != today) {
        t.status = 'todo';
        t.note = '';
        t.photo = null;
        t.feedback = '';
        updated = true;
      }
    }
    if (updated) changed();
  }

  /// Lựa chọn này được lưu cùng hồ sơ; thẻ ước mơ luôn lấy từ mã phần thưởng đã chọn.
  void selectDream(String id) {
    reward(id);
    dreamRewardId = id;
    changed();
  }

  /// Chưa ghi nhận thì chưa thưởng; ảnh base64 nhỏ được lưu cùng kết quả.
  void submitTask(String id, String note, String? photo) {
    syncDay();
    final t = task(id);
    if (!['todo', 'retry'].contains(t.status)) {
      throw StateError('Việc này đã được gửi rồi.');
    }
    if (t.status == 'todo' && !t.days.contains(_clock().weekday)) {
      throw StateError(
        'Việc này chưa đến ngày thực hiện. Con xem lịch gia đình nhé!',
      );
    }
    if (t.completedDays.contains(today)) {
      throw StateError('Việc hôm nay đã được ghi nhận rồi.');
    }
    if (photo != null && photo.length > 1400000) {
      throw StateError('Ảnh quá lớn. Hãy chọn ảnh nhỏ hơn 1 MB.');
    }
    t.note = note.trim();
    t.photo = photo;
    t.status = 'pending';
    t.occurrenceDay = today;
    if (t.autoApprove) {
      approveTask(id, 'Con đã hoàn thành một bước nhỏ!');
    } else {
      changed();
    }
  }

  /// Cờ trạng thái và giao dịch được thay đổi cùng nhau, ngăn bấm nút nhận xu lặp.
  void approveTask(String id, String feedback) {
    final t = task(id);
    if (t.status != 'pending') {
      throw StateError('Kết quả này không còn chờ ghi nhận.');
    }
    t.status = 'approved';
    if (t.completedDays.contains(t.occurrenceDay)) {
      throw StateError('Lượt này đã được thưởng rồi.');
    }
    t.completedDays.add(t.occurrenceDay);
    t.feedback = feedback.trim();
    gold += t.gold;
    blue += t.blue;
    _transaction(t.title, t.gold, 'gold');
    _transaction(t.title, t.blue, 'blue');
    changed();
  }

  void retryTask(String id, String feedback) {
    final t = task(id);
    if (t.status != 'pending') {
      throw StateError('Kết quả này không còn chờ ghi nhận.');
    }
    if (feedback.trim().isEmpty) {
      throw StateError('Hãy gửi con một lời động viên nhé.');
    }
    t.status = 'retry';
    t.feedback = feedback.trim();
    changed();
  }

  void _transaction(String title, int amount, String currency) {
    transactions.insert(0, {
      'title': title,
      'amount': amount,
      'currency': currency,
      'time': DateTime.now().toIso8601String(),
    });
  }

  void redeemReward(String id) {
    final r = reward(id);
    if (gold < r.cost) {
      throw StateError('Con cần thêm ${r.cost - gold} xu vàng nữa.');
    }
    if (redemptions.any((x) => x.rewardId == id && x.status == 'pending')) {
      throw StateError('Bố mẹ đang xem yêu cầu này rồi nhé!');
    }
    gold -= r.cost;
    redemptions.add(Redemption(id: newId(), rewardId: id, cost: r.cost));
    _transaction('Đổi ${r.title}', -r.cost, 'gold');
    changed();
  }

  void confirmRedemption(String id, String date) {
    final r = redemptions.firstWhere((r) => r.id == id);
    if (DateTime.tryParse(date) == null) {
      throw StateError('Hãy chọn ngày hợp lệ.');
    }
    r.date = date;
    r.status = 'confirmed';
    changed();
  }

  void purchaseItem(String id) {
    final item = PetItem.catalog.firstWhere((i) => i.id == id);
    if (item.category == 'outfit' && (inventory[id] ?? 0) > 0) {
      throw StateError('Vật phẩm này đã có trong tủ đồ.');
    }
    if (blue < item.cost) {
      throw StateError('Con cần thêm ${item.cost - blue} xu xanh nữa.');
    }
    blue -= item.cost;
    inventory[id] = (inventory[id] ?? 0) + 1;
    _transaction('Mua ${item.name} cho Cáo Cam', -item.cost, 'blue');
    changed();
  }

  void feedPet(String id) {
    final item = PetItem.catalog.firstWhere((i) => i.id == id);
    if (item.category != 'food' || (inventory[id] ?? 0) < 1) {
      throw StateError('Con cần mua thức ăn này trước nhé.');
    }
    inventory[id] = inventory[id]! - 1;
    if (id == 'carrot') {
      hunger = (hunger + 20).clamp(0, 100);
    } else {
      energy = (energy + 15).clamp(0, 100);
    }
    changed();
  }

  void equipItem(String id) {
    if (id != 'basic' &&
        !PetItem.catalog.any(
          (i) =>
              i.id == id && i.category == 'outfit' && (inventory[id] ?? 0) > 0,
        )) {
      throw StateError('Trang phục này chưa có trong tủ đồ.');
    }
    equipped = id;
    changed();
  }

  /// Lượt được giữ ngay khi bắt đầu; thoát và mở lại không tạo thêm trận miễn phí.
  String startBattle() {
    if (!battleAllowed) throw StateError('Bố mẹ đang tắt chế độ thi đấu.');
    if (activeBattle.isNotEmpty) return activeBattle;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (battleDay != today) {
      battleDay = today;
      battlesUsed = 0;
    }
    if (battlesUsed >= 2) {
      throw StateError('Hôm nay đã đủ hai lượt. Hẹn con ngày mai nhé!');
    }
    if (energy < 10) {
      throw StateError('Cáo Cam cần ăn táo để có thêm năng lượng.');
    }
    battlesUsed++;
    energy -= 10;
    activeBattle = newId();
    changed();
    return activeBattle;
  }

  void completeBattle(String id) {
    if (id.isEmpty || activeBattle != id || completedBattles.contains(id)) {
      throw StateError('Trận đấu này đã kết thúc.');
    }
    completedBattles.add(id);
    activeBattle = '';
    petPoints += 25;
    xp += 10;
    changed();
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) {
      throw StateError('Hãy viết lời nhắn trước khi gửi.');
    }
    messages.add({
      'sender': role,
      'text': message.trim(),
      'time':
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    });
    changed();
  }

  /// Biểu mẫu gọi phương thức này sau khi hoàn thành ba bước tạo mục tiêu.
  void addGoal(
    String title,
    String wish,
    String skill,
    String duration,
    List<String> stepTitles,
    List<int> days,
    String time,
    int rewardGold,
    int rewardBlue,
    bool autoApprove,
  ) {
    if (title.trim().isEmpty ||
        stepTitles.isEmpty ||
        stepTitles.any((s) => s.trim().isEmpty) ||
        days.isEmpty ||
        rewardGold < 0 ||
        rewardBlue < 0) {
      throw StateError('Hãy điền tên mục tiêu, các bước và ít nhất một ngày.');
    }
    final id = newId();
    goals.add(
      KidGoal(
        id: id,
        title: title.trim(),
        wish: wish.trim(),
        skill: skill,
        duration: duration,
        total: stepTitles.length,
      ),
    );
    for (var i = 0; i < stepTitles.length; i++) {
      tasks.add(
        KidTask(
          id: '$id-$i',
          title: stepTitles[i].trim(),
          goalId: id,
          gold: rewardGold,
          blue: rewardBlue,
          days: List.of(days),
          time: time,
          autoApprove: autoApprove,
          steps: [
            'Chuẩn bị',
            'Thực hiện thật cẩn thận',
            'Kiểm tra lại kết quả',
          ],
        ),
      );
    }
    changed();
  }

  void addReward(String title, String description, int cost, String kind) {
    if (title.trim().isEmpty || cost <= 0) {
      throw StateError('Tên phần thưởng và số xu phải hợp lệ.');
    }
    rewards.add(
      FamilyReward(
        id: newId(),
        title: title.trim(),
        description: description.trim(),
        cost: cost,
        kind: kind,
        icon: '🎁',
      ),
    );
    changed();
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'dreamRewardId': dreamRewardId,
    'gold': gold,
    'blue': blue,
    'hunger': hunger,
    'energy': energy,
    'petPoints': petPoints,
    'xp': xp,
    'equipped': equipped,
    'childName': childName,
    'parentName': parentName,
    'role': role,
    'avatar': avatar,
    'age': age,
    'onboarded': onboarded,
    'quiet': quiet,
    'battleAllowed': battleAllowed,
    'notifications': notifications,
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'goals': goals.map((g) => g.toJson()).toList(),
    'rewards': rewards.map((r) => r.toJson()).toList(),
    'inventory': inventory,
    'transactions': transactions,
    'proposals': proposals,
    'redemptions': redemptions.map((r) => r.toJson()).toList(),
    'messages': messages,
    'completedBattles': completedBattles,
    'battleDay': battleDay,
    'activeBattle': activeBattle,
    'battlesUsed': battlesUsed,
  };

  /// Bản lưu không hợp lệ được báo lỗi để lớp lưu trữ giữ lại bản gốc cho phục hồi.
  factory AppStore.fromJson(Map<String, dynamic> j) {
    try {
      if (j['version'] != 1 ||
          j['gold'] is! int ||
          j['blue'] is! int ||
          j['gold'] < 0 ||
          j['blue'] < 0) {
        throw const FormatException('Dữ liệu ví không hợp lệ.');
      }
      final s = AppStore.seed();
      s.dreamRewardId = j['dreamRewardId'] ?? 'picnic';
      s.gold = j['gold'];
      s.blue = j['blue'];
      s.hunger = j['hunger'];
      s.energy = j['energy'];
      s.petPoints = j['petPoints'];
      s.xp = j['xp'];
      s.equipped = j['equipped'];
      s.childName = j['childName'];
      s.parentName = j['parentName'];
      s.role = j['role'];
      s.avatar = j['avatar'];
      s.age = j['age'];
      s.onboarded = j['onboarded'];
      s.quiet = j['quiet'];
      s.battleAllowed = j['battleAllowed'];
      s.notifications = j['notifications'];
      s.tasks = (j['tasks'] as List)
          .map((x) => KidTask.fromJson(Map<String, dynamic>.from(x)))
          .toList();
      s.goals = (j['goals'] as List)
          .map((x) => KidGoal.fromJson(Map<String, dynamic>.from(x)))
          .toList();
      s.rewards = (j['rewards'] as List)
          .map((x) => FamilyReward.fromJson(Map<String, dynamic>.from(x)))
          .toList();
      s.redemptions = (j['redemptions'] as List)
          .map((x) => Redemption.fromJson(Map<String, dynamic>.from(x)))
          .toList();
      s.inventory = Map<String, int>.from(j['inventory']);
      s.messages = (j['messages'] as List)
          .map((x) => Map<String, dynamic>.from(x))
          .toList();
      s.transactions = (j['transactions'] as List)
          .map((x) => Map<String, dynamic>.from(x))
          .toList();
      s.proposals = (j['proposals'] as List)
          .map((x) => Map<String, dynamic>.from(x))
          .toList();
      s.completedBattles = List<String>.from(j['completedBattles']);
      s.battleDay = j['battleDay'];
      s.activeBattle = j['activeBattle'];
      s.battlesUsed = j['battlesUsed'];
      if (s.hunger < 0 ||
          s.hunger > 100 ||
          s.energy < 0 ||
          s.energy > 100 ||
          s.inventory.values.any((n) => n < 0) ||
          s.tasks.any(
            (t) =>
                t.gold < 0 ||
                t.blue < 0 ||
                !['todo', 'pending', 'approved', 'retry'].contains(t.status),
          ) ||
          s.rewards.any((r) => r.cost <= 0)) {
        throw const FormatException('Giá trị lưu không hợp lệ.');
      }
      return s;
    } catch (e) {
      throw FormatException('Không đọc được dữ liệu gia đình: $e');
    }
  }
}
