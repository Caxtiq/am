import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/providers/storage.dart';

class BookEditor extends StatefulWidget {
  final Book book;
  const BookEditor({super.key, required this.book});

  @override
  State<BookEditor> createState() => _BookEditorState();
}

class _BookEditorState extends State<BookEditor> {
  late String title, author, status;
  @override
  void initState() {
    super.initState();
    final book = widget.book;
    title = book.title;
    author = book.author;
    status = book.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Information Editor'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text(
                'Title: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox.square(dimension: 16),
              Expanded(
                child: TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() => title = _),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text(
                'Author: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox.square(dimension: 16),
              Expanded(
                child: TextFormField(
                  initialValue: author,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() => author = _),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox.square(dimension: 16),
              Expanded(
                child: TextFormField(
                  initialValue: status,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() => status = _),
                ),
              ),
            ]),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    http.post(
                      Uri.parse("http://localhost:8080/api/books"),
                      body: json.encode(Book(
                        id: widget.book.id,
                        title: title,
                        author: author,
                        status: status,
                      ).toJson()),
                      headers: {
                        'Authorization': 'Bearer ${Storage().token}',
                        'Content-Type': 'application/json',
                      },
                    ).then((_) {
                      print(_.body);
                      Navigator.of(context).pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
