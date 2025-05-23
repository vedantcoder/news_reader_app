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
    return DateTime.now().toUtc().difference(dateTime.toUtc()).inHours <= 30;
  }

  static bool isLongArticle(String content) {
    return content.length > 500;
  }

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

  factory NewsArticle.fromNewsApiJson(Map<String, dynamic> json, String category) {
    final rawContent = json['description'] ?? '';
    final content = _cleanContent(rawContent);
    final publishedAt = json['published_at'] ?? '';
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
      imageUrl: json['image_url'],
      date: date,
      time: time,
      url: json['url'] ?? '',
    );
  }

  static String _cleanContent(String content) {
    final regex = RegExp(r'\[\+\d+\schars\]$');
    return content.replaceAll(regex, '').trim();
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'category': category,
    'isLong': isLong,
    'isTrending': isTrending,
    'imageUrl': imageUrl,
    'date': date,
    'time': time,
    'url': url,
  };

  factory NewsArticle.fromMap(Map<String, dynamic> map) => NewsArticle(
    title: map['title'],
    content: map['content'],
    category: map['category'],
    isLong: map['isLong'],
    isTrending: map['isTrending'],
    imageUrl: map['imageUrl'],
    date: map['date'],
    time: map['time'],
    url: map['url'],
  );
}