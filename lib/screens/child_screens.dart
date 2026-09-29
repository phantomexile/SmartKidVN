part of '../app.dart';

extension _ChildScreens on _AppState {
  List<Widget> childHome() => [
    Text(
      'Chào ${s.childName}!',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: -.8,
      ),
    ),
    const Text(
      'Hôm nay mình tiến thêm một bước',
      style: TextStyle(color: KidColors.muted),
    ),
    const SizedBox(height: 20),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            onTap: () => go(33),
            child: CoinBadge(s.gold, large: true, label: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SoftCard(
            color: KidColors.sky,
            onTap: () => go(33),
            child: CoinBadge(s.blue, blue: true, large: true, label: true),
          ),
        ),
      ],
    ),
    dreamCard(),
    sectionTitle('Việc hôm nay', action: 'Xem tất cả', onTap: () => go(22)),
    ...s.todayTasks.take(2).map(taskCard),
    SoftCard(
      color: KidColors.peach,
      padding: 0,
      onTap: () => go(35),
      child: Row(
        children: [
          const SizedBox(width: 96, child: Illustration('pet', height: 100)),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cáo Cam đang chờ con',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Cùng hoàn thành việc để nhận thêm xu nhé!',
                  style: TextStyle(fontSize: 12, color: KidColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    ),
    TextButton.icon(
      onPressed: () => go(19),
      icon: const Icon(Icons.favorite_border_rounded, size: 18),
      label: const Text('Góc nhỏ của gia đình'),
    ),
  ];

  List<Widget> dailyTasks() => [
    heading('Mình bắt đầu từ đâu?', 'Những việc nhỏ tạo nên ngày tuyệt vời'),
    Row(
      children: List.generate(7, (i) {
        final d = DateTime.now().subtract(
          Duration(days: DateTime.now().weekday - 1 - i),
        );
        final today = d.day == DateTime.now().day;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: today ? KidColors.orange : const Color(0xFFF6F1E8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  i == 6 ? 'CN' : 'T${i + 2}',
                  style: TextStyle(
                    fontSize: 10,
                    color: today ? Colors.white : KidColors.ink,
                  ),
                ),
                Text(
                  '${d.day}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: today ? Colors.white : KidColors.ink,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
    const SizedBox(height: 16),
    SoftCard(
      color: KidColors.sage,
      child: Row(
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: s.todayTasks.isEmpty
                      ? 0
                      : s.doneCount / s.todayTasks.length,
                  strokeWidth: 7,
                  backgroundColor: Colors.white,
                  color: KidColors.green,
                ),
                const Icon(Icons.eco_outlined, color: KidColors.green),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.doneCount} / ${s.todayTasks.length}',
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Đã gửi hoặc hoàn thành',
                  style: TextStyle(color: KidColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ...s.todayTasks.map(taskCard),
    if (s.todayTasks.isEmpty)
      tip(
        'Hôm nay chưa có việc theo lịch. Con có thể xem mục tiêu hoặc chơi với Cáo Cam nhé!',
      ),
    tip('Mỗi việc nhỏ là một bước tiến đến ước mơ lớn!', emoji: '🦊'),
  ];

  List<Widget> taskDetails() => [
    heading(task.title, 'Chuẩn bị sẵn sàng cho một ngày học tập vui vẻ!'),
    Stack(
      children: [
        const Illustration('study', height: 245),
        Positioned(
          top: 12,
          right: 12,
          child: pill('◷  10 phút', color: KidColors.cream),
        ),
      ],
    ),
    sectionTitle('Các bước thực hiện'),
    SoftCard(
      padding: 6,
      child: Column(
        children: List.generate(
          task.steps.length,
          (i) => CheckboxListTile(
            value: checkedSteps.contains(i) || task.status == 'approved',
            onChanged: ['todo', 'retry'].contains(task.status)
                ? (v) => refresh(() {
                    if (v!) {
                      checkedSteps.add(i);
                    } else {
                      checkedSteps.remove(i);
                    }
                  })
                : null,
            secondary: CircleAvatar(
              radius: 15,
              backgroundColor: KidColors.sage,
              child: Text('${i + 1}', style: const TextStyle(fontSize: 13)),
            ),
            title: Text(task.steps[i], style: const TextStyle(fontSize: 13)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    ),
    if (task.feedback.isNotEmpty) tip(task.feedback, emoji: '💬'),
    sectionTitle('Phần thưởng khi hoàn thành'),
    Row(
      children: [
        Expanded(
          child: SoftCard(
            color: KidColors.peach,
            child: CoinBadge(task.gold, large: true, label: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SoftCard(
            color: KidColors.sky,
            child: CoinBadge(task.blue, blue: true, large: true, label: true),
          ),
        ),
      ],
    ),
    PrimaryButton(
      task.status == 'approved'
          ? 'Xem lời ghi nhận'
          : task.status == 'pending'
          ? 'Đã gửi cho mẹ'
          : 'Mình đã làm xong',
      () {
        if (task.status == 'approved') {
          go(26);
          return;
        }
        if (task.status == 'pending') {
          go(25);
          return;
        }
        if (checkedSteps.length < task.steps.length) {
          tell('Con kiểm tra và đánh dấu đủ các bước nhé!');
          return;
        }
        doneChecked = false;
        go(24);
      },
    ),
  ];

  /// Giới hạn ảnh ngay khi chọn để bản lưu cục bộ không phình lớn không kiểm soát.
  Future<void> choosePhoto({bool camera = false}) async {
    refresh(() => loadingPhoto = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 65,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        if (bytes.length > 1000000) {
          tell('Ảnh cần nhỏ hơn 1 MB. Hãy chọn ảnh khác nhé.');
        } else if (mounted) {
          refresh(() => photo = base64Encode(bytes));
        }
      }
    } catch (_) {
      tell('Chưa mở được ảnh. Hãy kiểm tra quyền máy ảnh hoặc thư viện ảnh.');
    } finally {
      if (mounted) refresh(() => loadingPhoto = false);
    }
  }

  List<Widget> submitResult() => [
    heading(
      'Cho mẹ xem nào!',
      'Chụp ảnh việc đã hoàn thành để mẹ cùng vui nhé!',
    ),
    if (photo != null)
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.memory(
              base64Decode(photo!),
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: IconButton.filled(
              tooltip: 'Xóa ảnh',
              onPressed: () => refresh(() => photo = null),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      )
    else
      const Illustration('study', height: 220),
    Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: loadingPhoto ? null : () => choosePhoto(camera: true),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Chụp ảnh'),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: loadingPhoto ? null : choosePhoto,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Chọn ảnh'),
          ),
        ),
      ],
    ),
    if (loadingPhoto) const LinearProgressIndicator(),
    fieldLabel('Con muốn kể điều gì?'),
    TextField(
      controller: noteInput,
      maxLines: 3,
      maxLength: 500,
      decoration: const InputDecoration(hintText: 'Con đã tự xếp đủ sách rồi!'),
    ),
    CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: doneChecked,
      onChanged: (v) => refresh(() => doneChecked = v!),
      title: const Text('Mình đã hoàn thành'),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        '🔒  Ảnh chỉ lưu trên thiết bị này. Con có thể gửi kết quả không kèm ảnh.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: KidColors.muted),
      ),
    ),
    PrimaryButton('Gửi cho mẹ xem', () {
      if (!doneChecked) {
        tell('Con xác nhận đã hoàn thành nhé.');
        return;
      }
      if (act(() => s.submitTask(taskId, noteInput.text, photo))) {
        go(task.status == 'approved' ? 26 : 25);
      }
    }),
  ];

  List<Widget> resultSent() => [
    heading(
      'Con đã tiến\nthêm một bước!',
      'Mỗi nỗ lực hôm nay đều đưa con\nđến gần ước mơ hơn!',
    ),
    const Illustration('pet', height: 255),
    const SizedBox(height: 16),
    tip('Đã gửi cho mẹ', emoji: '✅'),
    taskCard(task),
    sectionTitle('Sau khi mẹ ghi nhận, con sẽ nhận:'),
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
    tip('Mẹ sẽ xem và gửi lời nhắn cho con nhé!', emoji: '💌'),
    PrimaryButton('Về trang của mình', () => go(21, root: true)),
  ];

  List<Widget> recognition() {
    final approved = s.tasks.where((t) => t.status == 'approved').toList();
    final t = task.status == 'approved'
        ? task
        : (approved.isEmpty ? null : approved.last);
    return [
      heading(
        t == null ? 'Mỗi nỗ lực đều đáng quý!' : 'Mẹ đã xem rồi!',
        t == null
            ? 'Bố mẹ sẽ gửi lời ghi nhận tại đây.'
            : 'Mẹ rất tự hào về sự nỗ lực của con!',
      ),
      const Illustration('study', height: 250),
      const SizedBox(height: 16),
      tip(
        t?.feedback.isNotEmpty == true
            ? t!.feedback
            : 'Mẹ luôn đồng hành cùng con mỗi ngày.',
        emoji: '💛',
      ),
      if (t != null) ...[
        tip('Đã hoàn thành • ${t.title}', emoji: '✅'),
        sectionTitle('Con nhận được:'),
        Row(
          children: [
            Expanded(
              child: SoftCard(
                color: KidColors.peach,
                child: CoinBadge(t.gold, large: true, label: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SoftCard(
                color: KidColors.sky,
                child: CoinBadge(t.blue, large: true, blue: true, label: true),
              ),
            ),
          ],
        ),
      ],
      PrimaryButton('Xem ước mơ của mình', () => go(30, root: true)),
    ];
  }

  List<Widget> goalProgress() => [
    heading(goal.title, 'Cùng nhau hoàn thành ${goal.total} bước nhé!'),
    const Illustration('welcome', height: 220, alignment: Alignment(0, .3)),
    const SizedBox(height: 16),
    SoftCard(
      color: KidColors.sage,
      child: Column(
        children: [
          Text(
            '${s.progress(goal)} / ${goal.total} bước',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          ProgressTrack(s.progress(goal) / goal.total, color: KidColors.green),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              goal.total,
              (i) => CircleAvatar(
                radius: 15,
                backgroundColor: i < s.progress(goal)
                    ? KidColors.green
                    : Colors.white,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: i < s.progress(goal)
                        ? Colors.white
                        : KidColors.muted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    ...s.tasks.where((t) => t.goalId == goal.id).map(taskCard),
    tip('Mỗi bước con làm được đều rất đáng tự hào!'),
    if (s.tasks.any(
      (t) => t.goalId == goal.id && ['todo', 'retry'].contains(t.status),
    ))
      PrimaryButton('Làm bước tiếp theo', () {
        final t = s.tasks.firstWhere(
          (t) => t.goalId == goal.id && ['todo', 'retry'].contains(t.status),
        );
        openTask(t.id);
      })
    else
      PrimaryButton(
        'Về mục tiêu của con',
        () => go(s.role == 'parent' ? 7 : 27),
      ),
  ];

  List<Widget> proposeGoal() => [
    heading('Điều con muốn thử', 'Hãy chia sẻ ước mơ mới của con nhé!'),
    const Illustration('welcome', height: 200),
    fieldLabel('Con muốn làm được gì?'),
    TextField(
      controller: proposalTitle,
      decoration: const InputDecoration(hintText: 'Tự đạp xe'),
    ),
    fieldLabel('Vì sao con muốn thử?'),
    TextField(
      controller: proposalReason,
      decoration: const InputDecoration(hintText: 'Con muốn đạp xe cùng bố'),
    ),
    fieldLabel('Chọn hình ảnh phù hợp'),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['🚲', '📖', '🌱', '🎨']
          .map(
            (v) => GestureDetector(
              onTap: () => refresh(() => proposalIcon = v),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: proposalIcon == v
                        ? KidColors.orange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: EmojiTile(v, size: 55),
              ),
            ),
          )
          .toList(),
    ),
    const SizedBox(height: 20),
    tip(
      'Bố mẹ sẽ cùng con lên kế hoạch và chia nhỏ thành những bước phù hợp nhé!',
      emoji: '👨‍👩‍👧',
    ),
    PrimaryButton('Gửi ý tưởng cho bố mẹ', () {
      if (proposalTitle.text.trim().isEmpty) {
        tell('Con hãy viết điều mình muốn thử nhé.');
        return;
      }
      s.proposals.add({
        'title': proposalTitle.text.trim(),
        'reason': proposalReason.text.trim(),
        'icon': proposalIcon,
      });
      s.changed();
      proposalTitle.clear();
      proposalReason.clear();
      tell('Đã gửi ý tưởng vào không gian bố mẹ!');
      go(27);
    }),
  ];
}
