import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/saved_jobs_provider.dart';
import '../../shared/widgets/frosted_card.dart';
import 'widgets/saved_job_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SavedJobsProvider>(
          builder: (context, saved, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Saved Jobs',
                                      style: AppTextStyles.displayLarge),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFF97316),
                                          Color(0xFFEF4444),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFF97316)
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${saved.count}',
                                      style:
                                          AppTextStyles.labelMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bookmarked positions',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFFD2BBFF)
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (saved.savedJobs.isEmpty)
                  SliverFillRemaining(
                    child: _EmptySavedState(),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          i == saved.savedJobs.length - 1 ? 24 : 10,
                        ),
                        child: SavedJobCard(
                          job: saved.savedJobs[i],
                          index: i,
                        ),
                      ),
                      childCount: saved.savedJobs.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FrostedCard(
              padding: const EdgeInsets.all(20),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 52,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text('No saved jobs yet', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark icon on any job to save it here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
