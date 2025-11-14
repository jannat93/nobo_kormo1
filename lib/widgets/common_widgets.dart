import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../config/api_config.dart';
import '../models/job_model.dart';
import '../models/resource_model.dart';
import '../screens/main/jobs_screen.dart';
import '../screens/main/resources_screen.dart';

Widget buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 16, color: primaryColor),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    ),
  );
}

Widget buildJobCard(Job job, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.company),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(job.isRemote ? Icons.computer : Icons.location_on, size: 14, color: primaryColor),
              const SizedBox(width: 4),
              Text(job.isRemote ? 'Remote' : job.location, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Text(job.jobType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accentColor)),
            ],
          ),
        ],
      ),
      onTap: () {
        // Simple details view
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => JobDetailsSheet(job: job),
        );
      },
    ),
  );
}

Widget buildResourceCard(Resource resource, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      title: Text(resource.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform: ${resource.platform}'),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(FontAwesomeIcons.tag, size: 14, color: primaryColor),
              const SizedBox(width: 4),
              Text(resource.costIndicator, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accentColor)),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => ResourceDetailsSheet(resource: resource),
        );
      },
    ),
  );
}