import 'package:flutter/material.dart';
import 'theme.dart';

/// Nút hành động lớn; chiều cao tối thiểu đủ để trẻ chạm chính xác.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label,
    this.onTap, {
    super.key,
    this.outline = false,
    this.blue = false,
    this.icon = Icons.arrow_forward_rounded,
  });
  final String label;
  final VoidCallback? onTap;
  final bool outline, blue;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final color = blue ? const Color(0xFF6479ED) : KidColors.orange;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: outline ? Colors.transparent : color,
            foregroundColor: outline ? color : Colors.white,
            disabledBackgroundColor: KidColors.line,
            minimumSize: const Size(0, 54),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: outline ? BorderSide(color: color) : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) const SizedBox(width: 24),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, size: 23),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.onTap,
    this.padding = 16,
  });
  final Widget child;
  final Color color;
  final VoidCallback? onTap;
  final double padding;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: KidColors.line.withValues(alpha: .8)),
            borderRadius: BorderRadius.circular(21),
          ),
          child: child,
        ),
      ),
    ),
  );
}

/// Hình được đóng gói trong ứng dụng, không cần mạng để hiển thị.
class Illustration extends StatelessWidget {
  const Illustration(
    this.name, {
    super.key,
    this.height = 210,
    this.radius = 22,
    this.alignment = Alignment.center,
  });
  final String name;
  final double height, radius;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$name.png',
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      alignment: alignment,
      excludeFromSemantics: true,
    ),
  );
}

class CoinBadge extends StatelessWidget {
  const CoinBadge(
    this.amount, {
    super.key,
    this.blue = false,
    this.label = false,
    this.large = false,
  });
  final int amount;
  final bool blue, label, large;
  @override
  Widget build(BuildContext context) {
    final color = blue ? KidColors.blue : const Color(0xFFFFAF14);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: large ? 50 : 26,
            height: large ? 50 : 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withValues(alpha: .65), color],
              ),
              border: Border.all(color: color.withValues(alpha: .4), width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: .12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              blue ? Icons.eco_rounded : Icons.star_rounded,
              size: large ? 32 : 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$amount',
                style: TextStyle(
                  fontSize: large ? 26 : 15,
                  fontWeight: FontWeight.w900,
                  color: large
                      ? (blue ? KidColors.blue : KidColors.orange)
                      : KidColors.ink,
                ),
              ),
              if (label)
                Text(
                  blue ? 'Xu xanh' : 'Xu vàng',
                  style: const TextStyle(fontSize: 11, color: KidColors.muted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmojiTile extends StatelessWidget {
  const EmojiTile(
    this.emoji, {
    super.key,
    this.size = 58,
    this.color = KidColors.peach,
  });
  final String emoji;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size * .26),
    ),
    child: Text(emoji, style: TextStyle(fontSize: size * .58)),
  );
}

class ProgressTrack extends StatelessWidget {
  const ProgressTrack(
    this.value, {
    super.key,
    this.color = KidColors.orange,
    this.height = 10,
  });
  final double value, height;
  final Color color;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: height,
      backgroundColor: KidColors.line,
      color: color,
    ),
  );
}

Widget heading(String title, [String? subtitle]) => Padding(
  padding: const EdgeInsets.only(top: 6, bottom: 22),
  child: Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 29,
          height: 1.17,
          fontWeight: FontWeight.w900,
        ),
      ),
      if (subtitle != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: KidColors.muted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
    ],
  ),
);
Widget sectionTitle(String title, {String? action, VoidCallback? onTap}) =>
    Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onTap,
              child: Text(action, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
Widget tip(String text, {String emoji = '🌱', Color color = KidColors.sage}) =>
    SoftCard(
      color: color,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
Widget fieldLabel(String title) => Padding(
  padding: const EdgeInsets.only(top: 14, bottom: 7),
  child: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
  ),
);
Widget pill(String label, {Color color = KidColors.sage}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    label,
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
  ),
);

class ChoiceTabs extends StatelessWidget {
  const ChoiceTabs(this.labels, this.selected, this.onChanged, {super.key});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFF3EFE5),
      borderRadius: BorderRadius.circular(17),
    ),
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 3),
              decoration: BoxDecoration(
                color: selected == i ? KidColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected == i ? Colors.white : KidColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
