part of '../app.dart';

extension _OnboardingScreens on _AppState {
  /// Màn chào mừng dùng hình phủ nền; nút luôn nằm trong vùng an toàn.
  Widget welcomeScreen() => LayoutBuilder(
    builder: (context, box) => Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/welcome.png',
          fit: BoxFit.cover,
          alignment: const Alignment(0, .2),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .32, .63, 1],
              colors: [
                Color(0xEFFFFBF3),
                Color(0x22FFFBF3),
                Colors.transparent,
                Color(0xFFFFFBF3),
              ],
            ),
          ),
        ),
        Positioned(
          top: 26,
          left: 24,
          right: 24,
          child: Column(
            children: [
              const Text(
                'SmartKidVN',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.7,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lớn lên\ncùng nhau',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: box.maxHeight < 650 ? 34 : 42,
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                  letterSpacing: -1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Từng bước nhỏ, mỗi ngày',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 22,
          left: 26,
          right: 26,
          child: Column(
            children: [
              PrimaryButton('Bắt đầu', () => go(2)),
              PrimaryButton(
                'Đăng nhập',
                () {
                  if (s.onboarded) {
                    go(5);
                  } else {
                    tell(
                      'Chưa có hồ sơ trên thiết bị này. Cùng tạo hồ sơ nhé!',
                    );
                    go(3);
                  }
                },
                outline: true,
                icon: null,
              ),
              const SizedBox(height: 9),
              const Text(
                'CÙNG CON LỚN LÊN MỖI NGÀY',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w800,
                  color: KidColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> introduction() => [
    heading('Mỗi cố gắng\nđều đáng quý'),
    for (final entry in [
      (
        1,
        'Cùng đặt\nmục tiêu',
        'Bố mẹ và con cùng chọn những mục tiêu phù hợp.',
        'study',
        KidColors.sage,
      ),
      (
        2,
        'Con ghi lại\nnỗ lực',
        'Con ghi lại những việc con đã cố gắng mỗi ngày.',
        'welcome',
        KidColors.sky,
      ),
      (
        3,
        'Ghi nhận &\nnhận xu',
        'Mỗi nỗ lực đều được ghi nhận và nhận xu vàng hoặc xu xanh.',
        'pet',
        KidColors.peach,
      ),
    ])
      SoftCard(
        color: entry.$5,
        padding: 0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pill(
                      '${entry.$1}  BƯỚC NHỎ',
                      color: Colors.white.withValues(alpha: .65),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.$2,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.$3, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            Expanded(child: Illustration(entry.$4, height: 178, radius: 20)),
          ],
        ),
      ),
    const SizedBox(height: 12),
    const Center(
      child: Text(
        '●  ○  ○',
        style: TextStyle(color: KidColors.orange, letterSpacing: 5),
      ),
    ),
    const SizedBox(height: 12),
    PrimaryButton('Tiếp tục', () => go(3)),
  ];

  List<Widget> registration() => [
    heading('Chào bố mẹ!', 'Bắt đầu hành trình cùng con'),
    const Illustration('study', height: 190),
    fieldLabel('Họ và tên'),
    TextField(
      controller: parentInput,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person_outline_rounded),
        hintText: 'Họ và tên',
      ),
    ),
    fieldLabel('Email'),
    TextField(
      controller: emailInput,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.mail_outline_rounded),
        hintText: 'Email (không bắt buộc trong bản dùng thử)',
      ),
    ),
    const SizedBox(height: 14),
    CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: agreed,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (v) => refresh(() => agreed = v!),
      title: const Text(
        'Tôi hiểu hồ sơ và ảnh chỉ lưu trên thiết bị này.',
        style: TextStyle(fontSize: 12),
      ),
    ),
    tip(
      'Bản dùng thử không tạo tài khoản trực tuyến. Gia đình có thể trải nghiệm hai vai trò trên cùng thiết bị.',
      emoji: '🏡',
    ),
    PrimaryButton('Tạo tài khoản', () {
      if (parentInput.text.trim().isEmpty) {
        tell('Bố mẹ hãy nhập tên nhé.');
        return;
      }
      if (emailInput.text.isNotEmpty &&
          !RegExp(
            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
          ).hasMatch(emailInput.text.trim())) {
        tell('Email chưa đúng định dạng.');
        return;
      }
      if (!agreed) {
        tell('Bố mẹ hãy xác nhận cách lưu hồ sơ trước nhé.');
        return;
      }
      s.parentName = parentInput.text.trim();
      s.changed();
      go(4);
    }),
    const SizedBox(height: 20),
    const Center(
      child: Text(
        'Một hành trình nhỏ, nhiều niềm vui lớn.',
        style: TextStyle(color: KidColors.muted, fontSize: 12),
      ),
    ),
  ];

  List<Widget> childProfile() => [
    heading(
      'Con tên là gì?',
      'Hãy tạo không gian riêng cho con\nthật đáng yêu nhé!',
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['👧', '👦', '🐱', '🐰']
          .map(
            (a) => GestureDetector(
              onTap: () {
                s.avatar = a;
                s.changed();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: s.avatar == a
                        ? KidColors.orange
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: EmojiTile(a, size: 57),
              ),
            ),
          )
          .toList(),
    ),
    fieldLabel('Tên của con'),
    TextField(
      controller: nameInput,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(hintText: 'Tên của con'),
    ),
    fieldLabel('Con bao nhiêu tuổi?'),
    Wrap(
      spacing: 8,
      runSpacing: 3,
      children: List.generate(
        7,
        (i) => ChoiceChip(
          label: Text('${i + 6} tuổi'),
          selected: s.age == i + 6,
          onSelected: (_) {
            s.age = i + 6;
            s.changed();
          },
          selectedColor: KidColors.peach,
        ),
      ),
    ),
    const SizedBox(height: 20),
    const Illustration('study', height: 160),
    const SizedBox(height: 16),
    PrimaryButton(
      s.onboarded ? 'Lưu hồ sơ của con' : 'Tạo không gian của con',
      () {
        if (nameInput.text.trim().isEmpty) {
          tell('Hãy nhập tên của con nhé.');
          return;
        }
        s.childName = nameInput.text.trim();
        s.onboarded = true;
        s.changed();
        go(5);
      },
    ),
  ];

  List<Widget> rolePicker() => [
    heading('Gia đình mình', 'Chọn không gian để bắt đầu nhé!'),
    SoftCard(
      padding: 0,
      onTap: () {
        s.role = 'parent';
        s.onboarded = true;
        s.changed();
        go(6, root: true);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Illustration('study', height: 170),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bố mẹ',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Quản lý mục tiêu, theo dõi hành trình\nvà đồng hành cùng con.',
                        style: TextStyle(color: KidColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ],
      ),
    ),
    SoftCard(
      padding: 0,
      onTap: () {
        s.role = 'child';
        s.onboarded = true;
        s.changed();
        go(21, root: true);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Illustration('picnic', height: 160),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.childName,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Ghi lại nỗ lực, nhận xu\nvà chăm sóc thú cưng.',
                        style: TextStyle(color: KidColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ],
      ),
    ),
    tip(
      'Hai không gian dùng chung dữ liệu trên thiết bị này. Đây chưa phải chế độ phân quyền trực tuyến.',
      emoji: '🤍',
    ),
    TextButton.icon(
      onPressed: () => go(4),
      icon: const Icon(Icons.edit_outlined),
      label: const Text('Chỉnh sửa hồ sơ của con'),
    ),
  ];
}
