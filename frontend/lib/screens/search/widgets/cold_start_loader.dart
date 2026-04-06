import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/frosted_card.dart';

class ColdStartLoader extends StatelessWidget {
  final bool showColdStartBanner;

  const ColdStartLoader({super.key, this.showColdStartBanner = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showColdStartBanner) ...[
          _ColdStartBanner(),
          const SizedBox(height: 12),
        ],
        ...List.generate(3, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ShimmerCard(delay: Duration(milliseconds: 100 * i)),
        )),
      ],
    );
  }
}

class _ColdStartBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.cta,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Waking up server…',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.cta),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 600.ms)
        .then()
        .fadeOut(duration: 600.ms);
  }
}

class _ShimmerCard extends StatelessWidget {
  final Duration delay;

  const _ShimmerCard({required this.delay});

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 180, height: 20),
          const SizedBox(height: 8),
          _ShimmerBox(width: 80, height: 16),
          const SizedBox(height: 14),
          Row(
            children: [
              _ShimmerBox(width: 120, height: 14),
              const Spacer(),
              _ShimmerBox(width: 72, height: 24, radius: 12),
            ],
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          color: AppColors.shimmer,
          delay: delay,
        );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
