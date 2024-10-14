import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/models/book.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/providers/storage.dart';
import 'package:library_app/screens/book_editor.dart';
import 'package:library_app/screens/information_screen.dart';

class BookScreen extends StatefulWidget {
  final User currentUser;
  const BookScreen({super.key, required this.currentUser});

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/books'),
        headers: {
          'Authorization': 'Bearer ${Storage().token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          books = data.map((item) => Book.fromJson(item)).toList();
          filteredBooks = books;
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
    setState(() => isLoading = false);
  }

  void filterBooks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        final matchesQuery = (book.title ?? '').toLowerCase().contains(query) ||
            (book.author ?? '').toLowerCase().contains(query);
        final matchesFilter = filterOption == 'All' ||
            (filterOption == 'Title' &&
                (book.title ?? '').toLowerCase().contains(query)) ||
            (filterOption == 'Author' &&
                (book.author ?? '').toLowerCase().contains(query));
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Library Books',
                style: TextStyle(color: Colors.white, shadows: [
                  Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 2)
                ]),
              ),
              background: Image.network(
                'https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by title or author',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.pinkAccent),
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
                        onChanged: (value) => filterBooks(),
                      ),
                    ),
                    if (Storage().user.isAdmin) ...[
                      const VerticalDivider(width: 4, color: Colors.transparent),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookEditor(
                              book: Book(
                                id: 0,
                                title: "",
                                author: "",
                                status: "",
                              ),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDropdown('Sort', sortOption, ['A-Z', 'Z-A'],
                          (newValue) {
                        setState(() {
                          sortOption = newValue!;
                          sortBooks();
                        });
                      }),
                      _buildDropdown(
                          'Filter', filterOption, ['All', 'Title', 'Author'],
                          (newValue) {
                        setState(() {
                          filterOption = newValue!;
                          filterBooks();
                        });
                      }),
                      _buildDropdown('Status', statusOption,
                          ['All', 'Available', 'Unavailable'], (newValue) {
                        setState(() {
                          statusOption = newValue!;
                          filterBooks();
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.pinkAccent),
                  ),
                )
              : filteredBooks.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(child: Text('No books available')),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverAnimatedGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        initialItemCount: filteredBooks.length,
                        itemBuilder: (context, index, animation) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: _buildBookCard(filteredBooks[index]),
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

  Widget _buildDropdown(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pinkAccent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          style: const TextStyle(color: Colors.pinkAccent),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.pinkAccent),
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => InformationScreen(
          book: book,
          currentUser: widget.currentUser,
        ),
      )),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.pink.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? 'Unknown Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.pinkAccent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${book.author ?? 'Unknown Author'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.status ?? 'Unknown Status',
                      style: TextStyle(
                        color: book.status == 'Available'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      book.status == 'Available'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: book.status == 'Available'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
