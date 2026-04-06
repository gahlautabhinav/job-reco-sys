import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_recommendation.dart';
import '../models/user_profile.dart';

class SearchParams {
  final String skills;
  final String experience;
  final String? workType;
  final String? expectedSalary;
  final int topN;

  const SearchParams({
    required this.skills,
    required this.experience,
    this.workType,
    this.expectedSalary,
    this.topN = 10,
  });

  factory SearchParams.fromProfile(UserProfile profile) => SearchParams(
        skills: profile.skills,
        experience: profile.experience,
        workType: profile.preferredWorkType,
        expectedSalary: profile.expectedSalary,
        topN: profile.topN,
      );

  /// Canonical key for caching — order-independent, lowercased
  String get cacheKey =>
      '${skills.trim().toLowerCase()}|${experience.trim().toLowerCase()}|${(workType ?? '').toLowerCase()}|${(expectedSalary ?? '').toLowerCase()}|$topN';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'skills': skills.trim(),
      'experience': experience.trim(),
      'top_n': topN,
    };
    if (workType != null && workType!.isNotEmpty) map['work_type'] = workType;
    if (expectedSalary != null && expectedSalary!.isNotEmpty) {
      map['expected_salary'] = expectedSalary;
    }
    return map;
  }
}

class ApiService {
  static const _baseUrl = 'https://kaal108-job-reco-api.hf.space';
  static const _timeout = Duration(seconds: 15);

  Future<List<JobRecommendation>> recommend(SearchParams params) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/recommend'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }

    return JobRecommendation.listFromJson(response.body);
  }

  /// Fire-and-forget warm-up ping to wake the Hugging Face container.
  void warmUp(SearchParams params) {
    http
        .post(
          Uri.parse('$_baseUrl/recommend'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params.toJson()),
        )
        .timeout(_timeout)
        .ignore();
  }
}
