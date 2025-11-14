import 'package:flutter/material.dart';

class CareerCompassPage extends StatefulWidget {
  const CareerCompassPage({super.key});

  @override
  State<CareerCompassPage> createState() => _CareerCompassPageState();
}

class _CareerCompassPageState extends State<CareerCompassPage> {
  int step = 0;
  final Set<String> selectedInterests = {};
  final Set<String> selectedSkills = {};
  final Set<String> preferredWorkTypes = {};
  final Set<String> preferredEnvironments = {};

  final Color teal = const Color(0xFF007A74);

  final List<String> interests = [
    'Designing',
    'Coding',
    'Data Analysis',
    'Writing',
    'Marketing',
    'Photography',
    'Music',
    'Teaching',
    'Product Management',
    'Research',
    'UX Research',
    'Game Development',
    'Cybersecurity',
    'Cloud Engineering',
    'Hardware / IoT',
    'Entrepreneurship',
    'Social Work',
    'Healthcare',
  ];

  final List<String> skills = [
    'Figma',
    'Adobe Photoshop',
    'Flutter',
    'React',
    'Dart',
    'Python',
    'SQL',
    'Excel',
    'Public Speaking',
    'Leadership',
    'Communication',
    'UI Design',
    'UX Research',
    'Data Visualization',
    'Machine Learning',
    'Project Management',
    'Git',
    'Docker',
    'Kubernetes',
    'SEO',
    'Content Writing',
    'Sales',
  ];

  final List<String> workTypes = ['On-site', 'Hybrid', 'Remote', 'Freelance'];
  final List<String> environments = ['Startup', 'Corporate', 'Agency', 'NGO', 'Academia'];

  final Map<String, List<String>> careerRules = {
    'UI/UX Designer': ['Designing', 'Figma', 'UI Design', 'Adobe Photoshop', 'UX Research'],
    'Frontend Developer': ['Coding', 'React', 'HTML', 'CSS', 'JavaScript', 'Flutter', 'Dart'],
    'Mobile App Developer': ['Flutter', 'Dart', 'Mobile', 'Coding'],
    'Data Analyst': ['Data Analysis', 'SQL', 'Excel', 'Data Visualization', 'Python'],
    'Data Scientist': ['Machine Learning', 'Python', 'Data Analysis'],
    'Product Manager': ['Product Management', 'Leadership', 'Communication'],
    'Digital Marketer': ['Marketing', 'SEO', 'Content Writing', 'Social Media'],
    'Content Writer': ['Writing', 'Content Writing', 'Communication'],
    'DevOps Engineer': ['Docker', 'Kubernetes', 'Cloud', 'CI/CD'],
    'Cybersecurity Engineer': ['Cybersecurity', 'Security', 'Networking'],
    'Researcher': ['Research', 'Academia', 'Experience'],
    'Entrepreneur / Founder': ['Entrepreneurship', 'Management', 'Sales'],
    'Teacher / Educator': ['Teaching', 'Education', 'Communication'],
  };

  List<MapEntry<String, int>> _scoreCareers() {
    final Map<String, int> score = {};
    for (final c in careerRules.keys) {
      score[c] = 0;
      for (final r in careerRules[c]!) {
        if (selectedInterests.contains(r)) score[c] = score[c]! + 3;
        if (selectedSkills.contains(r)) score[c] = score[c]! + 4;
      }
    }
    final entries = score.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  String _topCareer() {
    final scored = _scoreCareers();
    if (scored.isEmpty) return 'General Career Paths';
    if (scored.first.value == 0) return 'Explore multiple career paths';
    return scored.first.key;
  }

  // ==== Intro ====
  Widget _intro(double width) => Column(
    children: [
      Text('জীবনের পথ — Career Compass',
          style: TextStyle(fontSize: width > 800 ? 32 : 22, fontWeight: FontWeight.bold, color: teal)),
      const SizedBox(height: 15),
      Image.asset('assets/images/compass.png',
          height: width > 800 ? 250 : 130, errorBuilder: (_, __, ___) => Icon(Icons.explore, size: 120, color: teal)),
      const SizedBox(height: 20),
      const Text("Tell us what you love and what you can do — we'll suggest your path.",
          textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 25),
      ElevatedButton(
          onPressed: () => setState(() => step = 1),
          style: ElevatedButton.styleFrom(
              backgroundColor: teal, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
          child: const Text('Begin Compass →', style: TextStyle(fontSize: 16)))
    ],
  );

  // ==== Interests ====
  Widget _interest(double width) {
    final cross = width > 1000 ? 4 : width > 700 ? 3 : 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Step 1 — What do you love doing?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)),
      const SizedBox(height: 10),
      GridView.count(
        crossAxisCount: cross,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.5,
        children: interests.map((i) {
          final selected = selectedInterests.contains(i);
          return InkWell(
              onTap: () => setState(() => selected ? selectedInterests.remove(i) : selectedInterests.add(i)),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: selected ? teal : Colors.grey.shade300),
                      color: selected ? teal.withOpacity(0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                        color: selected ? teal : Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(child: Text(i, style: const TextStyle(fontWeight: FontWeight.w600)))
                  ])));
        }).toList(),
      ),
      const SizedBox(height: 16),
      Row(children: [
        OutlinedButton(onPressed: () => setState(() => selectedInterests.clear()), child: const Text('Clear')),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: selectedInterests.isNotEmpty ? () => setState(() => step = 2) : null,
          style: ElevatedButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white),
          child: const Text('Next: Skills →'),
        )
      ])
    ]);
  }

  // ==== Skills ====
  Widget _skills(double width) {
    final cross = width > 1000 ? 4 : width > 700 ? 3 : 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Step 2 — Choose your skills',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)),
      const SizedBox(height: 10),
      GridView.count(
        crossAxisCount: cross,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 4.0,
        children: skills.map((s) {
          final sel = selectedSkills.contains(s);
          return FilterChip(
              label: Text(s, style: TextStyle(color: sel ? Colors.white : Colors.black)),
              selected: sel,
              onSelected: (v) => setState(() => v ? selectedSkills.add(s) : selectedSkills.remove(s)),
              selectedColor: teal,
              backgroundColor: Colors.grey.shade200);
        }).toList(),
      ),
      const SizedBox(height: 14),
      Row(children: [
        OutlinedButton(onPressed: () => setState(() => selectedSkills.clear()), child: const Text('Clear')),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: selectedSkills.isNotEmpty ? () => setState(() => step = 3) : null,
          style: ElevatedButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white),
          child: const Text('Show Suggestions →'),
        )
      ])
    ]);
  }

  // ==== Suggestions ====
  Widget _suggestions() {
    final top = _topCareer();
    final scored = _scoreCareers().where((e) => e.value > 0).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Step 3 — Suggested Careers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)),
      const SizedBox(height: 8),
      Card(
          color: teal,
          child: ListTile(
              leading: const Icon(Icons.star, color: Colors.white),
              title: Text(top, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: teal),
                  onPressed: () => setState(() => step = 4),
                  child: const Text('Roadmap →')))),
      const SizedBox(height: 15),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: scored.map((e) {
            return Chip(label: Text('${e.key} (${e.value})'), backgroundColor: teal, labelStyle: const TextStyle(color: Colors.white));
          }).toList()),
      const SizedBox(height: 18),
      ElevatedButton(
          onPressed: () => setState(() => step = 4),
          style: ElevatedButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white),
          child: const Text('View Roadmap →'))
    ]);
  }

  // ==== Roadmap ====
  Widget _roadmap() {
    final top = _topCareer();
    final steps = [
      'Learn fundamentals related to $top',
      'Take an online course',
      'Build a small project',
      'Create portfolio / resume',
      'Apply for opportunities'
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Step 4 — Your Roadmap to $top',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)),
      const SizedBox(height: 10),
      ...steps.asMap().entries.map((e) => Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: teal, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white))),
          title: Text(e.value),
        ),
      )),
      const SizedBox(height: 12),
      Center(
          child: ElevatedButton(
              onPressed: () => setState(() {
                step = 0;
                selectedInterests.clear();
                selectedSkills.clear();
              }),
              style: ElevatedButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white),
              child: const Text('Restart Compass')))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget content;
    if (step == 0) {
      content = _intro(width);
    } else if (step == 1) {
      content = _interest(width);
    } else if (step == 2) {
      content = _skills(width);
    } else if (step == 3) {
      content = _suggestions();
    } else {
      content = _roadmap();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Career Compass'), backgroundColor: teal, foregroundColor: Colors.white),
      body: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(padding: const EdgeInsets.all(20), child: content))))),
    );
  }
}