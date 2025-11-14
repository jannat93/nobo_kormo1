import 'package:flutter/material.dart';

// --- Job Model ---
class Job {
  final String title;
  final String company;
  final String type; // Full-Time, Part-Time, Remote
  final String location;
  final String salary;
  final String deadline;
  final String description;
  final String imagePath;

  const Job({
    required this.title,
    required this.company,
    required this.type,
    required this.location,
    required this.salary,
    required this.deadline,
    required this.description,
    required this.imagePath,
  });
}

// --- Sample Job Data ---
final List<Job> jobList = const [
  Job(
    title: "UI/UX Designer",
    company: "Bkash Ltd.",
    type: "Full Time",
    location: "Dhaka, Bangladesh",
    salary: "৳80,000/month",
    deadline: "30 Nov 2025",
    description:
    "Design user-centered digital interfaces and collaborate with developers to ensure great usability.",
    imagePath: "assets/images/bkash.png",
  ),
  Job(
    title: "Flutter Developer",
    company: "Pathao",
    type: "Remote",
    location: "Anywhere (Remote)",
    salary: "৳70,000/month",
    deadline: "10 Dec 2025",
    description:
    "Develop and maintain cross-platform apps using Flutter. Work with APIs and state management tools.",
    imagePath: "assets/images/flutter.jpeg",
  ),
  Job(
    title: "Data Analyst",
    company: "Grameenphone",
    type: "Hybrid",
    location: "Dhaka, Bangladesh",
    salary: "৳65,000/month",
    deadline: "20 Dec 2025",
    description:
    "Analyze large datasets, create reports, and derive business insights using SQL and Python.",
    imagePath: "assets/images/remote.png",
  ),
  Job(
    title: "Digital Marketer",
    company: "Sheba.xyz",
    type: "Full Time",
    location: "Chattogram, Bangladesh",
    salary: "৳55,000/month",
    deadline: "25 Dec 2025",
    description:
    "Manage campaigns, SEO/SEM, and social media engagement to increase customer reach and conversions.",
    imagePath: "assets/images/pathao.png",
  ),
  Job(
    title: "Content Writer",
    company: "TechTonic Ltd.",
    type: "Part Time",
    location: "Remote",
    salary: "৳25,000/month",
    deadline: "05 Dec 2025",
    description:
    "Write blogs, articles, and marketing content. Collaborate with design and social media teams.",
    imagePath: "assets/images/bkash.png",
  ),
];

// --- Job Page ---
class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    if (screenWidth > 1200) crossAxisCount = 4;
    else if (screenWidth > 800) crossAxisCount = 3;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Job Opportunities"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: jobList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return JobCard(job: jobList[index]);
          },
        ),
      ),
    );
  }
}

// --- Job Card Widget ---
class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailPage(job: job),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image ---
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey.shade100,
                child: Image.asset(
                  job.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // --- Text Info ---
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      job.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      job.company,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      job.type,
                      style: const TextStyle(fontSize: 13, color: Colors.teal),
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

// --- Job Detail Page ---
class JobDetailPage extends StatelessWidget {
  final Job job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    job.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  job.company,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  job.title,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  "Location: ${job.location}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Job Type: ${job.type}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "Salary: ${job.salary}",
                  style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "Deadline: ${job.deadline}",
                  style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  job.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You applied successfully!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Apply Now",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}