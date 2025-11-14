import 'package:flutter/material.dart';

// --- Data Model for Ambassador Opportunities ---
class Ambassador {
  final String company;
  final String role;
  final String location;
  final String stipend;
  final String deadline;
  final String description;
  final String imagePath;

  const Ambassador({
    required this.company,
    required this.role,
    required this.location,
    required this.stipend,
    required this.deadline,
    required this.description,
    required this.imagePath,
  });
}

// --- Sample Data ---
final List<Ambassador> ambassadorOpportunities = const [
  Ambassador(
    company: "Company A",
    role: "Campus Ambassador",
    location: "Dhaka",
    stipend: "৳10,000/month",
    deadline: "30 Nov 2025",
    description:
    "Promote Company A on your campus, organize events, and refer students. Gain professional experience and certificate.",
    imagePath: "assets/images/campus.jpeg",
  ),
  Ambassador(
    company: "Institution X",
    role: "Brand Ambassador",
    location: "Chattogram",
    stipend: "৳8,000/month",
    deadline: "15 Dec 2025",
    description:
    "Represent Institution X on campus. Engage in social media campaigns and workshops.",
    imagePath: "assets/images/campus2.jpeg",
  ),
  Ambassador(
    company: "Company B",
    role: "Marketing Ambassador",
    location: "Remote",
    stipend: "৳12,000/month",
    deadline: "10 Dec 2025",
    description:
    "Work as a remote marketing ambassador. Help promote products and gather leads.",
    imagePath: "assets/images/campus.jpeg",
  ),
];

// --- Main Ambassador Page ---
class AmbassadorPage extends StatelessWidget {
  const AmbassadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    if (screenWidth > 1200) crossAxisCount = 4;
    else if (screenWidth > 800) crossAxisCount = 3;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Ambassador Opportunities"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF007A74),
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ambassadorOpportunities.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return AmbassadorCard(ambassador: ambassadorOpportunities[index]);
            },
          ),
        ),
      ),
    );
  }
}

// --- Ambassador Card Widget ---
class AmbassadorCard extends StatelessWidget {
  final Ambassador ambassador;
  const AmbassadorCard({super.key, required this.ambassador});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AmbassadorDetailPage(ambassador: ambassador),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  ambassador.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
              ),
            ),
            // Text Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ambassador.role,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${ambassador.company} | ${ambassador.location}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Stipend: ${ambassador.stipend}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
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

// --- Detail Page ---
class AmbassadorDetailPage extends StatelessWidget {
  final Ambassador ambassador;
  const AmbassadorDetailPage({super.key, required this.ambassador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ambassador.role),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF007A74),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    ambassador.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  ambassador.company,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  ambassador.role,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  "Location: ${ambassador.location}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stipend: ${ambassador.stipend}",
                  style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Text(
                  "Deadline: ${ambassador.deadline}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  ambassador.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Application submitted!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A74),
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