import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color primaryColor = Colors.teal;
const Color backgroundColor = Colors.white;
const Color accentColor = Colors.tealAccent;
const Color cardColor = Color(0xFFF5F5F5);
const Color gapColor = Colors.redAccent;

class SkillGapPage extends StatefulWidget {
  const SkillGapPage({super.key});

  @override
  State<SkillGapPage> createState() => _SkillGapPageState();
}

class _SkillGapPageState extends State<SkillGapPage> {
  final List<String> allSkills = [
    "Flutter",
    "Firebase",
    "UI/UX Design",
    "HTML",
    "CSS",
    "JavaScript",
    "React",
    "Node.js",
    "Express.js",
    "MongoDB",
    "REST API",
    "Docker",
    "Git",
    "Figma",
    "Adobe XD",
    "Prototyping",
    "Wireframing",
    "Design Systems"
  ];

  List<String> selectedSkills = ["Flutter", "Firebase"];

  final Map<String, List<String>> futureRoles = {
    "Frontend Developer": ["HTML", "CSS", "JavaScript", "React", "UI/UX Basics", "Git"],
    "Backend Developer": ["Node.js", "Express.js", "MongoDB", "REST API", "Docker", "Git"],
    "Fullstack Developer": ["Frontend + Backend Skills", "Deployment", "CI/CD", "Git"],
    "UI/UX Designer": ["Figma", "Adobe XD", "Prototyping", "Wireframing", "Design Systems"],
  };

  String selectedRole = "Frontend Developer";

  final Map<String, List<Map<String, String>>> resources = {
    "HTML": [
      {"title": "MDN HTML Guide", "link": "https://developer.mozilla.org/en-US/docs/Web/HTML"},
      {"title": "freeCodeCamp HTML Tutorial", "link": "https://www.freecodecamp.org/learn/responsive-web-design/#basic-html-and-html5"}
    ],
    "CSS": [
      {"title": "MDN CSS Guide", "link": "https://developer.mozilla.org/en-US/docs/Web/CSS"},
      {"title": "CSS Flexbox & Grid – YouTube", "link": "https://www.youtube.com/watch?v=JJSoEo8JSnc"}
    ],
    "JavaScript": [
      {"title": "JavaScript Basics – freeCodeCamp", "link": "https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/"},
      {"title": "JS Crash Course – Traversy Media", "link": "https://www.youtube.com/watch?v=hdI2bqOjy3c"}
    ],
    "React": [
      {"title": "React Official Docs", "link": "https://reactjs.org/docs/getting-started.html"},
      {"title": "React Crash Course – YouTube", "link": "https://www.youtube.com/watch?v=w7ejDZ8SWv8"}
    ],
    "Node.js": [
      {"title": "Node.js Crash Course – Traversy Media", "link": "https://www.youtube.com/watch?v=fBNz5xF-Kx4"},
      {"title": "Full Node.js – freeCodeCamp", "link": "https://www.freecodecamp.org/news/learn-node-js-full-course/"}
    ],
    "Express.js": [
      {"title": "Express.js Tutorial – Net Ninja", "link": "https://www.youtube.com/watch?v=gnsO8-xJ8rs"}
    ],
    "MongoDB": [
      {"title": "MongoDB University Free Courses", "link": "https://university.mongodb.com/"},
    ],
    "REST API": [
      {"title": "REST API Concepts – YouTube", "link": "https://www.youtube.com/watch?v=7YcW25PHnAA"}
    ],
    "Docker": [
      {"title": "Docker Mastery – Udemy", "link": "https://www.udemy.com/course/docker-mastery/"}
    ],
    "Git": [
      {"title": "Pro Git Book – Free", "link": "https://git-scm.com/book/en/v2"}
    ],
    "Figma": [
      {"title": "Figma Official Learn", "link": "https://help.figma.com/hc/en-us/articles/360040518074-Learn-Design-with-Figma"}
    ],
    "Adobe XD": [
      {"title": "Adobe XD Tutorials", "link": "https://helpx.adobe.com/xd/tutorials.html"}
    ],
    "Prototyping": [
      {"title": "Figma Prototyping Guide", "link": "https://www.figma.com/prototyping/"}
    ],
    "Wireframing": [
      {"title": "Wireframing Basics – YouTube", "link": "https://www.youtube.com/watch?v=3Eo5D2eLk0I"}
    ],
    "Design Systems": [
      {"title": "Design Systems Handbook", "link": "https://www.designbetter.co/design-systems-handbook"},
      {"title": "Material Design Guidelines", "link": "https://material.io/design"}
    ],
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 650;

    List<String> roleSkills = futureRoles[selectedRole]!;
    List<String> missingSkills =
    roleSkills.where((skill) => !selectedSkills.contains(skill)).toList();
    double progress = selectedSkills.length / roleSkills.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isWeb ? 80 : 60),
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 5,
          title: Row(
            children: [
              Icon(Icons.analytics, color: Colors.white, size: isWeb ? 32 : 28),
              const SizedBox(width: 10),
              Text("Skill Gap Dashboard",
                  style: TextStyle(
                      fontSize: isWeb ? 26 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          centerTitle: false,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Current Skills Selector
                _buildSelectableSkillsCard("Your Current Skills", allSkills, selectedSkills, isWeb),

                const SizedBox(height: 20),

                /// Future Role Selector
                _buildRoleSelector(isWeb),

                const SizedBox(height: 20),

                /// Skill Gap + Progress Card
                _buildSkillGapProgressCard(missingSkills, progress, isWeb),

                const SizedBox(height: 20),

                /// Recommended Resources
                _buildResourceCard(missingSkills, isWeb),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableSkillsCard(String title, List<String> allSkills, List<String> selected, bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: isWeb ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: allSkills.map((skill) {
                bool isSelected = selected.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  selectedColor: primaryColor.withOpacity(0.2),
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (val) {
                    setState(() {
                      if (val) selected.add(skill);
                      else selected.remove(skill);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector(bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Desired Role",
                style: TextStyle(
                    fontSize: isWeb ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              underline: const SizedBox(),
              items: futureRoles.keys
                  .map((role) => DropdownMenuItem(
                value: role,
                child: Text(role, style: TextStyle(fontSize: isWeb ? 16 : 14)),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedRole = val!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillGapProgressCard(List<String> missingSkills, double progress, bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Skill Gap Overview",
                style: TextStyle(
                    fontSize: isWeb ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: gapColor)),
            const SizedBox(height: 12),

            /// Progress Indicator
            LinearProgressIndicator(
              value: progress,
              color: primaryColor,
              backgroundColor: primaryColor.withOpacity(0.2),
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text("${(progress * 100).toStringAsFixed(0)}% skills acquired",
                style: TextStyle(fontSize: isWeb ? 16 : 14)),

            const SizedBox(height: 12),
            Text("Missing Skills:",
                style: TextStyle(fontSize: isWeb ? 18 : 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: missingSkills
                  .map((skill) => Chip(
                label: Text(skill),
                backgroundColor: gapColor.withOpacity(0.2),
                labelStyle: const TextStyle(color: gapColor, fontWeight: FontWeight.w500),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(List<String> missingSkills, bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recommended Learning Resources",
                style: TextStyle(
                    fontSize: isWeb ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(height: 10),
            ...missingSkills.map((skill) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill,
                      style: TextStyle(
                          fontSize: isWeb ? 18 : 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  ...(resources[skill] ?? [{"title": "No resources available", "link": ""}])
                      .map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      onTap: () async {
                        if (r["link"] != null && r["link"]!.isNotEmpty) {
                          Uri url = Uri.parse(r["link"]!);
                          if (await canLaunchUrl(url)) launchUrl(url);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow,
                              color: primaryColor, size: isWeb ? 20 : 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              r["title"]!,
                              style: TextStyle(
                                  fontSize: isWeb ? 16 : 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                  const SizedBox(height: 8),
                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}