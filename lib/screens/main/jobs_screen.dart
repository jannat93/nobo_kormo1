import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/job_model.dart';
import '../../providers/data_provider.dart';
import '../../widgets/common_widgets.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Job Opportunities')),
      body: data.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data.jobs.length,
        itemBuilder: (context, index) {
          return buildJobCard(data.jobs[index], context);
        },
      ),
    );
  }
}

class JobDetailsSheet extends StatelessWidget {
  final Job job;
  const JobDetailsSheet({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Text(job.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(job.company, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
          const Divider(),
          buildInfoRow(FontAwesomeIcons.mapMarkerAlt, job.isRemote ? 'Remote' : job.location),
          buildInfoRow(FontAwesomeIcons.clock, job.jobType),
          buildInfoRow(FontAwesomeIcons.briefcase, job.experienceLevel),
          buildInfoRow(FontAwesomeIcons.moneyBillWave, job.salaryRange ?? 'Not specified'),
          const SizedBox(height: 15),
          const Text('Required Skills:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8.0,
            children: job.requiredSkills.map((skill) => Chip(label: Text(skill))).toList(),
          ),
          const SizedBox(height: 15),
          const Text('Job Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(job.description),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Applying for ${job.title} at ${job.company}... (Simulated)')),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }
}