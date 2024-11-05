// lib/repository.dart

class Repository {
  final String name;
  final String owner;
  final String description;
  final String language;
  final int stars;
  final int forks;
  final int openIssues;
  final String createdAt;
  final String updatedAt;

  Repository({
    required this.name,
    required this.owner,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.openIssues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? 'No name',
      owner: json['owner']['login'] ?? 'Unknown owner',
      description: json['description'] ?? 'No description',
      language: json['language'] ?? 'Unknown',
      stars: json['stargazers_count'] ?? 0,
      forks: json['forks_count'] ?? 0,
      openIssues: json['open_issues_count'] ?? 0,
      createdAt: json['created_at'] ?? 'Unknown',
      updatedAt: json['updated_at'] ?? 'Unknown',
    );
  }
}
