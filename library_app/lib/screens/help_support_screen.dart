import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.question_answer, color: Colors.blue),
              title: Text('FAQs'),
              subtitle: Text('Frequently Asked Questions'),
              onTap: () {
                // Navigate to FAQs Screen or Show FAQs
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Colors.green),
              title: Text('Contact Us'),
              subtitle: Text('Reach out for support via email'),
              onTap: () {
                // Handle contact via email logic
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.orange),
              title: Text('Call Support'),
              subtitle: Text('Get in touch with our support team'),
              onTap: () {
                // Handle call support logic
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.purple),
              title: Text('Live Chat'),
              subtitle: Text('Chat with our support team in real-time'),
              onTap: () {
                // Handle live chat logic
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info, color: Colors.teal),
              title: Text('Terms & Conditions'),
              subtitle: Text('Learn more about our terms and policies'),
              onTap: () {
                // Navigate to Terms & Conditions Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
