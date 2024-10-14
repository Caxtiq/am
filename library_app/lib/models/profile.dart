import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String email;
  final String role;

  const ProfileScreen({super.key, 
    required this.username,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username'),
            Text('Email: $email'),
            Text('Role: $role'),
          ],
        ),
      ),
    );
  }
}
