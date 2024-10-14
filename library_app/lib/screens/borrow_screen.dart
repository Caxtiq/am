import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/borrow.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/providers/storage.dart';
import 'package:http/http.dart' as http;

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();

  static void borrow(Book book) {
    DateTime now = DateTime.now();
    Borrow request = Borrow(
      id: 0,
      userId: Storage().user.id,
      bookId: book.id,
      borrowDate: now,
      returnDate: now.add(const Duration(days: 7)),
    );
    http.post(
      Uri.parse("http://localhost:8080/api/borrows"),
      body: json.encode(request.toJson()),
      headers: {
        'Authorization': 'Bearer ${Storage().token}',
        'Content-Type': 'application/json',
      },
    ).then((_) {
      print(_.body);
    });
  }
}

class _BorrowScreenState extends State<BorrowScreen> {
  List<Borrow> requests = [];
  List<Book> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBookStatus();
  }

  Future<void> _fetchBookStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      print("Admin: ${Storage().user.isAdmin}");
      final response = await http.get(
        Uri.parse(
          Storage().user.isAdmin
              ? "http://localhost:8080/api/borrows"
              : "http://localhost:8080/api/borrows/user/${Storage().user.id}",
        ),
        headers: {
          'Authorization': 'Bearer ${Storage().token}',
          'Content-Type': 'application/json',
        },
      );

      print(response.body);

      if (response.statusCode > 201) {
        throw Exception('Failed to load borrowed books');
      }

      requests = (json.decode(response.body) as List)
          .map((_) => Borrow.fromJson(_ as Map<String, dynamic>))
          .toList();

      for (var request in requests) {
        books.add(await request.book);
      }

      // if (widget._book.status == 'Available') {
      //   setState(() {
      //     requests.add(widget._book);
      //   });
      // } else if (widget._book.status == 'Unavailable') {
      //   _showSnackBar('This book is currently unavailable for borrowing.');
      // } else {
      //   _showSnackBar('Error fetching book status.');
      // }
    } catch (e, s) {
      final err = ('Error fetching book status: $e\n$s');
      _showSnackBar(err);
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _approveBook(int bookIndex) async {
  //   if (!widget.currentUser.isAdmin) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     borrowedBooks[bookIndex] =
  //         borrowedBooks[bookIndex].copyWith(status: 'Approved');
  //     _showSnackBar('Book borrowing approved.');
  //   } catch (e) {
  //     _showSnackBar('Error approving book: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void _denyBook(int bookIndex) async {
  //   if (!widget.currentUser.isAdmin) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     borrowedBooks.removeAt(bookIndex);
  //     _showSnackBar('Book borrowing request denied.');
  //   } catch (e) {
  //     _showSnackBar('Error denying book: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Widget _buildTrailingWidget(Borrow borrow, int index) {
    if (Storage().user.isAdmin && borrow.state == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Borrow newState = borrow.withState(1);
              http.post(
                Uri.parse("http://localhost:8080/api/borrows"),
                body: json.encode(newState.toJson()),
                headers: {
                  'Authorization': 'Bearer ${Storage().token}',
                  'Content-Type': 'application/json',
                },
              ).then((_) {
                print(_.body);
                setState(() => requests[index] = newState);
              });
            }, //_approveBook(index),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Borrow newState = borrow.withState(2);
              http.post(
                Uri.parse("http://localhost:8080/api/borrows"),
                body: json.encode(newState.toJson()),
                headers: {
                  'Authorization': 'Bearer ${Storage().token}',
                  'Content-Type': 'application/json',
                },
              ).then((_) {
                print(_.body);
                setState(() => requests[index] = newState);
              });
            }, // _denyBook(index),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deny'),
          ),
        ],
      );
    } else {
      return Text(
        ['Pending', 'Approved', 'Denied'][borrow.state],
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowed Books'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? const Center(
                  child: Text(
                    'No borrowed books yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark,
                            color: Colors.pinkAccent),
                        title: Text(book.title),
                        subtitle: Text('Author: ${book.author}'),
                        trailing: _buildTrailingWidget(requests[index], index),
                      ),
                    );
                  },
                ),
    );
  }
}
