import 'package:flutter/material.dart';
import 'package:library_app/models/user_data.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = UserData();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${userData.user?.username ?? 'N/A'}'),
            Text('Email: ${userData.user?.email ?? 'N/A'}'),
            Text('Role: ${userData.user?.role ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
