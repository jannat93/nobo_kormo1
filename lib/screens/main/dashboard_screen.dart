import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';
import '../../widgets/common_widgets.dart';

// Define the new color theme globally for consistency
const Color primaryTealGreen = Color(0xFF00897B); // Teal 600
const Color accentLightGreen = Color(0xFF80CBC4); // Teal 200
const Color darkTextColor = Color(0xFF212121); // Dark Gray for contrast

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<DataProvider>(context);

    final primaryColor = primaryTealGreen;

    /// --- Loading/Auth Checks ---
    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryTealGreen)),
      );
    }

    if (!auth.isAuthenticated || auth.user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryTealGreen)),
      );
    }

    final user = auth.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Display a friendly welcome message on the left
          'Welcome, ${user.fullName.split(' ')[0]}!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryTealGreen, // Teal Green AppBar
        automaticallyImplyLeading: false,

        // 🎯 KEY CHANGE: Add Actions to the AppBar
        actions: [
          // 1. Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications button tapped!')),
              );
            },
          ),

          // 2. User Profile Circle Avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the full profile screen or show a menu
                // Assuming '/profile' is your route for the ProfileScreen
                Navigator.pushNamed(context, '/profile');
              },
              child: CircleAvatar(
                radius: 18, // Slightly smaller avatar for the AppBar
                // Try to load network image if available and valid
                backgroundImage: (user.profilePictureUrl != null && user.profilePictureUrl!.startsWith('http'))
                    ? NetworkImage(user.profilePictureUrl!)
                    : null,
                // Fallback to a placeholder icon if no valid image is found
                child: (user.profilePictureUrl == null || !user.profilePictureUrl!.startsWith('http'))
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
                backgroundColor: accentLightGreen, // Background color for the avatar/placeholder
              ),
            ),
          ),
        ],
      ),
      body: data.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryTealGreen))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileSummary(user, primaryColor),
          const SizedBox(height: 25),

          // Recommended Jobs Section Header
          _buildSectionHeader("Recommended Jobs 💼", primaryColor),
          const SizedBox(height: 10),

          data.recommendedJobs.isEmpty
              ? _buildEmptyState("No job recommendations yet. Update your profile!")
              : Column(
            children: data.recommendedJobs
                .take(3)
                .map((job) => buildJobCard(job, context))
                .toList(),
          ),

          const SizedBox(height: 25),

          // Learning Resources Section Header
          _buildSectionHeader("Learning Resources for You 📚", primaryColor),
          const SizedBox(height: 10),

          data.recommendedResources.isEmpty
              ? _buildEmptyState("No resource recommendations yet. Update your profile!")
              : Column(
            children: data.recommendedResources
                .take(3)
                .map((resource) => buildResourceCard(resource, context))
                .toList(),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods (Unchanged) ---
  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: color),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildProfileSummary(User user, Color primaryColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.solidUserCircle, color: primaryColor, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Your Current Focus",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            const Divider(color: accentLightGreen, height: 15),

            _buildDetailRow(
                FontAwesomeIcons.graduationCap,
                "Education",
                user.educationLevel ?? 'N/A',
                darkTextColor
            ),
            _buildDetailRow(
                FontAwesomeIcons.chartLine,
                "Career Track",
                user.preferredCareerTrack ?? 'Not set',
                darkTextColor
            ),
            _buildDetailRow(
                FontAwesomeIcons.lightbulb,
                "Experience Level",
                user.experienceLevel ?? 'N/A',
                darkTextColor
            ),
            const SizedBox(height: 15),

            Text(
              "Top Skills:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: darkTextColor),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: user.skills.take(3).map((skill) => Chip(
                label: Text(skill),
                backgroundColor: accentLightGreen.withOpacity(0.3),
                labelStyle: const TextStyle(color: darkTextColor, fontWeight: FontWeight.w500),
              )).toList(),
            ),
            if (user.skills.length > 3)
              const Text(
                "...",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: primaryTealGreen.withOpacity(0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title:",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}