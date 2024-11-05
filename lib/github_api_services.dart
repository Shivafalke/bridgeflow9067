// lib/github_api_service.dart

import 'package:bridge/repo.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';


class GitHubApiService {
  // Base URL for GitHub API
  static const String _baseUrl = 'https://api.github.com';
  
  // Fetches repositories for a given username
  Future<List<Repository>> fetchRepositories(String username, int page, int perPage) async {
    final url = '$_baseUrl/users/$username/repos?page=$page&per_page=$perPage';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        throw Exception('User has no public repositories.');
      }
      return data.map((json) => Repository.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('User does not exist.');
    } else {
      throw Exception('Network error: ${response.statusCode}');
    }
  }
}
