import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/gradient_button.dart';

class EmptyState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool noMatches;

  const EmptyState({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.noMatches = false,
  });

  bool get isError => errorMessage != null;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String title;
    final String subtitle;

    if (isError) {
      icon = Icons.wifi_off_rounded;
      title = 'Connection issue';
      subtitle = errorMessage ?? 'Something went wrong';
    } else if (noMatches) {
      icon = Icons.search_off_rounded;
      title = 'No matches found';
      subtitle = 'Try adding more skills (e.g. "python, sql, pandas") or adjusting your filters';
    } else {
      icon = Icons.search_rounded;
      title = 'Find your next role';
      subtitle = 'Enter comma-separated skills and your experience to get AI-powered job matches';
    }

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              if (isError && onRetry != null) ...[
                const SizedBox(height: 24),
                GradientButton(label: 'Retry', onPressed: onRetry, width: 140),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
