class AppBanner {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;

  const AppBanner({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
  });
}