import 'package:flutter/material.dart';

// --- Data Model for the Categories ---
class MartCategory {
  final String title;
  final String itemCount;
  final String imagePath;

  const MartCategory({
    required this.title,
    required this.itemCount,
    required this.imagePath,
  });
}

// --- Main Mart Page Widget ---
class MartPage extends StatelessWidget {
  const MartPage({super.key});

  final List<MartCategory> categories = const [
    MartCategory(title: 'Pottery & Ceramics', itemCount: '250+ items', imagePath: 'assets/images/poettery1.jpg'),
    MartCategory(title: 'Wooden Crafts', itemCount: '250+ items', imagePath: 'assets/images/wood1.jpeg'),
    MartCategory(title: 'Textile & Weaving', itemCount: '250+ items', imagePath: 'assets/images/textile1.jpeg'),
    MartCategory(title: 'Basketry', itemCount: '250+ items', imagePath: 'assets/images/basketry1.jpg'),
    MartCategory(title: 'Bamboo Crafts', itemCount: '250+ items', imagePath: 'assets/images/bamboo1.jpg'),
    MartCategory(title: 'Wooden Crafts', itemCount: '250+ items', imagePath: 'assets/images/wood1.jpeg'),
    MartCategory(title: 'Pottery & Ceramics', itemCount: '250+ items', imagePath: 'assets/images/poettery1.jpg'),
    MartCategory(title: 'Textile & Weaving', itemCount: '250+ items', imagePath: 'assets/images/textile1.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    // Responsive columns for web
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
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
            Icon(Icons.eco, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text(
              'EcoExport',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              // Handle cart click
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // --- Title & Description ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Tribal Handicrafts Platform',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C5B5C),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Empowering tribal artisans by connecting their unique handicrafts with global customers while preserving cultural heritage and traditional craftsmanship.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Grid View ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(category: categories[index]);
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- Category Card Widget ---
class CategoryCard extends StatelessWidget {
  final MartCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on ${category.title}')),
        );
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image ---
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  category.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
              ),
            ),
            // --- Text ---
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.itemCount,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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