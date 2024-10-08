import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/models/book.dart';
import 'information_screen.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();
  String sortOption = 'A-Z';
  String filterOption = 'All';
  String statusOption = 'All';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/books'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          books = data.map((item) => Book.fromJson(item)).toList();
          filteredBooks = books;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load books: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void filterBooks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        final matchesQuery = (book.title ?? '').toLowerCase().contains(query) ||
                            (book.author ?? '').toLowerCase().contains(query);
        final matchesFilter = filterOption == 'All' ||
                             (filterOption == 'Title' && (book.title ?? '').toLowerCase().contains(query)) ||
                             (filterOption == 'Author' && (book.author ?? '').toLowerCase().contains(query));
        final matchesStatus = statusOption == 'All' ||
                             (book.status ?? '').toLowerCase() == statusOption.toLowerCase();
        return matchesQuery && matchesFilter && matchesStatus;
      }).toList();
      sortBooks();
    });
  }

  void sortBooks() {
    setState(() {
      if (sortOption == 'A-Z') {
        filteredBooks.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
      } else if (sortOption == 'Z-A') {
        filteredBooks.sort((a, b) => (b.title ?? '').compareTo(a.title ?? ''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by title or author',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => filterBooks(),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: sortOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      sortOption = newValue!;
                      sortBooks();
                    });
                  },
                  items: ['A-Z', 'Z-A']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: filterOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      filterOption = newValue!;
                      filterBooks();
                    });
                  },
                  items: ['All', 'Title', 'Author']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: statusOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      statusOption = newValue!;
                      filterBooks();
                    });
                  },
                  items: ['All', 'Available', 'Unavailable']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? Center(child: Text('No books available'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 2 / 2.5,
                    ),
                    padding: EdgeInsets.all(8.0),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InformationScreen(book: book),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title ?? 'Unknown Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Author: ${book.author ?? 'Unknown Author'}'),
                                SizedBox(height: 4),
                                Text('Status: ${book.status ?? 'Unknown Status'}'),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    book.status == 'Available' ? Icons.check_circle : Icons.cancel,
                                    color: book.status == 'Available' ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

