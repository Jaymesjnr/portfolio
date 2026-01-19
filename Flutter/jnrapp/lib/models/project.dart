class Project {
  final String title;
  final String shortDescription;
  final List<String> images;
  final String tech;
  final String liveUrl;
  final String repoUrl;

  const Project({
    required this.title,
    required this.shortDescription,
    required this.images,
    required this.tech,
    required this.liveUrl,
    required this.repoUrl,
  });
}