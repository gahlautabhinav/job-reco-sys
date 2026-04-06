import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/job_recommendation.dart';
import '../../../providers/saved_jobs_provider.dart';
import '../../../shared/widgets/frosted_card.dart';
import '../../../shared/widgets/match_badge.dart';

class SavedJobCard extends StatelessWidget {
  final JobRecommendation job;
  final int index;

  const SavedJobCard({super.key, required this.job, required this.index});

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 60 * index);
    final gradientColors = AppColors.avatarGradientFor(index);

    return Dismissible(
      key: ValueKey(job.bookmarkKey),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              'Remove',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        context.read<SavedJobsProvider>().toggle(job);
      },
      child: FrostedCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      job.title.isNotEmpty ? job.title[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: AppTextStyles.titleLarge),
                      const SizedBox(height: 5),
                      _WorkTypePill(workType: job.workType),
                    ],
                  ),
                ),
                // Bookmark (remove) icon with glow
                GestureDetector(
                  onTap: () => context.read<SavedJobsProvider>().toggle(job),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cta.withValues(alpha: 0.15),
                          ),
                        ),
                        const Icon(
                          Icons.bookmark_rounded,
                          color: AppColors.cta,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 15,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 5),
                Text(
                  job.salary,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                MatchBadge(matchPercent: job.matchPercent, delay: delay),
              ],
            ),
            const SizedBox(height: 14),
            // Apply Now button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cta.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Apply Now',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 350.ms)
        .slideX(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

class _WorkTypePill extends StatelessWidget {
  final String workType;

  const _WorkTypePill({required this.workType});

  List<Color> get _colors {
    switch (workType.toLowerCase()) {
      case 'full-time':
        return [AppColors.secondary, const Color(0xFF06B6D4)];
      case 'part-time':
        return [AppColors.primary, const Color(0xFF8B5CF6)];
      default:
        return [AppColors.cta, const Color(0xFFEF4444)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.35),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        workType,
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
