// lib/repository_details_screen.dart

import 'package:bridge/repo.dart';
import 'package:flutter/material.dart';


class RepositoryDetailsScreen extends StatelessWidget {
  final Repository repository;

  const RepositoryDetailsScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(repository.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: ${repository.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Owner: ${repository.owner}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Description: ${repository.description}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Forks: ${repository.forks}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Open Issues: ${repository.openIssues}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Created At: ${repository.createdAt}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Updated At: ${repository.updatedAt}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
