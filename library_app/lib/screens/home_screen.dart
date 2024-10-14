import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/screens/book_screen.dart';
import 'package:library_app/screens/borrow_screen.dart';
import 'package:library_app/screens/chat_screen.dart';
import 'package:library_app/screens/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser;

  const HomeScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.pinkAccent,
              ),
              child: Text(
                'Hello, ${currentUser.username}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Book'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BookScreen(currentUser: currentUser,)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_return),
              title: const Text('Borrow'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BorrowScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                currentUser.username[0].toUpperCase(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              child: const Text('Start Reading'),
            ),
          ],
        ),
      ),
    );
  }
}