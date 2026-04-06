import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/job_recommendation.dart';
import '../../../providers/saved_jobs_provider.dart';
import '../../../shared/widgets/frosted_card.dart';
import '../../../shared/widgets/match_badge.dart';

class JobCard extends StatelessWidget {
  final JobRecommendation job;
  final int index;

  const JobCard({super.key, required this.job, required this.index});

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 80 * index);
    final gradientColors = AppColors.avatarGradientFor(index);

    return FrostedCard(
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
                    job.title.isNotEmpty
                        ? job.title[0].toUpperCase()
                        : '?',
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
              _BookmarkButton(job: job),
            ],
          ),
          const SizedBox(height: 14),
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
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(
            begin: 0.15,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutCubic);
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

class _BookmarkButton extends StatelessWidget {
  final JobRecommendation job;

  const _BookmarkButton({required this.job});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedJobsProvider>(
      builder: (context, saved, _) {
        final isBookmarked = saved.isBookmarked(job);
        return GestureDetector(
          onTap: () => saved.toggle(job),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isBookmarked)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cta.withValues(alpha: 0.18),
                    ),
                  ),
                Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked
                      ? AppColors.cta
                      : Colors.white.withValues(alpha: 0.45),
                  size: 24,
                ),
              ],
            )
                .animate(target: isBookmarked ? 1 : 0)
                .scaleXY(begin: 1, end: 1.25, duration: 150.ms)
                .then()
                .scaleXY(end: 1, duration: 100.ms),
          ),
        );
      },
    );
  }
}
