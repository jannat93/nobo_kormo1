import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class HireMePage extends StatefulWidget {
  const HireMePage({super.key});

  @override
  State<HireMePage> createState() => _HireMePageState();
}

class _HireMePageState extends State<HireMePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // --- Dummy Data ---
  final String name = "Israt Jahan Jarin";
  final String title = "UI/UX Designer | App Developer";
  final String about =
      "A passionate UI/UX designer and Flutter app developer skilled in user-centered design, mobile development, and creating meaningful digital experiences.";

  final List<Map<String, dynamic>> skills = const [
    {"name": "Flutter", "level": 0.9},
    {"name": "UI/UX Design", "level": 0.85},
    {"name": "JavaScript", "level": 0.8},
    {"name": "Communication", "level": 0.9},
  ];

  final List<Map<String, String>> projects = const [
    {
      "title": "Mamoyee - Mental Health App",
      "desc":
      "AI-powered mental health app for postpartum mothers featuring mood tracking, meditation, and screening tools.",
      "link": "https://github.com/",
    },
    {
      "title": "SkillOrbit - Student Event Finder",
      "desc":
      "A web platform connecting students to global hackathons, Olympiads, and innovation challenges.",
      "link": "https://github.com/",
    },
  ];

  final List<Map<String, String>> education = const [
    {
      "title": "B.Sc. in CSE",
      "subtitle": "International Islamic University Chittagong",
      "year": "2021 - Present"
    },
    {
      "title": "UI/UX Designer (Intern)",
      "subtitle": "BrainMachineAI",
      "year": "2024 - Present"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Hire Me",
          style: TextStyle(
            color: Colors.teal,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Profile Section ---
                Card(
                  elevation: 6,
                  shadowColor: Colors.teal.withOpacity(0.1),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.teal.shade100,
                            backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                            child: _image == null
                                ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.teal)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          about,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 15,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _launchUrl("mailto:isratjarin@example.com"),
                              icon: const Icon(Icons.email_outlined),
                              label: const Text("Contact Me"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _launchUrl(
                                  "https://www.linkedin.com/in/yourprofile"),
                              icon: const Icon(Icons.link),
                              label: const Text("LinkedIn"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side: const BorderSide(color: Colors.teal),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                sectionTitle("Skills"),
                const SizedBox(height: 10),
                ...skills.map((skill) => skillBar(skill)),

                const SizedBox(height: 30),
                sectionTitle("Projects"),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return projectCard(project);
                  },
                ),

                const SizedBox(height: 30),
                sectionTitle("Education & Experience"),
                const SizedBox(height: 10),
                ...education.map((edu) => educationCard(edu)),

                const SizedBox(height: 40),
                sectionTitle("Contact Form"),
                const SizedBox(height: 10),
                contactForm(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---
  Widget sectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
    ),
  );

  Widget skillBar(Map<String, dynamic> skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill["name"],
              style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: skill["level"],
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget projectCard(Map<String, String> project) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.teal.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project["title"]!,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            const SizedBox(height: 8),
            Text(project["desc"]!,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => _launchUrl(project["link"]!),
                child: const Text(
                  "View Project →",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget educationCard(Map<String, String> edu) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.teal.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.teal),
        title: Text(edu["title"]!,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("${edu["subtitle"]}\n${edu["year"]}"),
        isThreeLine: true,
      ),
    );
  }

  Widget contactForm() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.teal.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: "Your Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Send Message",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}