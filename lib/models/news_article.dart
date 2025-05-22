class NewsArticle {
  final String title;
  final String content;
  final String category;
  final bool isLong;
  final bool isTrending;
  final String? imageUrl;
  final String? date;
  final String? time;
  final String url;

  NewsArticle({
    required this.title,
    required this.content,
    required this.category,
    required this.isLong,
    required this.isTrending,
    this.imageUrl,
    this.date,
    this.time,
    required this.url,
  });

  static bool isTrendingArticle(String publishedAt) {
    if (publishedAt.isEmpty) return false;

    final dateTime = DateTime.tryParse(publishedAt);
    if (dateTime == null) return false;

    final nowUtc = DateTime.now().toUtc();
    final publishedUtc = dateTime.toUtc();

    final difference = nowUtc.difference(publishedUtc);

    print('Trending check - Now UTC: $nowUtc, Published UTC: $publishedUtc, Diff hrs: ${difference.inHours}');

    return difference.inHours <= 30;
  }

  static bool isLongArticle(String content) {
    print('lenght  = ${content.length}');
    return content.length > 500; // Define your own threshold here
  }

  // Factory to parse JSON and create a NewsArticle instance
  factory NewsArticle.fromJson(Map<String, dynamic> json, String category) {
    final rawContent = json['content'] ?? json['description'] ?? '';
    final content = _cleanContent(rawContent);

    final publishedAt = json['publishedAt'] ?? '';
    final dateTime = DateTime.tryParse(publishedAt);
    final date = dateTime != null
        ? '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}'
        : null;
    final time = dateTime != null
        ? '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
        : null;

    return NewsArticle(
      title: json['title'] ?? '',
      content: content,
      category: category,
      isLong: isLongArticle(content),
      isTrending: isTrendingArticle(publishedAt),
      imageUrl: json['urlToImage'],
      date: date,
      time: time,
      url: json['url'] ?? '',
    );
  }

  // Remove trailing [+xyz chars] from content
  static String _cleanContent(String content) {
    final regex = RegExp(r'\[\+\d+\schars\]$');
    return content.replaceAll(regex, '').trim();
  }
}