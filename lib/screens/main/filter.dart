import 'package:flutter/material.dart';

class FilterOptionPage extends StatefulWidget {
  const FilterOptionPage({super.key});

  @override
  State<FilterOptionPage> createState() => _FilterOptionPageState();
}

class _FilterOptionPageState extends State<FilterOptionPage> {
  RangeValues _salaryRange = const RangeValues(20000, 80000);
  String? selectedLocation = "Dhaka";

  final Map<String, List<String>> filters = {
    "Work Type": ["On-site", "Hybrid", "Remote"],
    "Job Level": [
      "Entry Level",
      "Associate / Mid-Level",
      "Senior Level",
      "Manager / Executive"
    ],
    "Employment Type": ["Full-time", "Part-time", "Internship", "Contract"],
    "Experience": ["1 to 3 years", "3 to 5 years", "5 to 10 years", "10+ years"],
    "Education": [
      "Less Than High School",
      "High School",
      "Bachelor’s Degree",
      "Master’s Degree",
      "Doctorate / Professional Degree"
    ],
    "Job Function": [
      "Accounting / Administration",
      "Advertising / Marketing",
      "Architecture / Design",
      "Customer Service",
      "Engineering",
      "Finance",
      "Healthcare",
      "Human Resources",
      "Information Technology",
      "Sales / Retail",
      "Teaching / Education"
    ],
  };

  final Map<String, Set<String>> selectedFilters = {};
  final List<String> cities = [
    "Dhaka", "Chattogram", "Sylhet", "Rajshahi", "Khulna", "Barishal",
    "Rangpur", "Mymensingh", "Cumilla", "Narsingdi", "Gazipur",
    "Narayanganj", "Cox’s Bazar", "Jessore", "Pabna", "Noakhali",
    "Bogura", "Tangail", "Feni", "Brahmanbaria", "Jamalpur",
    "Dinajpur", "Kushtia", "Faridpur", "Satkhira",
  ];

  @override
  void initState() {
    super.initState();
    for (var key in filters.keys) {
      selectedFilters[key] = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 50.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Options"),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF007A74),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth > 600 ? 700 : double.infinity),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80), // leave space for sticky bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Location & Salary"),
                      _buildLocationSalarySection(),
                      const SizedBox(height: 20),
                      ...filters.keys.map(
                            (key) => _buildSectionHeader(key,
                            withCard: true, child: _buildExpansionTile(key, filters[key]!, screenWidth)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Sticky summary & apply bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyFilterBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool withCard = false, Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        if (child != null) child,
      ],
    );
  }

  Widget _buildLocationSalarySection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              value: selectedLocation,
              items: cities
                  .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
                  .toList(),
              onChanged: (value) => setState(() => selectedLocation = value),
            ),
            const SizedBox(height: 20),
            const Text(
              "Expected Salary Range",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            RangeSlider(
              values: _salaryRange,
              min: 0,
              max: 200000,
              divisions: 100,
              activeColor: const Color(0xFF007A74),
              labels: RangeLabels(
                "৳${_salaryRange.start.round()}",
                "৳${_salaryRange.end.round()}",
              ),
              onChanged: (values) => setState(() => _salaryRange = values),
            ),
            Text(
              "৳${_salaryRange.start.round()} - ৳${_salaryRange.end.round()}",
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<String> options, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        iconColor: const Color(0xFF007A74),
        collapsedIconColor: Colors.grey.shade600,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: options.map((option) {
                final isSelected = selectedFilters[title]!.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: const Color(0xFF007A74).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF007A74),
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedFilters[title]!.add(option);
                      } else {
                        selectedFilters[title]!.remove(option);
                      }
                    });
                  },
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF007A74) : Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFilterBar() {
    final selectedCount = selectedFilters.values.fold<int>(0, (prev, set) => prev + set.length);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$selectedCount filter${selectedCount == 1 ? '' : 's'} selected",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedFilters);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A74),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Apply Filters", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}