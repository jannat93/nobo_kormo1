import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../models/resource_model.dart';
import '../../providers/data_provider.dart';
import '../../widgets/common_widgets.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Resources')),
      body: data.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data.resources.length,
        itemBuilder: (context, index) {
          return buildResourceCard(data.resources[index], context);
        },
      ),
    );
  }
}

class ResourceDetailsSheet extends StatelessWidget {
  final Resource resource;
  const ResourceDetailsSheet({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Text(resource.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Platform: ${resource.platform}', style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
          const Divider(),
          buildInfoRow(FontAwesomeIcons.handHoldingUsd, 'Cost: ${resource.costIndicator}'),
          buildInfoRow(Icons.link, 'URL: ${resource.url}'),
          const SizedBox(height: 15),
          const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(resource.description),
          const SizedBox(height: 15),
          const Text('Related Skills:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8.0,
            children: resource.relatedSkills.map((skill) => Chip(label: Text(skill))).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Go to Resource'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening ${resource.url} (Simulated)')),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}