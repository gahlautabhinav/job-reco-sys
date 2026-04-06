import 'package:flutter/foundation.dart';
import '../data/models/job_recommendation.dart';
import '../data/services/database_service.dart';

class SavedJobsProvider extends ChangeNotifier {
  final DatabaseService _db;

  SavedJobsProvider(this._db);

  List<JobRecommendation> _savedJobs = [];

  List<JobRecommendation> get savedJobs => _savedJobs;
  int get count => _savedJobs.length;

  Future<void> loadAll() async {
    _savedJobs = await _db.getBookmarks();
    notifyListeners();
  }

  bool isBookmarked(JobRecommendation job) =>
      _savedJobs.any((j) => j.bookmarkKey == job.bookmarkKey);

  Future<void> toggle(JobRecommendation job) async {
    if (isBookmarked(job)) {
      await _db.removeBookmark(job);
      _savedJobs.removeWhere((j) => j.bookmarkKey == job.bookmarkKey);
    } else {
      await _db.addBookmark(job);
      _savedJobs.insert(0, job);
    }
    notifyListeners();
  }
}
