class User {
  final int id;
  final String fullName;
  final String email;
  final String? profilePictureUrl;
  final String? educationLevel;
  final String? department;
  final String? experienceLevel;
  final String? preferredCareerTrack;
  final List<String> skills;
  final String? experienceDescription;
  final String? careerInterests;
  final String? cvText;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePictureUrl,
    this.educationLevel,
    this.department,
    this.experienceLevel,
    this.preferredCareerTrack,
    this.skills = const [],
    this.experienceDescription,
    this.careerInterests,
    this.cvText,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      profilePictureUrl: json['profile_picture_url'],
      educationLevel: json['education_level'],
      department: json['department'],
      experienceLevel: json['experience_level'],
      preferredCareerTrack: json['preferred_career_track'],

      // ✅ FIXED — Supports BOTH String and List format.
      skills: json['skills'] == null
          ? []
          : json['skills'] is List
          ? (json['skills'] as List).map((e) => e.toString()).toList()
          : json['skills']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .toList(),

      experienceDescription: json['experience_description'],
      careerInterests: json['career_interests'],
      cvText: json['cv_text'],
    );
  }
}
