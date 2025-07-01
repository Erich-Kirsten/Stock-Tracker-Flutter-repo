class NewsArticle {
  final String title;
  final String summary;
  final String source;
  final String url;
  final String imageUrl;
  final DateTime date;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.date,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['headline'] ?? 'No Title',
      summary: json['summary'] ?? '',
      source: json['source'] ?? 'Unknown',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch((json['datetime'] ?? 0) * 1000),
    );
  }
}
