import 'package:flutter/material.dart';
import 'package:library_app/screens/book_screen.dart';
import 'package:library_app/screens/borrow_screen.dart';
import 'package:library_app/screens/chat_screen.dart';
import 'package:library_app/screens/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              ),
              child: Text(
                'Hello, $username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Book'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookScreen(token: '',)));
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_return),
              title: Text('Borrow'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BorrowScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingScreen()));
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
                username[0].toUpperCase(),
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: Text('Start Reading'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}