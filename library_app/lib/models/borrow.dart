class Borrow {
  final int id;
  final int userId;
  final int bookId;
  final String borrowDate;
  final String returnDate;

  Borrow({required this.id, required this.userId, required this.bookId, required this.borrowDate, required this.returnDate});

  factory Borrow.fromJson(Map<String, dynamic> json) {
    return Borrow(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      borrowDate: json['borrowDate'],
      returnDate: json['returnDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'borrowDate': borrowDate,
      'returnDate': returnDate,
    };
  }
}