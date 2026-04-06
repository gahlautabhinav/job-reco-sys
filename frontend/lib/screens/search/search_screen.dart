import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/profile_provider.dart';
import '../../providers/search_provider.dart';
import 'widgets/cold_start_loader.dart';
import 'widgets/empty_state.dart';
import 'widgets/job_card.dart';
import 'widgets/search_input_form.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<SearchProvider, ProfileProvider>(
          builder: (context, search, profile, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('JobFinder', style: AppTextStyles.displayLarge),
                        const SizedBox(height: 4),
                        Text(
                          'AI-powered job recommendations',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SearchInputForm(
                          initialParams: profile.profile.isEmpty
                              ? null
                              : profile.defaultSearchParams,
                          isLoading: search.isLoading,
                          onSearch: search.search,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Results / loading / empty state
                if (search.isLoading && !search.hasResults)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ColdStartLoader(
                        showColdStartBanner: search.isColdStart,
                      ),
                    ),
                  )
                else if (search.errorMessage != null && !search.hasResults)
                  SliverFillRemaining(
                    child: EmptyState(
                      errorMessage: search.errorMessage,
                      onRetry: search.retry,
                    ),
                  )
                else if (!search.hasResults)
                  SliverFillRemaining(
                    child: EmptyState(noMatches: search.hasSearched),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Row(
                        children: [
                          Text(
                            '${search.results.length} matches',
                            style: AppTextStyles.labelMedium,
                          ),
                          if (search.isLoading) ...[
                            const SizedBox(width: 8),
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          i == search.results.length - 1 ? 24 : 12,
                        ),
                        child: JobCard(job: search.results[i], index: i),
                      ),
                      childCount: search.results.length,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
