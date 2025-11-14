import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_update_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (user == null) {
      return const Center(child: Text('User data unavailable.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => ProfileUpdateSheet(user: user),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: user.profilePictureUrl != null && user.profilePictureUrl!.startsWith('http')
                  ? NetworkImage(user.profilePictureUrl!)
                  : null,
              child: (user.profilePictureUrl == null || !user.profilePictureUrl!.startsWith('http'))
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(user.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(user.email, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const Divider(height: 30),

            // Career Details
            _buildSectionHeader('Career Profile'),
            _buildDetailCard(
                icon: FontAwesomeIcons.graduationCap,
                title: 'Education',
                value: user.educationLevel ?? 'Not specified'
            ),
            _buildDetailCard(
                icon: FontAwesomeIcons.lightbulb,
                title: 'Experience Level',
                value: user.experienceLevel ?? 'Not specified'
            ),
            _buildDetailCard(
                icon: FontAwesomeIcons.chartLine,
                title: 'Career Track',
                value: user.preferredCareerTrack ?? 'Not set'
            ),
            _buildDetailCard(
                icon: FontAwesomeIcons.code,
                title: 'Skills',
                value: user.skills.isEmpty ? 'None listed' : user.skills.join(', ')
            ),

            const SizedBox(height: 20),
            _buildSectionHeader('Interests & CV'),
            _buildDetailCard(
                icon: FontAwesomeIcons.solidHeart,
                title: 'Interests',
                value: user.careerInterests ?? 'None listed'
            ),
            _buildDetailCard(
                icon: FontAwesomeIcons.fileAlt,
                title: 'CV Text',
                value: user.cvText ?? 'No CV uploaded/parsed.'
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: accentColor, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const Expanded(child: Divider(indent: 10)),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required IconData icon, required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}