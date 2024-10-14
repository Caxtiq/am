import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RadioListTile(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to English
              },
            ),
            const Divider(),
            RadioListTile(
              title: const Text('Vietnamese'),
              value: 'vi',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to Vietnamese
              },
            ),
            const Divider(),
            RadioListTile(
              title: const Text('French'),
              value: 'fr',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to French
              },
            ),
            const Divider(),
            RadioListTile(
              title: const Text('Spanish'),
              value: 'es',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to Spanish
              },
            ),
          ],
        ),
      ),
    );
  }
}
