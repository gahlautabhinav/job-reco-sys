import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class MatchBadge extends StatelessWidget {
  final int matchPercent;
  final Duration delay;

  const MatchBadge({
    super.key,
    required this.matchPercent,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cta.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: matchPercent),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutExpo,
        builder: (context, value, _) => Text(
          '$value% match',
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .scaleXY(begin: 0.8, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack);
  }
}
