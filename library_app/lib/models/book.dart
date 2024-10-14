class Book {
  final int id;
  final String title;
  final String author;
  final String status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
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
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'status': status,
    };
  }
}
