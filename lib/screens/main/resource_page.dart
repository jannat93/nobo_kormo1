import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Model for a Learning Resource ---
class LearningResource {
  final String title;
  final String platform;
  final String url;
  final List<String> skills;
  final String cost; // Free / Paid
  final String imagePath;

  const LearningResource({
    required this.title,
    required this.platform,
    required this.url,
    required this.skills,
    required this.cost,
    required this.imagePath,
  });
}

// --- Resource Page ---
class ResourcePage extends StatelessWidget {
  const ResourcePage({super.key});

  final List<LearningResource> resources = const [
    LearningResource(
      title: "HTML for Beginners",
      platform: "YouTube",
      url: "https://www.youtube.com/",
      skills: ["HTML", "Web Development"],
      cost: "Free",
      imagePath: "assets/images/HTML.jpeg",
    ),
    LearningResource(
      title: "CSS Flexbox & Grid",
      platform: "Coursera",
      url: "https://www.coursera.org/",
      skills: ["CSS", "Design"],
      cost: "Paid",
      imagePath: "assets/images/CSS.jpeg",
    ),
    LearningResource(
      title: "JavaScript Essentials",
      platform: "Udemy",
      url: "https://www.udemy.com/",
      skills: ["JS", "Frontend Development"],
      cost: "Paid",
      imagePath: "assets/images/java.jpeg",
    ),
    LearningResource(
      title: "Flutter & Dart Beginner",
      platform: "YouTube",
      url: "https://www.youtube.com/",
      skills: ["Flutter", "Mobile App"],
      cost: "Free",
      imagePath: "assets/images/flutter.jpeg",
    ),
    LearningResource(
      title: "Excel Basics",
      platform: "Coursera",
      url: "https://www.coursera.org/",
      skills: ["Excel", "Data Analysis"],
      cost: "Paid",
      imagePath: "assets/images/data.jpeg",
    ),
    LearningResource(
      title: "UI/UX Design Fundamentals",
      platform: "Udemy",
      url: "https://www.udemy.com/",
      skills: ["UI", "UX", "Design"],
      cost: "Paid",
      imagePath: "assets/images/ui.jpeg",
    ),
    LearningResource(
      title: "Effective Communication",
      platform: "YouTube",
      url: "https://www.youtube.com/",
      skills: ["Communication", "Soft Skills"],
      cost: "Free",
      imagePath: "assets/images/communication.png",
    ),
    LearningResource(
      title: "Python for Data Science",
      platform: "Coursera",
      url: "https://www.coursera.org/",
      skills: ["Python", "Data Analysis"],
      cost: "Paid",
      imagePath: "assets/images/python.jpeg",
    ),
    LearningResource(
      title: "React JS Complete Guide",
      platform: "Udemy",
      url: "https://www.udemy.com/",
      skills: ["React", "Frontend"],
      cost: "Paid",
      imagePath: "assets/images/react.png",
    ),
    LearningResource(
      title: "Digital Marketing Basics",
      platform: "YouTube",
      url: "https://www.youtube.com/",
      skills: ["Marketing", "SEO"],
      cost: "Free",
      imagePath: "assets/images/marketing.png",
    ),
    LearningResource(
      title: "SQL Essentials",
      platform: "Coursera",
      url: "https://www.coursera.org/",
      skills: ["SQL", "Database"],
      cost: "Paid",
      imagePath: "assets/images/sql.png",
    ),
    LearningResource(
      title: "Project Management Fundamentals",
      platform: "Udemy",
      url: "https://www.udemy.com/",
      skills: ["Management", "Soft Skills"],
      cost: "Paid",
      imagePath: "assets/images/project.png",
    ),
    LearningResource(
      title: "Java Programming Basics",
      platform: "YouTube",
      url: "https://www.youtube.com/",
      skills: ["Java", "Programming"],
      cost: "Free",
      imagePath: "assets/images/java.png",
    ),
    LearningResource(
      title: "Figma for Beginners",
      platform: "Udemy",
      url: "https://www.udemy.com/",
      skills: ["UI", "Design"],
      cost: "Paid",
      imagePath: "assets/images/figma.png",
    ),
    LearningResource(
      title: "Excel Advanced Formulas",
      platform: "Coursera",
      url: "https://www.coursera.org/",
      skills: ["Excel", "Data Analysis"],
      cost: "Paid",
      imagePath: "assets/images/excel.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;

    if (screenWidth > 1200) {
      crossAxisCount = 3;
    } else if (screenWidth > 800) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text(
              'Learning Resources',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: resources.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final resource = resources[index];
            return ResourceCard(resource: resource);
          },
        ),
      ),
    );
  }
}

// --- Resource Card Widget ---
class ResourceCard extends StatelessWidget {
  final LearningResource resource;

  const ResourceCard({super.key, required this.resource});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(resource.url),
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  resource.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
              ),
            ),
            // Text info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resource.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      resource.platform + " • " + resource.cost,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      resource.skills.join(", "),
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}