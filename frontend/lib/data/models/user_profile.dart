class UserProfile {
  final String skills;
  final String experience;
  final String? preferredWorkType;
  final String? expectedSalary;
  final int topN;

  const UserProfile({
    this.skills = '',
    this.experience = '',
    this.preferredWorkType,
    this.expectedSalary,
    this.topN = 10,
  });

  bool get isEmpty => skills.isEmpty && experience.isEmpty;

  UserProfile copyWith({
    String? skills,
    String? experience,
    String? preferredWorkType,
    String? expectedSalary,
    int? topN,
    bool clearWorkType = false,
    bool clearSalary = false,
  }) {
    return UserProfile(
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      preferredWorkType:
          clearWorkType ? null : (preferredWorkType ?? this.preferredWorkType),
      expectedSalary:
          clearSalary ? null : (expectedSalary ?? this.expectedSalary),
      topN: topN ?? this.topN,
    );
  }

  Map<String, dynamic> toDbMap() => {
        'id': 1,
        'skills': skills,
        'experience': experience,
        'preferred_work_type': preferredWorkType,
        'expected_salary': expectedSalary,
        'top_n': topN,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

  factory UserProfile.fromDbMap(Map<String, dynamic> map) => UserProfile(
        skills: map['skills'] as String? ?? '',
        experience: map['experience'] as String? ?? '',
        preferredWorkType: map['preferred_work_type'] as String?,
        expectedSalary: map['expected_salary'] as String?,
        topN: map['top_n'] as int? ?? 10,
      );
}
