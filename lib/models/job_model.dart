class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final bool isRemote;
  final List<String> requiredSkills;
  final String experienceLevel;
  final String jobType;
  final String description;
  final String? salaryRange;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.isRemote,
    required this.requiredSkills,
    required this.experienceLevel,
    required this.jobType,
    required this.description,
    this.salaryRange,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'] ?? 'N/A',
      isRemote: json['is_remote'] ?? false,
      requiredSkills: (json['required_skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      experienceLevel: json['experience_level'] ?? 'Any',
      jobType: json['job_type'] ?? 'Full-time',
      description: json['description'] ?? 'No description provided.',
      salaryRange: json['salary_range'],
    );
  }
}