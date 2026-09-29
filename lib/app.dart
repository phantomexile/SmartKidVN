import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'domain/app_store.dart';
import 'domain/models.dart';
import 'ui/theme.dart';
import 'ui/components.dart';

part 'screens/onboarding_screens.dart';
part 'screens/parent_screens.dart';
part 'screens/child_screens.dart';
part 'screens/family_screens.dart';
part 'screens/reward_screens.dart';
part 'screens/pet_screens.dart';

/// Cùng một trạng thái gia đình được chia sẻ giữa mọi màn hình và hai vai trò.
class SmartKidApp extends StatefulWidget {
  const SmartKidApp({
    super.key,
    required this.store,
    this.initialScreen,
    this.onSave,
  });
  final AppStore store;
  final int? initialScreen;
  final Future<void> Function(AppStore)? onSave;
  @override
  State<SmartKidApp> createState() => _AppState();
}

class _AppState extends State<SmartKidApp> with WidgetsBindingObserver {
  AppStore get s => widget.store;
  late int screen;
  final List<int> history = [];
  final messenger = GlobalKey<ScaffoldMessengerState>();
  final navigator = GlobalKey<NavigatorState>();
  String taskId = 'bag', goalId = 'school', rewardId = 'picnic', itemId = 'hat';
  int goalTab = 0, inboxTab = 0, shopTab = 0, rewardTab = 0, wardrobeTab = 0;
  final nameInput = TextEditingController();
  final parentInput = TextEditingController();
  final emailInput = TextEditingController();
  final goalTitle = TextEditingController(text: 'Tự chuẩn bị đi học');
  final goalWish = TextEditingController(text: 'Con muốn tự lập hơn');
  final noteInput = TextEditingController();
  final feedbackInput = TextEditingController(
    text: 'Mẹ thấy con đã rất cố gắng. Mẹ tự hào về con!',
  );
  final rewardTitle = TextEditingController();
  final rewardDescription = TextEditingController();
  final rewardCost = TextEditingController(text: '500');
  final messageInput = TextEditingController();
  final proposalTitle = TextEditingController();
  final proposalReason = TextEditingController();
  final stepInputs = [
    TextEditingController(text: 'Chuẩn bị cặp'),
    TextEditingController(text: 'Tự chọn quần áo'),
    TextEditingController(text: 'Sẵn sàng trước 7 giờ'),
  ];
  String skill = 'Tự lập',
      duration = '2 tuần',
      rewardKind = 'Trải nghiệm',
      proposalIcon = '🚲';
  Set<int> repeatDays = {1, 2, 3, 4, 5};
  String reminderTime = '20:00';
  bool autoApprove = false,
      agreed = false,
      doneChecked = false,
      loadingPhoto = false;
  int stepGold = 20, stepBlue = 5;
  Set<int> checkedSteps = {};
  String? photo;
  DateTime calendarDate = DateTime.now();
  DateTime? redemptionDate;
  int battleRound = 1;
  String currentBattle = '';
  String selectedOutfit = 'basic';

  @override
  void initState() {
    super.initState();
    s.syncDay();
    WidgetsBinding.instance.addObserver(this);
    screen =
        widget.initialScreen ??
        (s.onboarded ? (s.role == 'parent' ? 6 : 21) : 1);
    nameInput.text = s.childName;
    parentInput.text = s.parentName;
    selectedOutfit = s.equipped;
    s.addListener(_storeChanged);
  }

  void _storeChanged() {
    if (!mounted) return;
    setState(() {});
    if (widget.onSave != null) {
      widget.onSave!(s)
          .then((_) {
            if (mounted && s.storageError != null) {
              setState(() => s.storageError = null);
            }
          })
          .catchError((Object e) {
            if (mounted) {
              setState(
                () => s.storageError =
                    'Chưa lưu được thay đổi. Hãy kiểm tra bộ nhớ thiết bị rồi thử lại.',
              );
            }
          });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    s.removeListener(_storeChanged);
    for (final c in [
      nameInput,
      parentInput,
      emailInput,
      goalTitle,
      goalWish,
      noteInput,
      feedbackInput,
      rewardTitle,
      rewardDescription,
      rewardCost,
      messageInput,
      proposalTitle,
      proposalReason,
      ...stepInputs,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void refresh(VoidCallback f) => setState(f);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) s.syncDay();
  }

  /// Mọi lối vào nhiệm vụ đều đặt lại bản nháp, tránh gửi ảnh của việc khác.
  void openTask(String id, {bool review = false}) {
    s.syncDay();
    final t = s.task(id);
    taskId = id;
    checkedSteps = {};
    doneChecked = false;
    noteInput.text = t.note;
    photo = t.photo;
    go(review ? 12 : 23);
  }

  void go(int page, {bool root = false}) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      if (root) {
        history.clear();
      } else {
        history.add(screen);
      }
      screen = page;
    });
  }

  void back() => setState(
    () => screen = history.isEmpty
        ? (s.role == 'parent' ? 6 : 21)
        : history.removeLast(),
  );
  void tell(String text) => messenger.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
  bool act(VoidCallback action, {String? success}) {
    try {
      action();
      if (success != null) tell(success);
      return true;
    } on StateError catch (e) {
      tell(e.message);
      return false;
    } on FormatException catch (e) {
      tell(e.message);
      return false;
    }
  }

  KidTask get task => s.task(taskId);
  KidGoal get goal => s.goal(goalId);
  FamilyReward get reward => s.reward(rewardId);
  PetItem get item => PetItem.catalog.firstWhere((i) => i.id == itemId);

  /// Các nhóm điều hướng dùng chung nhưng giữ trang chủ riêng theo vai trò.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SmartKidVN',
    debugShowCheckedModeBanner: false,
    theme: kidTheme(),
    scaffoldMessengerKey: messenger,
    navigatorKey: navigator,
    locale: const Locale('vi'),
    supportedLocales: const [Locale('vi'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: PopScope(
      canPop: history.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) back();
      },
      child: ColoredBox(
        color: const Color(0xFFE8EDDF),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Scaffold(
              backgroundColor: KidColors.cream,
              body: SafeArea(
                child: Column(
                  children: [
                    if (s.storageError != null)
                      MaterialBanner(
                        content: Text(
                          s.storageError!,
                          style: const TextStyle(fontSize: 11),
                        ),
                        actions: [
                          TextButton(
                            onPressed: _storeChanged,
                            child: const Text('Thử lưu lại'),
                          ),
                        ],
                      ),
                    Expanded(
                      child: screen == 1
                          ? welcomeScreen()
                          : SingleChildScrollView(
                              key: ValueKey(screen),
                              padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [topBar(), ...pageContent()],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: hasBottomNav ? bottomNav() : null,
            ),
          ),
        ),
      ),
    ),
  );

  bool get hasBottomNav => [
    6,
    7,
    11,
    14,
    17,
    18,
    19,
    20,
    21,
    22,
    27,
    30,
    33,
    34,
    35,
    36,
    42,
  ].contains(screen);
  Widget topBar() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        if (![6, 21].contains(screen))
          IconButton(
            tooltip: 'Quay lại',
            onPressed: back,
            icon: const Icon(Icons.arrow_back_rounded),
            padding: EdgeInsets.zero,
          ),
        if ([6, 21].contains(screen))
          const Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'SmartKidVN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        const Spacer(),
        if ([8, 9, 10].contains(screen))
          Row(
            children: List.generate(
              3,
              (i) => Container(
                width: i == screen - 8 ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: i <= screen - 8 ? KidColors.orange : KidColors.line,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        if (screen > 5)
          IconButton(
            tooltip: 'Chọn không gian',
            onPressed: () => go(5),
            icon: const Icon(Icons.swap_horiz_rounded),
          ),
        if ([6, 21].contains(screen))
          IconButton(
            tooltip: 'Thông báo',
            onPressed: () => go(s.role == 'parent' ? 11 : 26),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
      ],
    ),
  );
  Widget bottomNav() {
    final parent = s.role == 'parent';
    final targets = parent ? [6, 7, 14, 17] : [21, 27, 30, 35];
    final labels = parent
        ? ['Hôm nay', 'Mục tiêu', 'Phần thưởng', 'Hành trình']
        : ['Hôm nay', 'Mục tiêu', 'Ước mơ', 'Pet'];
    final icons = parent
        ? [
            Icons.home_outlined,
            Icons.track_changes_rounded,
            Icons.card_giftcard_rounded,
            Icons.map_outlined,
          ]
        : [
            Icons.home_outlined,
            Icons.track_changes_rounded,
            Icons.star_outline_rounded,
            Icons.pets_outlined,
          ];
    int selected = screen >= 35
        ? 3
        : [14, 30, 33, 34].contains(screen)
        ? 2
        : [7, 11, 27].contains(screen)
        ? 1
        : [17, 18].contains(screen)
        ? 3
        : 0;
    return Container(
      decoration: const BoxDecoration(
        color: KidColors.cream,
        border: Border(top: BorderSide(color: KidColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => go(targets[i], root: true),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[i],
                          size: 26,
                          color: selected == i
                              ? KidColors.orange
                              : KidColors.ink,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected == i
                                ? FontWeight.w900
                                : FontWeight.w600,
                            color: selected == i
                                ? KidColors.orange
                                : KidColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> pageContent() => switch (screen) {
    2 => introduction(),
    3 => registration(),
    4 => childProfile(),
    5 => rolePicker(),
    6 => parentHome(),
    7 => goalsList(),
    8 => createGoal(),
    9 => goalSteps(),
    10 => goalSchedule(),
    11 => reviewInbox(),
    12 => reviewResult(),
    13 => retryResult(),
    14 => rewardsList(parent: true),
    15 => createReward(),
    16 => redemptionRequest(),
    17 => journey(),
    18 => calendar(),
    19 => familyMessages(),
    20 => settings(),
    21 => childHome(),
    22 => dailyTasks(),
    23 => taskDetails(),
    24 => submitResult(),
    25 => resultSent(),
    26 => recognition(),
    27 => goalsList(child: true),
    28 => goalProgress(),
    29 => proposeGoal(),
    30 => rewardsList(),
    31 => rewardDetails(),
    32 => redeemConfirm(),
    33 => wallet(),
    34 => collection(),
    35 => petHome(),
    36 => petShop(),
    37 => itemDetails(),
    38 => wardrobe(),
    39 => battlePrepare(),
    40 => battleScreen(),
    41 => battleResult(),
    42 => leaderboard(),
    _ => childHome(),
  };

  Widget taskCard(KidTask t, {bool review = false}) => SoftCard(
    color: t.status == 'approved' ? KidColors.sage : Colors.white,
    onTap: () => openTask(t.id, review: review),
    child: Row(
      children: [
        EmojiTile(t.icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  CoinBadge(t.gold),
                  const SizedBox(width: 14),
                  CoinBadge(t.blue, blue: true),
                ],
              ),
              if (t.status != 'todo')
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    switch (t.status) {
                      'pending' => 'Chờ mẹ xem',
                      'approved' => 'Đã ghi nhận',
                      _ => 'Cùng thử lại nhé',
                    },
                    style: const TextStyle(
                      fontSize: 11,
                      color: KidColors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Icon(
          t.status == 'approved'
              ? Icons.check_circle_rounded
              : Icons.chevron_right_rounded,
          color: t.status == 'approved' ? KidColors.green : KidColors.ink,
        ),
      ],
    ),
  );
  Widget goalCard(KidGoal g) => SoftCard(
    color: s.progress(g) == g.total ? KidColors.sage : Colors.white,
    onTap: () {
      goalId = g.id;
      go(28);
    },
    child: Row(
      children: [
        EmojiTile(g.icon, size: 72, color: KidColors.sage),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                g.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                g.skill,
                style: const TextStyle(fontSize: 11, color: KidColors.muted),
              ),
              const SizedBox(height: 9),
              ProgressTrack(s.progress(g) / g.total),
              const SizedBox(height: 5),
              Text(
                '${s.progress(g)} / ${g.total} bước',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded),
      ],
    ),
  );
  Widget dreamCard() => SoftCard(
    padding: 0,
    onTap: () {
      rewardId = s.dreamRewardId;
      go(31);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (s.dreamRewardId == 'picnic')
          const Illustration('picnic', height: 180)
        else
          Container(
            height: 160,
            color: KidColors.peach,
            alignment: Alignment.center,
            child: Text(
              s.reward(s.dreamRewardId).icon,
              style: const TextStyle(fontSize: 85),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ƯỚC MƠ CỦA CON',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                  color: KidColors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s.reward(s.dreamRewardId).title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ProgressTrack(
                      s.gold / s.reward(s.dreamRewardId).cost,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '${s.gold} / ${s.reward(s.dreamRewardId).cost}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
