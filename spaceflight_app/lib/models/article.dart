class Article {
  final int id;
  final String type;
  final String title;
  final String newsSite;
  final String summary;
  final String url;
  final String imageUrl;
  final String publishedAt;

  const Article({
    required this.id,
    required this.type,
    required this.title,
    required this.newsSite,
    required this.summary,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  String get key => '$type:$id';

  factory Article.fromJson(Map<String, dynamic> j, String type) {
    return Article(
      id: j['id'] as int,
      type: type,
      title: (j['title'] ?? '') as String,
      newsSite: (j['news_site'] ?? 'Unknown') as String,
      summary: (j['summary'] ?? '') as String,
      url: (j['url'] ?? '') as String,
      imageUrl: (j['image_url'] ?? '') as String,
      publishedAt: (j['published_at'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'news_site': newsSite,
        'summary': summary,
        'url': url,
        'image_url': imageUrl,
        'published_at': publishedAt,
      };

  factory Article.fromStored(Map<String, dynamic> j) =>
      Article.fromJson(j, j['type'] as String);
}
