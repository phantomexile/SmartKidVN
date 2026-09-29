/// Một bước nhỏ của mục tiêu. Trạng thái được lưu theo tên để dễ nâng cấp dữ liệu.
class KidTask {
  KidTask({
    required this.id,
    required this.title,
    this.icon = '🎒',
    this.gold = 20,
    this.blue = 5,
    this.goalId = 'school',
    this.status = 'todo',
    this.note = '',
    this.feedback = '',
    this.photo,
    this.steps = const [
      'Xem thời khóa biểu',
      'Xếp sách vở',
      'Kiểm tra hộp bút',
    ],
    this.days = const [1, 2, 3, 4, 5],
    this.time = '20:00',
    this.autoApprove = false,
    this.occurrenceDay = '',
    List<String>? completedDays,
  }) : completedDays = completedDays ?? [];
  final String id, title, icon, goalId, time;
  final int gold, blue;
  final bool autoApprove;
  final List<String> steps;
  final List<int> days;
  String status, note, feedback;
  String? photo;
  String occurrenceDay;
  final List<String> completedDays;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'icon': icon,
    'gold': gold,
    'blue': blue,
    'goalId': goalId,
    'status': status,
    'note': note,
    'feedback': feedback,
    'photo': photo,
    'steps': steps,
    'days': days,
    'time': time,
    'autoApprove': autoApprove,
    'occurrenceDay': occurrenceDay,
    'completedDays': completedDays,
  };
  factory KidTask.fromJson(Map<String, dynamic> j) => KidTask(
    id: j['id'],
    title: j['title'],
    icon: j['icon'],
    gold: j['gold'],
    blue: j['blue'],
    goalId: j['goalId'],
    status: j['status'],
    note: j['note'],
    feedback: j['feedback'],
    photo: j['photo'],
    steps: List<String>.from(j['steps']),
    days: List<int>.from(j['days']),
    time: j['time'],
    autoApprove: j['autoApprove'],
    occurrenceDay: j['occurrenceDay'] ?? '',
    completedDays: List<String>.from(j['completedDays'] ?? []),
  );
}

/// Mục tiêu gồm các bước đã đạt từ trước và những nhiệm vụ đang thực hiện.
class KidGoal {
  KidGoal({
    required this.id,
    required this.title,
    this.wish = '',
    this.skill = 'Tự lập',
    this.icon = '🎒',
    this.total = 10,
    this.baseline = 0,
    this.duration = '2 tuần',
  });
  final String id, title, wish, skill, icon, duration;
  final int total, baseline;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'wish': wish,
    'skill': skill,
    'icon': icon,
    'total': total,
    'baseline': baseline,
    'duration': duration,
  };
  factory KidGoal.fromJson(Map<String, dynamic> j) => KidGoal(
    id: j['id'],
    title: j['title'],
    wish: j['wish'],
    skill: j['skill'],
    icon: j['icon'],
    total: j['total'],
    baseline: j['baseline'],
    duration: j['duration'],
  );
}

/// Phần thưởng gia đình sử dụng xu vàng; vật phẩm pet nằm ở mô hình riêng.
class FamilyReward {
  FamilyReward({
    required this.id,
    required this.title,
    required this.cost,
    this.description = '',
    this.icon = '🌳',
    this.kind = 'Trải nghiệm',
  });
  final String id, title, description, icon, kind;
  final int cost;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'cost': cost,
    'description': description,
    'icon': icon,
    'kind': kind,
  };
  factory FamilyReward.fromJson(Map<String, dynamic> j) => FamilyReward(
    id: j['id'],
    title: j['title'],
    cost: j['cost'],
    description: j['description'],
    icon: j['icon'],
    kind: j['kind'],
  );
}

/// Yêu cầu đổi thưởng giữ giá tại thời điểm đổi, tránh trừ xu lại khi chọn ngày.
class Redemption {
  Redemption({
    required this.id,
    required this.rewardId,
    required this.cost,
    this.status = 'pending',
    this.date = '',
  });
  final String id, rewardId;
  final int cost;
  String status, date;
  Map<String, dynamic> toJson() => {
    'id': id,
    'rewardId': rewardId,
    'cost': cost,
    'status': status,
    'date': date,
  };
  factory Redemption.fromJson(Map<String, dynamic> j) => Redemption(
    id: j['id'],
    rewardId: j['rewardId'],
    cost: j['cost'],
    status: j['status'],
    date: j['date'],
  );
}

/// Danh mục pet cố định: thức ăn tiêu hao, trang phục chỉ mua một lần.
class PetItem {
  const PetItem(
    this.id,
    this.name,
    this.icon,
    this.cost,
    this.category,
    this.benefit,
  );
  final String id, name, icon, category, benefit;
  final int cost;
  static const catalog = [
    PetItem('carrot', 'Cà rốt', '🥕', 10, 'food', '+20 no bụng'),
    PetItem('apple', 'Táo đỏ', '🍎', 18, 'food', '+15 năng lượng'),
    PetItem('hat', 'Mũ thám hiểm', '🪖', 50, 'outfit', 'Sức mạnh +3'),
    PetItem('space', 'Áo phi hành gia', '👨‍🚀', 80, 'outfit', 'Phòng thủ +4'),
    PetItem('bow', 'Nơ cam', '🎀', 30, 'outfit', 'Phòng thủ +2'),
  ];
}
