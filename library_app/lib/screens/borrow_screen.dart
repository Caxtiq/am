import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/user.dart';

class BorrowScreen extends StatefulWidget {
  final Book book;
  final User currentUser;

  const BorrowScreen({required this.book, required this.currentUser, Key? key, required User admin}) : super(key: key);

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  List<Book> borrowedBooks = [];
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
      await Future.delayed(const Duration(seconds: 1));

      if (widget.book.status == 'Available') {
        setState(() {
          borrowedBooks.add(widget.book);
        });
      } else if (widget.book.status == 'Unavailable') {
        _showSnackBar('This book is currently unavailable for borrowing.');
      } else {
        _showSnackBar('Error fetching book status.');
      }
    } catch (e) {
      _showSnackBar('Error fetching book status: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _approveBook(int bookIndex) async {
    if (!widget.currentUser.isAdmin) return;

    setState(() {
      isLoading = true;
    });

    try {
      borrowedBooks[bookIndex] = borrowedBooks[bookIndex].copyWith(status: 'Approved');
      _showSnackBar('Book borrowing approved.');
    } catch (e) {
      _showSnackBar('Error approving book: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _denyBook(int bookIndex) async {
    if (!widget.currentUser.isAdmin) return;

    setState(() {
      isLoading = true;
    });

    try {
      borrowedBooks.removeAt(bookIndex);
      _showSnackBar('Book borrowing request denied.');
    } catch (e) {
      _showSnackBar('Error denying book: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTrailingWidget(Book book, int index) {
    if (widget.currentUser.isAdmin) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _approveBook(index),
            child: const Text('Approve'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _denyBook(index),
            child: const Text('Deny'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      );
    } else {
      return const Text(
        'Pending',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
          : borrowedBooks.isEmpty
              ? const Center(
                  child: Text(
                    'No borrowed books yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: borrowedBooks.length,
                  itemBuilder: (context, index) {
                    final book = borrowedBooks[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark, color: Colors.pinkAccent),
                        title: Text(book.title),
                        subtitle: Text('Author: ${book.author}'),
                        trailing: _buildTrailingWidget(book, index),
                      ),
                    );
                  },
                ),
    );
  }
}