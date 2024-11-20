class Book {
  int id;
  String title;
  String description;
  int pageCount;
  String excerpt;
  DateTime publishDate;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.pageCount,
    required this.excerpt,
    required this.publishDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pageCount: json['pageCount'] ?? 0,
      excerpt: json['excerpt'] ?? '',
      publishDate: DateTime.parse(json['publishDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'pageCount': pageCount,
    'excerpt': excerpt,
    'publishDate': publishDate.toIso8601String(),
  };
}