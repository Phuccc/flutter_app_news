class Article {
  final String title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final Source? source;

  Article({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
  });
}

class Source {
  final String? id;
  final String? name;

  Source({
    required this.id,
    required this.name,
  });
}