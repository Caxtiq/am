import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';

class BorrowScreen extends StatefulWidget {
  final Book book;

  BorrowScreen({required this.book});

  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
    List<Book> borrowedBooks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.book.status == 'Available') {
        setState(() {
          borrowedBooks.add(widget.book);
        });
      } else if (widget.book.status == 'Unavailable') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This book is currently unavailable for borrowing.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: borrowedBooks.isEmpty
          ? Center(child: Text('No borrowed books'))
          : ListView.builder(
              itemCount: borrowedBooks.length,
              itemBuilder: (context, index) {
                final book = borrowedBooks[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.bookmark, color: Colors.pinkAccent),
                    title: Text(book.title ?? 'Unknown Title'),
                    subtitle: Text('Author: ${book.author ?? 'Unknown Author'}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          borrowedBooks.removeAt(index);
                        });
                      },
                      child: Text('Return'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
    }
    }