import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/providers/storage.dart';
import 'package:library_app/screens/book_editor.dart';
import 'package:library_app/screens/borrow_screen.dart';

class InformationScreen extends StatelessWidget {
  final Book book;
  final User currentUser;

  const InformationScreen(
      {super.key, required this.book, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title ?? 'Book Information'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${book.title ?? 'Unknown Title'}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Author: ${book.author ?? 'Unknown Author'}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${book.status ?? 'Unknown Status'}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    BorrowScreen.borrow(book);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BorrowScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    'Borrow Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Borrow Cart')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Add to Borrow Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
            if (Storage().user.isAdmin) ...[
              const SizedBox.square(dimension: 16),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookEditor(book: book),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox.square(dimension: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
