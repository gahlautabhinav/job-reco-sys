import 'dart:convert';

class JobRecommendation {
  final String title;
  final String workType;
  final String salary;
  final double similarity;

  const JobRecommendation({
    required this.title,
    required this.workType,
    required this.salary,
    required this.similarity,
  });

  int get matchPercent => (similarity * 100).round();

  factory JobRecommendation.fromJson(Map<String, dynamic> json) {
    return JobRecommendation(
      title: json['Job Title'] as String,
      workType: json['Work Type'] as String,
      salary: json['Salary Range'] as String,
      similarity: (json['similarity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Job Title': title,
        'Work Type': workType,
        'Salary Range': salary,
        'similarity': similarity,
      };

  static List<JobRecommendation> listFromJson(String jsonStr) {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => JobRecommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<JobRecommendation> jobs) {
    return jsonEncode(jobs.map((j) => j.toJson()).toList());
  }

  // Composite key for bookmark deduplication
  String get bookmarkKey => '$title|$workType|$salary';

  @override
  bool operator ==(Object other) =>
      other is JobRecommendation && bookmarkKey == other.bookmarkKey;

  @override
  int get hashCode => bookmarkKey.hashCode;
}
