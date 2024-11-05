// lib/home_screen.dart

import 'package:bridge/github_api_services.dart';
import 'package:bridge/repo.dart';
import 'package:bridge/repo_details_screen.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GitHubApiService _apiService = GitHubApiService();
  List<Repository> _repositories = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _perPage = 30; // Number of repositories to fetch per request

  Future<void> _searchRepositories() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;  // Show loading indicator
      _repositories = [];  // Clear previous results
      _hasMore = true;     // Reset pagination
      _page = 1;           // Reset to first page
    });

    try {
      final repos = await _apiService.fetchRepositories(_controller.text, _page, _perPage);
      setState(() {
        _repositories = repos;
        _isLoading = false;  // Hide loading indicator
        _hasMore = repos.length == _perPage; // Check if more repositories are available
      });
    } catch (e) {
      setState(() => _isLoading = false); // Hide loading indicator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),  // Show appropriate error message
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<void> _loadMoreRepositories() async {
    if (!_hasMore) return;

    setState(() {
      _isLoading = true;  // Show loading indicator
      _page++;
    });

    try {
      final repos = await _apiService.fetchRepositories(_controller.text, _page, _perPage);
      setState(() {
        _repositories.addAll(repos);
        _isLoading = false;  // Hide loading indicator
        _hasMore = repos.length == _perPage; // Check if more repositories are available
      });
    } catch (e) {
      setState(() => _isLoading = false); // Hide loading indicator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),  // Show appropriate error message
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repositories')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'GitHub Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchRepositories,
                ),
              ),
              onSubmitted: (_) => _searchRepositories(),
            ),
            if (_isLoading) const CircularProgressIndicator(),  // Show loading indicator
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_isLoading && _hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    _loadMoreRepositories();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: _repositories.length,
                  itemBuilder: (context, index) {
                    final repo = _repositories[index];
                    return RepositoryItem(
                      repository: repo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RepositoryDetailsScreen(repository: repo),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RepositoryItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryItem({super.key, required this.repository, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: onTap,
        title: Text(
          repository.name,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          repository.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⭐ ${repository.stars}'),
            Text(repository.language),
          ],
        ),
      ),
    );
  }
}
