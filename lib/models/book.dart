class Book {
  int id;
  String title;
  String author;
  String cover_url;
  String download_url;
  String? cover_path;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover_url,
    required this.download_url,
    this.cover_path,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      cover_url: json['cover_url'],
      download_url: json['download_url'],
    );
  }
}
