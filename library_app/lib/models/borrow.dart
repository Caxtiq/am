import 'dart:convert';

import 'package:library_app/models/book.dart';
import 'package:library_app/providers/storage.dart';
import 'package:http/http.dart' as http;

class Borrow {
  final int id;
  final int userId;
  final int bookId;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int state;

  Borrow({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.returnDate,
    this.state = 0,
  });

  factory Borrow.fromJson(Map<String, dynamic> json) {
    return Borrow(
      id: json['id'],
      userId: json['user']['id'],
      bookId: json['book']['id'],
      borrowDate: DateTime.fromMillisecondsSinceEpoch(json['borrowDate']),
      returnDate: DateTime.fromMillisecondsSinceEpoch(json['returnDate']),
      state: json['state'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {'id': userId},
      'book': {'id': bookId},
      'borrowDate': borrowDate.millisecondsSinceEpoch,
      'returnDate': returnDate.millisecondsSinceEpoch,
      'state': state,
    };
  }

  Borrow withState(int state) {
    return Borrow(
      id: id,
      userId: userId,
      bookId: bookId,
      borrowDate: borrowDate,
      returnDate: returnDate,
      state: state,
    );
  }

  Book? _book;

  Future<Book> get book async {
    if (_book != null) return _book!;

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/books/$bookId'),
      headers: {
        'Authorization': 'Bearer ${Storage().token}',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode > 201) {
      throw Exception('Failed to load book');
    }
    _book = Book.fromJson(json.decode(response.body));
    return _book!;
  }
}
