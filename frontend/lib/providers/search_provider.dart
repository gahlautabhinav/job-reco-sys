import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/job_recommendation.dart';
import '../data/repositories/job_repository.dart';
import '../data/services/api_service.dart';

class SearchProvider extends ChangeNotifier {
  final JobRepository _repo;

  SearchProvider(this._repo);

  List<JobRecommendation> _results = [];
  bool _isLoading = false;
  bool _isColdStart = false;
  bool _hasSearched = false;
  String? _errorMessage;
  SearchParams? _lastParams;
  Timer? _coldStartTimer;

  List<JobRecommendation> get results => _results;
  bool get isLoading => _isLoading;
  bool get isColdStart => _isColdStart;
  bool get hasSearched => _hasSearched;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _results.isNotEmpty;
  SearchParams? get lastParams => _lastParams;

  Future<void> search(SearchParams params) async {
    _lastParams = params;
    _errorMessage = null;
    _isLoading = true;
    _isColdStart = false;
    _hasSearched = true;
    notifyListeners();

    // Show cold-start banner after 1.5s if still loading
    _coldStartTimer?.cancel();
    _coldStartTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isLoading) {
        _isColdStart = true;
        notifyListeners();
      }
    });

    try {
      final fresh = await _repo.search(
        params,
        onStaleResults: (stale) {
          _results = _dedupe(stale);
          notifyListeners();
        },
      );
      _results = _dedupe(fresh);
    } on TimeoutException {
      _errorMessage = 'Server took too long — tap to retry';
    } catch (e) {
      _errorMessage = 'Something went wrong — tap to retry';
    } finally {
      _coldStartTimer?.cancel();
      _isLoading = false;
      _isColdStart = false;
      notifyListeners();
    }
  }

  /// Keeps only the highest-match entry per job title.
  List<JobRecommendation> _dedupe(List<JobRecommendation> jobs) {
    final map = <String, JobRecommendation>{};
    for (final job in jobs) {
      final key = job.title.toLowerCase();
      if (!map.containsKey(key) || job.similarity > map[key]!.similarity) {
        map[key] = job;
      }
    }
    return map.values.toList()
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
  }

  Future<void> retry() async {
    if (_lastParams != null) await search(_lastParams!);
  }

  void clear() {
    _results = [];
    _errorMessage = null;
    _lastParams = null;
    _hasSearched = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _coldStartTimer?.cancel();
    super.dispose();
  }
}
