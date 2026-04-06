import '../models/job_recommendation.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class JobRepository {
  final ApiService _api;
  final DatabaseService _db;

  JobRepository(this._api, this._db);

  /// Stale-while-revalidate search.
  ///
  /// [onResults] is called once immediately with cached data (if any),
  /// then again with fresh API data. Caller should update state both times.
  Future<List<JobRecommendation>> search(
    SearchParams params, {
    void Function(List<JobRecommendation> stale)? onStaleResults,
  }) async {
    final key = params.cacheKey;
    final cached = await _db.getCached(key);

    if (cached != null) {
      onStaleResults?.call(cached.jobs);
      if (!cached.isStale) return cached.jobs;
    }

    final fresh = await _api.recommend(params);
    await _db.putCache(key, fresh);
    return fresh;
  }
}
