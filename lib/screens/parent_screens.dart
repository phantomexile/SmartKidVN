part of '../app.dart';

extension _ParentScreens on _AppState {
  List<Widget> parentHome() => [
    Text(
      'Chào mẹ ${s.parentName}',
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
    ),
    const Text(
      'Cùng con tạo nên những ngày tuyệt vời!',
      style: TextStyle(color: KidColors.muted, fontSize: 12),
    ),
    const SizedBox(height: 18),
    SoftCard(
      color: KidColors.peach,
      onTap: () => go(5),
      child: Row(
        children: [
          EmojiTile(s.avatar, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              s.childName,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
    ),
    SoftCard(
      color: KidColors.sage,
      padding: 0,
      onTap: () {
        goalId = 'school';
        go(28);
      },
      child: Column(
        children: [
          const Illustration('study', height: 160),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cùng con tự lập',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const Text(
                  'Cùng con hình thành thói quen tốt mỗi ngày.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                ProgressTrack(s.progress(s.goals.first) / s.goals.first.total),
                const SizedBox(height: 7),
                Text(
                  '${s.progress(s.goals.first)} / ${s.goals.first.total} bước',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            onTap: () => go(11),
            child: Column(
              children: [
                CoinBadge(s.pendingCount, large: true),
                const SizedBox(height: 5),
                const Text('Chờ ghi nhận', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SoftCard(
            color: KidColors.sage,
            onTap: () => go(17),
            child: Column(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: KidColors.green,
                  size: 34,
                ),
                Text(
                  '${s.tasks.where((t) => t.status == 'approved').length} việc đã ghi nhận',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    sectionTitle('Con vừa chia sẻ', action: 'Xem tất cả', onTap: () => go(11)),
    if (s.pendingCount == 0)
      tip('Hôm nay chưa có kết quả chờ xem. Cùng động viên con nhé!')
    else
      ...s.tasks
          .where((t) => t.status == 'pending')
          .take(2)
          .map((t) => taskCard(t, review: true)),
    if (s.proposals.isNotEmpty) ...[
      sectionTitle('Ý tưởng của con'),
      ...s.proposals.map(
        (p) => SoftCard(
          onTap: () {
            goalTitle.text = p['title'];
            goalWish.text = p['reason'];
            go(8);
          },
          child: Row(
            children: [
              EmojiTile(p['icon']),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  p['title'],
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ],
    SoftCard(
      color: KidColors.sage,
      onTap: () => go(19),
      child: const Row(
        children: [
          Text('🌱', style: TextStyle(fontSize: 36)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gửi con một lời động viên',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  'Những lời yêu thương sẽ tiếp thêm động lực cho con mỗi ngày.',
                  style: TextStyle(fontSize: 12, color: KidColors.muted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    ),
    Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () => go(18),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: const Text('Lịch gia đình'),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => go(20),
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: const Text('Cài đặt'),
          ),
        ),
      ],
    ),
  ];

  List<Widget> goalsList({bool child = false}) => [
    heading(
      child ? 'Mình đang lớn lên' : 'Mục tiêu của con',
      'Những mục tiêu nhỏ tạo nên\nnhững bước tiến lớn',
    ),
    ChoiceTabs(
      [
        'Đang làm (${s.goals.where((g) => s.progress(g) < g.total).length})',
        'Đã đạt (${s.goals.where((g) => s.progress(g) == g.total).length})',
      ],
      goalTab,
      (i) => refresh(() => goalTab = i),
    ),
    ...s.goals
        .where(
          (g) =>
              goalTab == 0 ? s.progress(g) < g.total : s.progress(g) == g.total,
        )
        .map(goalCard),
    const SizedBox(height: 10),
    if (child) ...[
      const Illustration('study', height: 170),
      const SizedBox(height: 12),
      PrimaryButton(
        'Đề xuất mục tiêu',
        () => go(29),
        outline: true,
        icon: Icons.add_rounded,
      ),
    ] else
      PrimaryButton(
        'Cùng con tạo mục tiêu',
        () => go(8),
        icon: Icons.add_rounded,
      ),
    if (!child)
      TextButton.icon(
        onPressed: () => go(11),
        icon: const Icon(Icons.inbox_outlined),
        label: Text('Hộp chờ ghi nhận (${s.pendingCount})'),
      ),
  ];

  List<Widget> createGoal() => [
    heading(
      'Con muốn làm được gì?',
      'Cùng con biến ước mơ thành những\nbước nhỏ mỗi ngày',
    ),
    const Illustration('study', height: 190),
    fieldLabel('Tên mục tiêu'),
    TextField(
      controller: goalTitle,
      decoration: const InputDecoration(hintText: 'Tên mục tiêu'),
    ),
    fieldLabel('Điều con mong muốn'),
    TextField(
      controller: goalWish,
      decoration: const InputDecoration(hintText: 'Điều con mong muốn'),
    ),
    fieldLabel('Kỹ năng rèn luyện'),
    Wrap(
      spacing: 8,
      children: ['Tự lập', 'Kiên nhẫn', 'Chia sẻ']
          .map(
            (v) => ChoiceChip(
              label: Text(v),
              selected: skill == v,
              onSelected: (_) => refresh(() => skill = v),
            ),
          )
          .toList(),
    ),
    fieldLabel('Thời gian thực hiện'),
    DropdownButtonFormField<String>(
      initialValue: duration,
      items: [
        '1 tuần',
        '2 tuần',
        '1 tháng',
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => refresh(() => duration = v!),
    ),
    const SizedBox(height: 18),
    PrimaryButton('Chia thành bước nhỏ', () {
      if (goalTitle.text.trim().isEmpty) {
        tell('Hãy đặt tên mục tiêu nhé.');
        return;
      }
      go(9);
    }),
  ];

  List<Widget> goalSteps() => [
    heading(
      'Từng bước nhỏ',
      'Chia mục tiêu lớn thành những bước\nnhỏ để thực hiện hơn',
    ),
    ...List.generate(
      stepInputs.length,
      (i) => SoftCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: KidColors.orange,
              child: Text(
                '${i + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: stepInputs[i],
                decoration: InputDecoration(
                  labelText: 'Tên bước ${i + 1}',
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Xóa bước',
              onPressed: stepInputs.length <= 1
                  ? null
                  : () => refresh(() {
                      stepInputs.removeAt(i).dispose();
                    }),
              icon: const Icon(Icons.remove_circle_outline_rounded),
            ),
          ],
        ),
      ),
    ),
    PrimaryButton(
      'Thêm một bước',
      () => refresh(() => stepInputs.add(TextEditingController())),
      outline: true,
      icon: Icons.add_rounded,
    ),
    const SizedBox(height: 20),
    tip(
      'Những bước nhỏ giúp con dễ thành công và luôn có động lực mỗi ngày!',
      emoji: '🦊',
    ),
    PrimaryButton('Tiếp tục', () {
      if (stepInputs.any((c) => c.text.trim().isEmpty)) {
        tell('Mỗi bước cần có một cái tên nhé.');
        return;
      }
      go(10);
    }),
  ];

  List<Widget> goalSchedule() => [
    heading(
      'Lịch và phần thưởng',
      'Chọn lịch thực hiện và phần thưởng\ncho bước này',
    ),
    SoftCard(
      child: Row(
        children: [
          const EmojiTile('🎒'),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              goalTitle.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    ),
    fieldLabel('Lặp lại vào các ngày'),
    Wrap(
      spacing: 5,
      children: List.generate(
        7,
        (i) => FilterChip(
          label: Text(i == 6 ? 'CN' : 'T${i + 2}'),
          selected: repeatDays.contains(i + 1),
          onSelected: (v) => refresh(() {
            if (v) {
              repeatDays.add(i + 1);
            } else {
              repeatDays.remove(i + 1);
            }
          }),
        ),
      ),
    ),
    fieldLabel('Nhắc nhở vào lúc'),
    DropdownButtonFormField<String>(
      initialValue: reminderTime,
      items: [
        '07:00',
        '16:00',
        '19:00',
        '20:00',
        '20:30',
        '21:00',
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => refresh(() => reminderTime = v!),
    ),
    const SizedBox(height: 8),
    const Text(
      'Lịch được lưu trong ứng dụng; bản dùng thử chưa gửi thông báo hệ thống.',
      style: TextStyle(fontSize: 11, color: KidColors.muted),
    ),
    fieldLabel('Phần thưởng khi hoàn thành'),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            child: Column(
              children: [
                CoinBadge(stepGold, label: true, large: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => refresh(
                        () => stepGold = (stepGold - 5).clamp(0, 1000),
                      ),
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: () => refresh(() => stepGold += 5),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SoftCard(
            color: KidColors.sky,
            child: Column(
              children: [
                CoinBadge(stepBlue, blue: true, label: true, large: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => refresh(
                        () => stepBlue = (stepBlue - 1).clamp(0, 1000),
                      ),
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: () => refresh(() => stepBlue++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    fieldLabel('Ai sẽ ghi nhận?'),
    ChoiceTabs(
      ['Bố mẹ ghi nhận', 'Tự động ghi nhận'],
      autoApprove ? 1 : 0,
      (i) => refresh(() => autoApprove = i == 1),
    ),
    PrimaryButton('Lưu mục tiêu', () {
      if (act(
        () => s.addGoal(
          goalTitle.text,
          goalWish.text,
          skill,
          duration,
          stepInputs.map((c) => c.text).toList(),
          repeatDays.toList()..sort(),
          reminderTime,
          stepGold,
          stepBlue,
          autoApprove,
        ),
        success: 'Đã tạo mục tiêu cho con!',
      )) {
        go(7, root: true);
      }
    }),
  ];

  List<Widget> reviewInbox() => [
    heading(
      'Con vừa hoàn thành',
      'Những nỗ lực của con hôm nay\nđang chờ bố mẹ ghi nhận!',
    ),
    ChoiceTabs(
      ['Chờ xem (${s.pendingCount})', 'Đã ghi nhận'],
      inboxTab,
      (i) => refresh(() => inboxTab = i),
    ),
    ...s.tasks
        .where((t) => t.status == (inboxTab == 0 ? 'pending' : 'approved'))
        .map(
          (t) => SoftCard(
            onTap: () {
              taskId = t.id;
              go(12);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    EmojiTile(t.icon, size: 90),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: KidColors.sage,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          t.note.isEmpty ? 'Con đã hoàn thành rồi ạ!' : t.note,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  t.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.status == 'approved'
                      ? 'Đã ghi nhận nỗ lực'
                      : 'Chờ bố mẹ xem kết quả',
                  style: const TextStyle(color: KidColors.muted, fontSize: 12),
                ),
                PrimaryButton('Xem kết quả', () {
                  taskId = t.id;
                  go(12);
                }, outline: true),
              ],
            ),
          ),
        ),
    if (!s.tasks.any(
      (t) => t.status == (inboxTab == 0 ? 'pending' : 'approved'),
    ))
      tip('Chưa có kết quả trong mục này. Mỗi bước nhỏ đều đáng quý!'),
  ];

  List<Widget> reviewResult() => [
    heading('Một bước tiến của con'),
    taskCard(task),
    if (task.photo != null)
      ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.memory(
          base64Decode(task.photo!),
          height: 230,
          fit: BoxFit.cover,
        ),
      )
    else
      const Illustration('study', height: 230),
    const SizedBox(height: 14),
    tip(
      '“${task.note.isEmpty ? 'Con đã cố gắng hôm nay!' : task.note}”',
      emoji: s.avatar,
    ),
    fieldLabel('Nhận xét của bố mẹ'),
    TextField(controller: feedbackInput, maxLines: 2),
    fieldLabel('Phần thưởng'),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            child: CoinBadge(task.gold, large: true, label: true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SoftCard(
            color: KidColors.sky,
            child: CoinBadge(task.blue, blue: true, large: true, label: true),
          ),
        ),
      ],
    ),
    if (task.status == 'pending') ...[
      PrimaryButton('Ghi nhận nỗ lực', () {
        if (act(
          () => s.approveTask(taskId, feedbackInput.text),
          success: 'Đã ghi nhận nỗ lực và tặng xu cho con!',
        )) {
          go(11);
        }
      }),
      PrimaryButton('Cùng con thử lại', () => go(13), outline: true),
    ] else
      tip(
        task.status == 'approved'
            ? 'Bố mẹ đã ghi nhận kết quả này rồi.'
            : 'Kết quả này chưa được gửi để ghi nhận.',
      ),
  ];

  List<Widget> retryResult() => [
    heading(
      'Mình thử thêm\nmột bước nhé',
      'Mỗi nỗ lực nhỏ đều giúp con tiến bộ!',
    ),
    const Illustration('study', height: 250),
    const SizedBox(height: 14),
    taskCard(task),
    fieldLabel('Lời nhắn từ bố mẹ'),
    TextField(controller: feedbackInput, maxLines: 3),
    const SizedBox(height: 16),
    tip('Con có thể bổ sung và gửi lại.'),
    PrimaryButton('Gửi lời động viên', () {
      if (act(
        () => s.retryTask(taskId, feedbackInput.text),
        success: 'Đã gửi lời động viên cho con!',
      )) {
        go(11);
      }
    }),
  ];
}
