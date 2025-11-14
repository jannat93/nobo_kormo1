import 'package:flutter/material.dart';

class InternshipPage extends StatelessWidget {
  final List<Map<String, dynamic>> internships = [
    {
      'company': 'BrainMachineAI',
      'title': 'UI/UX Design Intern',
      'duration': '3 Months',
      'location': 'Remote',
      'stipend': 'BDT 8,000/month',
      'type': 'Part-time',
      'description':
      'Work on mobile and web UI/UX projects, design user flows and prototypes.',
      'requirements': [
        'Familiarity with Figma/Adobe XD',
        'Understanding of user-centered design',
        'Good communication skills'
      ],
      'image': 'assets/images/ui.jpeg'
    },
    {
      'company': 'TechSoft Ltd',
      'title': 'Flutter Developer Intern',
      'duration': '4 Months',
      'location': 'On-site, Dhaka',
      'stipend': 'BDT 10,000/month',
      'type': 'Full-time',
      'description':
      'Develop cross-platform mobile apps using Flutter and integrate APIs.',
      'requirements': [
        'Knowledge of Dart and Flutter',
        'Experience with REST APIs',
        'Problem-solving skills'
      ],
      'image': 'assets/images/flutter.jpeg'
    },
    {
      'company': 'DataMind',
      'title': 'Data Science Intern',
      'duration': '3 Months',
      'location': 'Remote',
      'stipend': 'BDT 12,000/month',
      'type': 'Part-time',
      'description':
      'Analyze datasets, build predictive models, and visualize insights.',
      'requirements': [
        'Python & Pandas',
        'Basic statistics knowledge',
        'Data visualization skills'
      ],
      'image': 'assets/images/data.jpeg'
    },
    {
      'company': 'MarketingPro',
      'title': 'Digital Marketing Intern',
      'duration': '2 Months',
      'location': 'Hybrid, Chittagong',
      'stipend': 'BDT 6,000/month',
      'type': 'Part-time',
      'description':
      'Run social media campaigns, analyze marketing data and create content.',
      'requirements': [
        'Familiarity with social media platforms',
        'Basic SEO knowledge',
        'Creative thinking'
      ],
      'image': 'assets/images/marketing.png'
    },
    {
      'company': 'WebHive',
      'title': 'Frontend Developer Intern',
      'duration': '3 Months',
      'location': 'Remote',
      'stipend': 'BDT 9,000/month',
      'type': 'Full-time',
      'description':
      'Develop responsive web interfaces using HTML, CSS, and JavaScript.',
      'requirements': [
        'Knowledge of HTML, CSS, JS',
        'Basic React experience',
        'Problem-solving skills'
      ],
      'image': 'assets/images/frontend.png'
    },
    {
      'company': 'CloudTech',
      'title': 'Cloud Computing Intern',
      'duration': '3 Months',
      'location': 'Remote',
      'stipend': 'BDT 11,000/month',
      'type': 'Part-time',
      'description':
      'Assist in deploying applications on cloud infrastructure and maintaining cloud services.',
      'requirements': [
        'Knowledge of AWS or Azure',
        'Basic Linux skills',
        'Good team collaboration'
      ],
      'image': 'assets/images/cloud.jpeg'
    },
    {
      'company': 'AI Solutions',
      'title': 'Machine Learning Intern',
      'duration': '4 Months',
      'location': 'Remote',
      'stipend': 'BDT 12,000/month',
      'type': 'Full-time',
      'description':
      'Work on ML models, data preprocessing, and model evaluation.',
      'requirements': [
        'Python & ML libraries',
        'Mathematical foundation in ML',
        'Problem-solving skills'
      ],
      'image': 'assets/images/ml.jpeg'
    },
    {
      'company': 'DesignHive',
      'title': 'Graphic Design Intern',
      'duration': '2 Months',
      'location': 'On-site, Dhaka',
      'stipend': 'BDT 7,000/month',
      'type': 'Part-time',
      'description':
      'Create graphics for social media, web, and marketing campaigns.',
      'requirements': [
        'Adobe Photoshop & Illustrator',
        'Creative thinking',
        'Time management'
      ],
      'image': 'assets/images/graphic.jpeg'
    },
    {
      'company': 'TechLab',
      'title': 'Backend Developer Intern',
      'duration': '3 Months',
      'location': 'Remote',
      'stipend': 'BDT 10,000/month',
      'type': 'Full-time',
      'description':
      'Develop and maintain backend APIs using Node.js and databases.',
      'requirements': [
        'Node.js & Express',
        'Database knowledge (MySQL/MongoDB)',
        'Problem-solving skills'
      ],
      'image': 'assets/images/backend.jpeg'
    },
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
      appBar: AppBar(
        title: const Text(
          'Internship Opportunities',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: internships.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.78, // slightly taller for bigger image
          ),
          itemBuilder: (context, index) {
            final item = internships[index];
            return InternshipCard(
              company: item['company']!,
              title: item['title']!,
              duration: item['duration']!,
              location: item['location']!,
              stipend: item['stipend']!,
              type: item['type']!,
              description: item['description']!,
              requirements: List<String>.from(item['requirements']),
              image: item['image']!,
            );
          },
        ),
      ),
    );
  }
}

class InternshipCard extends StatelessWidget {
  final String company;
  final String title;
  final String duration;
  final String location;
  final String stipend;
  final String type;
  final String description;
  final List<String> requirements;
  final String image;

  const InternshipCard({
    Key? key,
    required this.company,
    required this.title,
    required this.duration,
    required this.location,
    required this.stipend,
    required this.type,
    required this.description,
    required this.requirements,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bigger image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 4),
            Text(
              company,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.teal),
                const SizedBox(width: 4),
                Text(duration, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.location_on, size: 16, color: Colors.teal),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(location,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.badge, size: 16, color: Colors.teal),
                const SizedBox(width: 4),
                Text(type, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.attach_money, size: 16, color: Colors.teal),
                const SizedBox(width: 4),
                Text(stipend, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "Requirements:",
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            ...requirements.map((req) => Text(
              "• $req",
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Applied for $title at $company')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}