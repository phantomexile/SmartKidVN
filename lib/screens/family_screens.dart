part of '../app.dart';

extension _FamilyScreens on _AppState {
  /// Thống kê lấy từ kết quả đã ghi nhận, không tăng theo số lần mở màn hình.
  List<Widget> journey() {
    final approved = s.tasks.where((t) => t.status == 'approved').length;
    return [
      heading(
        '${s.childName} đang lớn lên',
        'Mỗi ngày đều là một bước tiến tuyệt vời!',
      ),
      Row(
        children: [
          EmojiTile(s.avatar, size: 78),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.childName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${s.age} tuổi',
                  style: const TextStyle(color: KidColors.muted),
                ),
                const Text(
                  'Cùng con tạo nên phiên bản tốt đẹp hơn mỗi ngày!',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: ['Tự lập', 'Kiên nhẫn', 'Chia sẻ'].map((skillName) {
          final goals = s.goals.where((g) => g.skill == skillName).toList();
          final total = goals.fold<int>(0, (sum, g) => sum + g.total);
          final done = goals.fold<int>(0, (sum, g) => sum + s.progress(g));
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SoftCard(
                padding: 10,
                child: Column(
                  children: [
                    Text(
                      skillName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: total == 0 ? 0 : done / total,
                              strokeWidth: 7,
                              backgroundColor: KidColors.line,
                              color: skillName == 'Tự lập'
                                  ? KidColors.green
                                  : KidColors.orange,
                            ),
                          ),
                          Text(
                            '${total == 0 ? 0 : (done / total * 100).round()}%',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Đang lớn lên',
                      style: TextStyle(fontSize: 9, color: KidColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      sectionTitle('Số bước đã ghi nhận'),
      SoftCard(
        color: KidColors.sage,
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: KidColors.green,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$approved bước con đã làm được',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
      sectionTitle('Những cột mốc đáng nhớ'),
      ...s.goals.map(
        (g) => SoftCard(
          onTap: () {
            goalId = g.id;
            go(28);
          },
          child: Row(
            children: [
              EmojiTile(g.icon, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${s.progress(g)} / ${g.total} bước',
                      style: const TextStyle(
                        fontSize: 11,
                        color: KidColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      PrimaryButton(
        'Những ngày cùng con',
        () => go(18),
        outline: true,
        icon: Icons.calendar_month_outlined,
      ),
      const Illustration('picnic', height: 160),
    ];
  }

  List<Widget> calendar() {
    final first = DateTime(calendarDate.year, calendarDate.month, 1);
    final count = DateTime(calendarDate.year, calendarDate.month + 1, 0).day;
    final offset = first.weekday - 1;
    final selected =
        '${calendarDate.year}-${calendarDate.month.toString().padLeft(2, '0')}-${calendarDate.day.toString().padLeft(2, '0')}';
    final scheduled = s.tasks
        .where((t) => t.days.contains(calendarDate.weekday))
        .toList();
    final rewards = s.redemptions.where((r) => r.date == selected).toList();
    return [
      heading(
        'Những ngày cùng con',
        'Cùng lên kế hoạch cho những khoảnh khắc ý nghĩa!',
      ),
      SoftCard(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Tháng trước',
                  onPressed: () => refresh(
                    () => calendarDate = DateTime(
                      calendarDate.year,
                      calendarDate.month - 1,
                      1,
                    ),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    'Tháng ${calendarDate.month}, ${calendarDate.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  tooltip: 'Tháng sau',
                  onPressed: () => refresh(
                    () => calendarDate = DateTime(
                      calendarDate.year,
                      calendarDate.month + 1,
                      1,
                    ),
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Row(
              children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 11,
                            color: KidColors.muted,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 3,
              ),
              itemCount: count + offset,
              itemBuilder: (context, i) {
                final day = i - offset + 1;
                if (day < 1) return const SizedBox();
                return InkWell(
                  onTap: () => refresh(
                    () => calendarDate = DateTime(
                      calendarDate.year,
                      calendarDate.month,
                      day,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: day == calendarDate.day
                          ? KidColors.orange
                          : Colors.transparent,
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: day == calendarDate.day
                            ? FontWeight.w900
                            : FontWeight.w500,
                        color: day == calendarDate.day
                            ? Colors.white
                            : KidColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      sectionTitle(
        'Ngày ${calendarDate.day}/${calendarDate.month}',
        action: '${scheduled.length + rewards.length} hoạt động',
      ),
      ...scheduled.map(
        (t) => SoftCard(
          onTap: () {
            openTask(t.id);
          },
          child: Row(
            children: [
              Text(t.time, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(width: 12),
              Container(width: 3, height: 46, color: KidColors.orange),
              const SizedBox(width: 12),
              EmojiTile(t.icon, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
      ...rewards.map(
        (r) =>
            tip('Cùng thực hiện: ${s.reward(r.rewardId).title}', emoji: '🎁'),
      ),
      if (scheduled.isEmpty && rewards.isEmpty)
        tip('Hôm nay chưa có hoạt động đã lên lịch.'),
      SoftCard(
        color: KidColors.sage,
        onTap: () => go(19),
        child: const Row(
          children: [
            Text('💬', style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hôm nay con tự hào điều gì?',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    ];
  }

  List<Widget> familyMessages() => [
    heading('Góc nhỏ của gia đình', 'Cùng nhau chia sẻ, động viên mỗi ngày'),
    pill('Lời nhắn trên thiết bị này'),
    const SizedBox(height: 20),
    ...s.messages.map((m) {
      final mine = m['sender'] == s.role;
      return Padding(
        padding: const EdgeInsets.only(bottom: 18, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: mine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!mine) ...[
              EmojiTile(m['sender'] == 'parent' ? '👩' : s.avatar, size: 43),
              const SizedBox(width: 9),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: mine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    '${m['sender'] == 'parent' ? s.parentName : s.childName}  ·  ${m['time']}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: KidColors.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: mine ? KidColors.sage : Colors.white,
                      border: Border.all(color: KidColors.line),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(m['text']),
                  ),
                ],
              ),
            ),
            if (mine) ...[
              const SizedBox(width: 9),
              EmojiTile(m['sender'] == 'parent' ? '👩' : s.avatar, size: 43),
            ],
          ],
        ),
      );
    }),
    const SizedBox(height: 8),
    const Illustration('pet', height: 150),
    const SizedBox(height: 16),
    Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageInput,
            minLines: 1,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Viết lời nhắn...',
              counterText: '',
            ),
            onSubmitted: (_) => sendFamilyMessage(),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filled(
          tooltip: 'Gửi lời nhắn',
          onPressed: sendFamilyMessage,
          style: IconButton.styleFrom(backgroundColor: KidColors.orange),
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    ),
  ];
  void sendFamilyMessage() {
    if (act(() => s.sendMessage(messageInput.text))) messageInput.clear();
  }

  List<Widget> settings() => [
    heading('Gia đình mình', 'Quản lý hồ sơ và cài đặt chung'),
    SoftCard(
      color: KidColors.sage,
      onTap: () => go(3),
      child: Row(
        children: [
          const EmojiTile('👩', size: 70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.parentName,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text('Phụ huynh'),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
    for (final row in [
      (Icons.face_outlined, 'Hồ sơ của ${s.childName}', 4),
      (Icons.swap_horiz_rounded, 'Chuyển không gian', 5),
      (Icons.chat_bubble_outline_rounded, 'Lời nhắn gia đình', 19),
      (Icons.account_balance_wallet_outlined, 'Ví của con', 33),
      (Icons.calendar_today_outlined, 'Lịch gia đình', 18),
    ])
      SoftCard(
        onTap: () => go(row.$3),
        child: Row(
          children: [
            Icon(row.$1),
            const SizedBox(width: 16),
            Expanded(child: Text(row.$2)),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    SoftCard(
      padding: 4,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Quyền tham gia thi đấu',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            subtitle: const Text(
              'Cho phép con thi đấu mô phỏng',
              style: TextStyle(fontSize: 10),
            ),
            value: s.battleAllowed,
            onChanged: (v) {
              s.battleAllowed = v;
              s.changed();
            },
          ),
          SwitchListTile(
            title: const Text(
              'Thời gian yên tĩnh',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            subtitle: const Text(
              'Lưu tùy chọn 21:00 – 06:00',
              style: TextStyle(fontSize: 10),
            ),
            value: s.quiet,
            onChanged: (v) {
              s.quiet = v;
              s.changed();
            },
          ),
        ],
      ),
    ),
    tip(
      'Bản dùng thử lưu trên thiết bị. Chưa có đăng nhập máy chủ, đồng bộ gia đình hay thông báo đẩy.',
      emoji: '🏡',
    ),
    const SizedBox(height: 15),
    const Center(
      child: Text(
        'SmartKidVN',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
      ),
    ),
    const Center(
      child: Text(
        'Cùng con lớn lên mỗi ngày',
        style: TextStyle(fontSize: 11, color: KidColors.green),
      ),
    ),
    const SizedBox(height: 18),
    const Illustration('welcome', height: 140),
  ];
}
