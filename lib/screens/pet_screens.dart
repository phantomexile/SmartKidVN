part of '../app.dart';

extension _PetScreens on _AppState {
  /// Chỉ số hiển thị trực tiếp từ trạng thái pet; thức ăn và trang phục có tác dụng riêng.
  Widget petScene({double height = 280, String? outfit}) {
    final wearing = outfit ?? s.equipped;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Illustration(
          wearing == 'basic' ? 'pet' : 'pet_$wearing',
          height: height,
        ),
        Positioned(
          bottom: 12,
          child: pill(
            'Cáo Cam · Cấp ${4 + s.xp ~/ 100}',
            color: KidColors.cream,
          ),
        ),
      ],
    );
  }

  Widget petStats() => SoftCard(
    child: Column(
      children: [
        for (final stat in [
          ('No bụng', s.hunger, Icons.restaurant_rounded, KidColors.green),
          ('Năng lượng', s.energy, Icons.bolt_rounded, const Color(0xFFFFBC35)),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(stat.$3, color: stat.$4, size: 22),
                const SizedBox(width: 10),
                SizedBox(
                  width: 79,
                  child: Text(
                    stat.$1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(child: ProgressTrack(stat.$2 / 100, color: stat.$4)),
                const SizedBox(width: 10),
                Text('${stat.$2}/100', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
      ],
    ),
  );
  List<Widget> petHome() => [
    Row(
      children: [
        const Expanded(
          child: Text(
            'Cáo Cam của mình',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -.8,
            ),
          ),
        ),
        InkWell(onTap: () => go(33), child: CoinBadge(s.blue, blue: true)),
      ],
    ),
    const Padding(
      padding: EdgeInsets.only(top: 6, bottom: 18),
      child: Text(
        'Cùng chăm sóc để Cáo Cam luôn khỏe mạnh!',
        style: TextStyle(color: KidColors.muted, fontSize: 12),
      ),
    ),
    petScene(),
    const SizedBox(height: 14),
    petStats(),
    Row(
      children: [
        Expanded(
          child: PrimaryButton(
            'Cho ăn',
            () => showFood(),
            icon: Icons.restaurant_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(
            'Trang phục',
            () {
              selectedOutfit = s.equipped;
              go(38);
            },
            outline: true,
            icon: Icons.checkroom_rounded,
          ),
        ),
      ],
    ),
    PrimaryButton(
      'Cửa hàng Cáo Cam',
      () => go(36),
      outline: true,
      icon: Icons.storefront_outlined,
    ),
    const SizedBox(height: 14),
    SoftCard(
      color: KidColors.sky,
      onTap: () => go(39),
      child: const Row(
        children: [
          Text('🏆', style: TextStyle(fontSize: 42)),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đấu trường vui',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Cùng Cáo Cam tham gia những thử thách thú vị',
                  style: TextStyle(fontSize: 12, color: KidColors.muted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    ),
  ];
  void showFood() {
    showModalBottomSheet<void>(
      context: navigator.currentContext!,
      backgroundColor: KidColors.cream,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              heading('Cáo Cam ăn gì nào?'),
              for (final food in PetItem.catalog.where(
                (i) => i.category == 'food',
              ))
                SoftCard(
                  onTap: () {
                    Navigator.pop(context);
                    if ((s.inventory[food.id] ?? 0) > 0) {
                      act(
                        () => s.feedPet(food.id),
                        success: 'Cáo Cam cảm ơn con!',
                      );
                    } else {
                      itemId = food.id;
                      go(37);
                    }
                  },
                  child: Row(
                    children: [
                      EmojiTile(food.icon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${s.inventory[food.id] ?? 0} trong túi · ${food.benefit}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (s.inventory[food.id] ?? 0) > 0 ? 'Cho ăn' : 'Mua thêm',
                        style: const TextStyle(
                          color: KidColors.orange,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> petShop() {
    final items = PetItem.catalog
        .where(
          (i) =>
              shopTab == 2 || i.category == (shopTab == 0 ? 'food' : 'outfit'),
        )
        .toList();
    return [
      Row(
        children: [
          const Expanded(
            child: Text(
              'Cửa hàng Cáo Cam',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
          ),
          CoinBadge(s.blue, blue: true),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 6, bottom: 20),
        child: Text(
          'Sắm đồ ngon và đồ xinh cho Cáo Cam nhé!',
          style: TextStyle(fontSize: 12, color: KidColors.muted),
        ),
      ),
      ChoiceTabs(
        ['Thức ăn', 'Trang phục', 'Tất cả'],
        shopTab,
        (i) => refresh(() => shopTab = i),
      ),
      LayoutBuilder(
        builder: (context, c) => Wrap(
          spacing: 12,
          runSpacing: 2,
          children: items
              .map(
                (i) => SizedBox(
                  width: (c.maxWidth - 12) / 2,
                  child: SoftCard(
                    padding: 12,
                    onTap: () {
                      itemId = i.id;
                      go(37);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: i.category == 'food'
                                ? KidColors.sage
                                : KidColors.sky,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            i.icon,
                            style: const TextStyle(fontSize: 73),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          i.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          i.benefit,
                          style: const TextStyle(
                            fontSize: 10,
                            color: KidColors.muted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: KidColors.sky,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: CoinBadge(i.cost, blue: true)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      tip(
        'Chỉ dùng xu xanh để mua đồ cho Cáo Cam. Xu vàng dành cho ước mơ của con nhé!',
        emoji: '🍃',
        color: KidColors.sky,
      ),
    ];
  }

  List<Widget> itemDetails() => [
    heading(item.name, 'Cùng Cáo Cam khám phá\nnhững vùng đất mới!'),
    if (item.category == 'outfit')
      petScene(height: 265, outfit: item.id)
    else
      SoftCard(
        color: KidColors.sage,
        child: SizedBox(
          height: 225,
          child: Center(
            child: Text(item.icon, style: const TextStyle(fontSize: 130)),
          ),
        ),
      ),
    const SizedBox(height: 16),
    tip(item.benefit, emoji: item.category == 'food' ? '🍽️' : '💪'),
    SoftCard(
      color: KidColors.sky,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoinBadge(item.cost, blue: true, large: true, label: true),
          const SizedBox(height: 8),
          Text(
            'Đang có: ${s.blue} xu xanh · Trong túi: ${s.inventory[item.id] ?? 0}',
            style: const TextStyle(color: KidColors.muted, fontSize: 12),
          ),
        ],
      ),
    ),
    PrimaryButton(
      item.category == 'outfit' && (s.inventory[item.id] ?? 0) > 0
          ? 'Mở tủ đồ'
          : 'Mua ${item.cost} xu xanh',
      () {
        if (item.category == 'outfit' && (s.inventory[item.id] ?? 0) > 0) {
          selectedOutfit = item.id;
          go(38);
          return;
        }
        act(
          () => s.purchaseItem(itemId),
          success: 'Đã thêm ${item.name.toLowerCase()} vào túi của Cáo Cam!',
        );
      },
      blue: true,
    ),
    if (item.category == 'food' && (s.inventory[item.id] ?? 0) > 0)
      PrimaryButton(
        'Cho Cáo Cam ăn',
        () => act(() => s.feedPet(itemId), success: 'Cáo Cam rất vui!'),
        outline: true,
      ),
    const SizedBox(height: 10),
    const Center(
      child: Text(
        'ⓘ  Xu vàng không thay đổi.',
        style: TextStyle(fontSize: 12, color: KidColors.muted),
      ),
    ),
  ];

  List<Widget> wardrobe() => [
    heading('Tủ đồ Cáo Cam', 'Thay đồ cho Cáo Cam thật phong cách!'),
    petScene(height: 270, outfit: selectedOutfit),
    const SizedBox(height: 16),
    SoftCard(
      color: KidColors.sage,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              '💪  Sức mạnh ${selectedOutfit == 'hat' ? 21 : 18}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: Text(
              '🛡️  Phòng thủ ${selectedOutfit == 'space'
                  ? 17
                  : selectedOutfit == 'bow'
                  ? 15
                  : 13}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    ),
    ChoiceTabs(
      ['Mũ', 'Áo', 'Phụ kiện'],
      wardrobeTab,
      (i) => refresh(() => wardrobeTab = i),
    ),
    Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final outfit
            in [
              const PetItem(
                'basic',
                'Áo cơ bản',
                '👕',
                0,
                'outfit',
                'Không cộng chỉ số',
              ),
              ...PetItem.catalog.where((i) => i.category == 'outfit'),
            ].where(
              (i) => wardrobeTab == 0
                  ? i.id == 'hat'
                  : wardrobeTab == 1
                  ? ['basic', 'space'].contains(i.id)
                  : i.id == 'bow',
            ))
          SizedBox(
            width: 140,
            child: SoftCard(
              color: outfit.id == selectedOutfit
                  ? KidColors.peach
                  : Colors.white,
              onTap: () => refresh(() => selectedOutfit = outfit.id),
              child: Column(
                children: [
                  Text(outfit.icon, style: const TextStyle(fontSize: 52)),
                  Text(
                    outfit.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    outfit.id == 'basic' || (s.inventory[outfit.id] ?? 0) > 0
                        ? 'Đã sở hữu'
                        : '${outfit.cost} xu xanh',
                    style: const TextStyle(
                      fontSize: 11,
                      color: KidColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
    const SizedBox(height: 18),
    PrimaryButton('Mặc cho Cáo Cam', () {
      if (act(
        () => s.equipItem(selectedOutfit),
        success: 'Cáo Cam trông thật phong cách!',
      )) {
        go(35);
      }
    }),
    PrimaryButton('Khám phá cửa hàng', () {
      shopTab = 1;
      go(36);
    }, outline: true),
  ];

  Widget battleStats() => SoftCard(
    color: const Color(0xFFEFEEFF),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final stat in [
          ('💪', s.equipped == 'hat' ? 21 : 18, 'Sức mạnh'),
          ('🛡️', s.equipped == 'space' ? 17 : 13, 'Phòng thủ'),
          ('⚡', s.energy, 'Năng lượng'),
        ])
          Expanded(
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${stat.$1} ${stat.$2}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  stat.$3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
      ],
    ),
  );
  List<Widget> battlePrepare() => [
    heading('Một trận đấu vui?', 'Cùng Cáo Cam thi đấu và kết bạn nhé!'),
    petScene(height: 230),
    const SizedBox(height: 14),
    battleStats(),
    SoftCard(
      color: KidColors.sky,
      child: const Column(
        children: [
          Text(
            'Đối thủ thân thiện',
            style: TextStyle(fontSize: 12, color: KidColors.muted),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🦊', style: TextStyle(fontSize: 58)),
              Text(
                'VS',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8E8AEC),
                ),
              ),
              Text('🐰', style: TextStyle(fontSize: 58)),
            ],
          ),
          Text('Thỏ Trắng'),
        ],
      ),
    ),
    tip(
      'Còn ${s.battlesLeft} lượt hôm nay. Thi đấu mô phỏng trên thiết bị, cùng chơi thật vui nhé!',
      emoji: '🏆',
      color: const Color(0xFFEFEEFF),
    ),
    PrimaryButton(
      s.activeBattle.isEmpty ? 'Tìm đối thủ' : 'Tiếp tục trận đấu',
      () {
        if (act(() {
          currentBattle = s.startBattle();
          battleRound = 1;
        })) {
          go(40);
        }
      },
      blue: true,
    ),
    TextButton(onPressed: () => go(42), child: const Text('Xem bảng xếp hạng')),
  ];

  /// Mỗi lần chạm diễn tiến một vòng; chỉ vòng cuối mới gọi phát thưởng một lần.
  List<Widget> battleScreen() => [
    heading('Cáo Cam vs Thỏ Trắng'),
    Center(child: pill('Vòng $battleRound / 3', color: KidColors.sky)),
    const SizedBox(height: 20),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            child: Column(
              children: [
                const Text(
                  'Cáo Cam',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                ProgressTrack(
                  (100 - battleRound * 9) / 100,
                  color: KidColors.green,
                ),
                Text('${100 - battleRound * 9}/100'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SoftCard(
            child: Column(
              children: [
                const Text(
                  'Thỏ Trắng',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                ProgressTrack((100 - battleRound * 25) / 100),
                Text('${100 - battleRound * 25}/100'),
              ],
            ),
          ),
        ),
      ],
    ),
    Stack(
      children: [
        petScene(height: 300),
        Positioned(
          bottom: 35,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: KidColors.cream.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text('🐰', style: TextStyle(fontSize: 74)),
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    tip('Cáo Cam dùng bước nhảy dũng cảm!', emoji: '✨'),
    PrimaryButton(battleRound < 3 ? 'Tiếp tục vòng đấu' : 'Xem kết quả', () {
      if (battleRound < 3) {
        refresh(() => battleRound++);
      } else {
        if (act(() => s.completeBattle(currentBattle))) go(41);
      }
    }, blue: true),
  ];
  List<Widget> battleResult() => [
    heading('Cáo Cam thắng rồi!', 'Cậu thật tuyệt vời!'),
    const Center(child: Text('🎉  🏆  🎉', style: TextStyle(fontSize: 48))),
    const SizedBox(height: 12),
    petScene(height: 245),
    const SizedBox(height: 16),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            child: const Column(
              children: [
                Text(
                  '+25',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
                ),
                Text('Điểm pet'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SoftCard(
            color: KidColors.sage,
            child: const Column(
              children: [
                Text(
                  '+10',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
                ),
                Text('Kinh nghiệm'),
              ],
            ),
          ),
        ),
      ],
    ),
    tip('Càng thi đấu càng tiến bộ! Chơi vui, tôn trọng mọi bạn.', emoji: '🌱'),
    PrimaryButton('Xem bảng xếp hạng', () => go(42)),
    PrimaryButton('Về nhà Cáo Cam', () => go(35, root: true), outline: true),
  ];
  List<Widget> leaderboard() {
    final rows = <(String, String, int)>[
      ('🐻', 'Gấu Nâu', 420),
      ('🐰', 'Thỏ Trắng', 385),
      ('🦊', 'Cáo Cam · ${s.childName}', s.petPoints),
      ('🐱', 'Mèo Xám', 290),
      ('🐶', 'Cún Vàng', 260),
    ]..sort((a, b) => b.$3.compareTo(a.$3));
    return [
      heading('Mùa phiêu lưu', 'Cùng nhau thi đấu, cùng nhau lớn lên!'),
      Center(child: pill('Bảng xếp hạng mô phỏng', color: KidColors.sky)),
      const SizedBox(height: 22),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [1, 0, 2]
            .map(
              (i) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(9),
                  constraints: BoxConstraints(minHeight: i == 0 ? 188 : 163),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? const Color(0xFFFFEAB6)
                        : i == 1
                        ? KidColors.sky
                        : KidColors.peach,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(rows[i].$1, style: const TextStyle(fontSize: 40)),
                      Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: KidColors.orange,
                        ),
                      ),
                      Text(
                        rows[i].$2,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${rows[i].$3}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 18),
      ...List.generate(
        rows.length,
        (i) => SoftCard(
          color: rows[i].$1 == '🦊' ? KidColors.peach : Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(rows[i].$1, style: const TextStyle(fontSize: 25)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rows[i].$2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${rows[i].$3}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      PrimaryButton(
        'Còn ${s.battlesLeft} lượt hôm nay',
        () => go(39),
        outline: true,
      ),
      tip(
        'Chơi vui, tôn trọng mọi bạn. Mỗi bạn đều là một người bạn tuyệt vời!',
      ),
    ];
  }
}
