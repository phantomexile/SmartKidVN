part of '../app.dart';

extension _RewardScreens on _AppState {
  List<Widget> rewardsList({bool parent = false}) => [
    heading(
      parent ? 'Điều con mong muốn' : 'Con đang mong điều gì?',
      'Cùng nhau nỗ lực để biến ước mơ thành hiện thực!',
    ),
    if (parent)
      PrimaryButton('Thêm phần thưởng', () {
        rewardTitle.clear();
        rewardDescription.clear();
        go(15);
      }, icon: Icons.add_rounded),
    if (parent && s.redemptions.any((r) => r.status == 'pending'))
      SoftCard(
        color: KidColors.peach,
        onTap: () => go(16),
        child: Row(
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              color: KidColors.orange,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${s.redemptions.where((r) => r.status == 'pending').length} yêu cầu đổi thưởng đang chờ',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    const SizedBox(height: 8),
    dreamCard(),
    if (!parent)
      ChoiceTabs(
        ['Gia đình', 'Phần thưởng ảo'],
        rewardTab,
        (i) => refresh(() => rewardTab = i),
      ),
    ...s.rewards
        .where(
          (r) =>
              r.id != s.dreamRewardId &&
              (parent ||
                  (rewardTab == 0
                      ? r.kind != 'Phần thưởng ảo'
                      : r.kind == 'Phần thưởng ảo')),
        )
        .map(
          (r) => SoftCard(
            onTap: () {
              rewardId = r.id;
              go(31);
            },
            child: Row(
              children: [
                EmojiTile(r.icon, size: 72),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        r.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: KidColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CoinBadge(r.cost),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
    Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () => go(33),
            icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
            label: const Text('Ví của con'),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => go(34),
            icon: const Icon(Icons.workspace_premium_outlined, size: 18),
            label: const Text('Bộ sưu tập'),
          ),
        ),
      ],
    ),
  ];

  List<Widget> createReward() => [
    heading(
      'Một điều đáng mong chờ',
      'Tạo phần thưởng để cùng con nỗ lực nhé!',
    ),
    const Illustration('picnic', height: 210),
    fieldLabel('Tên phần thưởng'),
    TextField(
      controller: rewardTitle,
      decoration: const InputDecoration(hintText: 'Cả nhà đi picnic'),
    ),
    fieldLabel('Mô tả (không bắt buộc)'),
    TextField(
      controller: rewardDescription,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'Cùng cả nhà khám phá thiên nhiên...',
      ),
    ),
    fieldLabel('Xu vàng cần đổi'),
    TextField(
      controller: rewardCost,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.star_rounded),
        suffixText: 'xu vàng',
      ),
    ),
    fieldLabel('Loại phần thưởng'),
    Wrap(
      spacing: 6,
      children: ['Trải nghiệm', 'Món quà', 'Phần thưởng ảo']
          .map(
            (v) => ChoiceChip(
              label: Text(v),
              selected: rewardKind == v,
              onSelected: (_) => refresh(() => rewardKind = v),
            ),
          )
          .toList(),
    ),
    const SizedBox(height: 20),
    PrimaryButton('Lưu phần thưởng', () {
      final cost = int.tryParse(rewardCost.text);
      if (cost == null) {
        tell('Hãy nhập số xu hợp lệ.');
        return;
      }
      if (act(
        () => s.addReward(
          rewardTitle.text,
          rewardDescription.text,
          cost,
          rewardKind,
        ),
        success: 'Đã thêm điều con mong muốn!',
      )) {
        go(14);
      }
    }),
  ];

  List<Widget> rewardDetails() => [
    heading(
      reward.title,
      reward.id == 'picnic' ? 'Một ngày cả nhà cùng nhau' : reward.description,
    ),
    if (reward.id == 'picnic')
      const Illustration('picnic', height: 290)
    else
      SoftCard(
        color: KidColors.peach,
        child: SizedBox(
          height: 210,
          child: Center(child: EmojiTile(reward.icon, size: 140)),
        ),
      ),
    const SizedBox(height: 16),
    SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CoinBadge(s.gold, large: true),
              Expanded(
                child: Text(
                  ' / ${reward.cost} xu vàng',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProgressTrack(s.gold / reward.cost),
          const SizedBox(height: 8),
          Text(
            s.gold >= reward.cost
                ? 'Con đã đủ xu rồi!'
                : 'Còn ${reward.cost - s.gold} xu nữa',
            style: const TextStyle(fontSize: 12, color: KidColors.muted),
          ),
        ],
      ),
    ),
    tip(
      'Phần thưởng này do bố mẹ tạo để cùng con thực hiện.',
      emoji: '👨‍👩‍👧',
    ),
    PrimaryButton(
      s.gold >= reward.cost ? 'Đổi phần thưởng' : 'Chọn làm ước mơ',
      () {
        if (s.gold >= reward.cost) {
          go(32);
        } else {
          s.selectDream(rewardId);
          tell('Mình cùng hoàn thành việc để đến gần ước mơ nhé!');
          go(22);
        }
      },
    ),
  ];

  List<Widget> redeemConfirm() => [
    heading(
      s.gold >= reward.cost ? 'Con đã đủ xu rồi!' : 'Mình sắp đến ước mơ!',
      'Sẵn sàng đổi phần thưởng này?',
    ),
    const Illustration('pet', height: 220),
    const SizedBox(height: 16),
    SoftCard(
      child: Row(
        children: [
          EmojiTile(reward.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  reward.description,
                  style: const TextStyle(fontSize: 11, color: KidColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    SoftCard(
      child: Column(
        children: [
          for (final row in [
            ('Xu vàng hiện có', s.gold),
            ('Chi phí đổi thưởng', reward.cost),
            ('Còn lại sau khi đổi', (s.gold - reward.cost).clamp(0, s.gold)),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(row.$1, style: const TextStyle(fontSize: 12)),
                  ),
                  Text(
                    '${row.$2} xu vàng',
                    style: const TextStyle(
                      color: KidColors.orange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
    tip(
      'Bố mẹ sẽ cùng con chọn ngày và gửi lời nhắn để thống nhất thời gian phù hợp nhé!',
      emoji: '💌',
    ),
    PrimaryButton(
      'Đổi ${reward.cost} xu vàng',
      s.gold >= reward.cost
          ? () {
              if (act(
                () => s.redeemReward(rewardId),
                success: 'Đã gửi yêu cầu cho bố mẹ!',
              )) {
                go(30, root: true);
              }
            }
          : null,
    ),
    PrimaryButton('Để sau', back, outline: true, icon: null),
  ];

  List<Widget> redemptionRequest() {
    final pending = s.redemptions.where((r) => r.status == 'pending').toList();
    if (pending.isEmpty) {
      return [
        heading(
          'Cùng con chờ đón',
          'Yêu cầu đổi thưởng của con sẽ hiện ở đây.',
        ),
        const Illustration('picnic', height: 230),
        const SizedBox(height: 16),
        tip('Chưa có yêu cầu đang chờ. Cùng con tiếp tục những bước nhỏ nhé!'),
        ...s.redemptions.map(
          (r) => tip('${s.reward(r.rewardId).title} • ${r.date}', emoji: '🗓️'),
        ),
        PrimaryButton('Về phần thưởng gia đình', () => go(14)),
      ];
    }
    final request = pending.first;
    final r = s.reward(request.rewardId);
    return [
      heading(
        '${s.childName} đã đủ xu rồi!',
        'Cùng hiện thực hóa phần thưởng nhé!',
      ),
      const Illustration('picnic', height: 220),
      const SizedBox(height: 14),
      SoftCard(
        child: Row(
          children: [
            Expanded(
              child: Text(
                r.title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            CoinBadge(request.cost),
          ],
        ),
      ),
      tip('Chờ cùng con chọn ngày', emoji: '🕒', color: KidColors.peach),
      SoftCard(
        onTap: pickRewardDate,
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                redemptionDate == null
                    ? 'Chọn ngày phù hợp'
                    : '${redemptionDate!.day}/${redemptionDate!.month}/${redemptionDate!.year}',
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
      tip('Con đã kiên trì để đến đây. Thật tuyệt vời!'),
      PrimaryButton('Xác nhận cùng con', () {
        if (redemptionDate == null) {
          tell('Bố mẹ chọn ngày thực hiện nhé.');
          return;
        }
        if (act(
          () => s.confirmRedemption(
            request.id,
            redemptionDate!.toIso8601String().substring(0, 10),
          ),
          success: 'Đã hẹn ngày cùng con!',
        )) {
          redemptionDate = null;
          go(14);
        }
      }),
      PrimaryButton(
        'Chọn ngày khác',
        pickRewardDate,
        outline: true,
        icon: null,
      ),
    ];
  }

  Future<void> pickRewardDate() async {
    final now = DateTime.now();
    final value = await showDatePicker(
      context: navigator.currentContext!,
      initialDate: redemptionDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 730)),
    );
    if (value != null && mounted) refresh(() => redemptionDate = value);
  }

  List<Widget> wallet() => [
    heading(
      'Xu của mình',
      'Hai loại xu được dùng riêng\nvới những mục đích khác nhau.',
    ),
    SoftCard(
      color: KidColors.peach,
      padding: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoinBadge(s.gold, large: true, label: true),
          const SizedBox(height: 12),
          const Text(
            'Dành cho ước mơ',
            style: TextStyle(color: KidColors.muted),
          ),
        ],
      ),
    ),
    SoftCard(
      color: KidColors.sky,
      padding: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoinBadge(s.blue, large: true, blue: true, label: true),
          const SizedBox(height: 12),
          const Text('Chăm sóc pet', style: TextStyle(color: KidColors.muted)),
        ],
      ),
    ),
    sectionTitle('Gần đây'),
    if (s.transactions.isEmpty)
      tip('Những khoản xu con nhận và sử dụng sẽ được ghi lại ở đây.'),
    ...s.transactions.map(
      (t) => SoftCard(
        child: Row(
          children: [
            Icon(
              t['currency'] == 'gold' ? Icons.star_rounded : Icons.eco_rounded,
              color: t['currency'] == 'gold'
                  ? KidColors.orange
                  : KidColors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['title'],
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    t['time'].toString().substring(0, 16).replaceAll('T', ' '),
                    style: const TextStyle(
                      fontSize: 10,
                      color: KidColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${t['amount'] > 0 ? '+' : ''}${t['amount']}',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: t['currency'] == 'gold'
                    ? KidColors.orange
                    : KidColors.blue,
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  List<Widget> collection() => [
    heading(
      'Những điều con đã làm được',
      'Mỗi nỗ lực, dù nhỏ, đều rất đáng tự hào!',
    ),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final b in [
          (
            '🌱',
            'Bước đầu tiên',
            'Hoàn thành bước đầu tiên',
            s.tasks.any((t) => t.status == 'approved'),
          ),
          (
            '🏅',
            'Một tuần cố gắng',
            'Ghi nhận 7 việc tốt',
            s.tasks.where((t) => t.status == 'approved').length >= 7,
          ),
          (
            '📖',
            'Bạn của sách',
            'Hoàn thành mục tiêu đọc sách',
            s.progress(s.goal('books')) >= 10,
          ),
          (
            '⭐',
            'Người kiên trì',
            'Đổi huy hiệu bằng xu vàng',
            s.redemptions.any((r) => r.rewardId == 'badge'),
          ),
        ])
          SizedBox(
            width: 142,
            child: SoftCard(
              color: b.$4 ? KidColors.peach : const Color(0xFFF0EFE9),
              child: Column(
                children: [
                  Text(
                    b.$4 ? b.$1 : '🔒',
                    style: const TextStyle(fontSize: 54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    b.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    b.$3,
                    textAlign: TextAlign.center,
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
    tip(
      'Con đã tiến bộ thật nhiều. Mẹ rất tự hào về sự nỗ lực của con! ❤️',
      emoji: '👩',
    ),
    const Illustration('pet', height: 190),
  ];
}
