class Book {
  final String title;
  final String author;
  final String status;

  Book({required this.title, required this.author, required this.status});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      status: json['status'],
    );
  }
  Book copyWith({
    String? title,
    String? author,
    String? status,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
    );
  }
}