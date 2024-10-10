import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Select Language',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            RadioListTile(
              title: Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to English
              },
            ),
            Divider(),
            RadioListTile(
              title: Text('Vietnamese'),
              value: 'vi',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to Vietnamese
              },
            ),
            Divider(),
            RadioListTile(
              title: Text('French'),
              value: 'fr',
              groupValue: 'en',
              onChanged: (value) {
                // Handle language change to French
              },
            ),
            Divider(),
            RadioListTile(
              title: Text('Spanish'),
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
