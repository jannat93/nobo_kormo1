class Resource {
  final int id;
  final String title;
  final String platform;
  final String url;
  final List<String> relatedSkills;
  final String costIndicator;
  final String description;

  Resource({
    required this.id,
    required this.title,
    required this.platform,
    required this.url,
    required this.relatedSkills,
    required this.costIndicator,
    required this.description,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      title: json['title'],
      platform: json['platform'],
      url: json['url'],
      relatedSkills: (json['related_skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      costIndicator: json['cost_indicator'] ?? 'Free',
      description: json['description'] ?? 'No description provided.',
    );
  }
}