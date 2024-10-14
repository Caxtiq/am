import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.question_answer, color: Colors.blue),
              title: const Text('FAQs'),
              subtitle: const Text('Frequently Asked Questions'),
              onTap: () {
                // Navigate to FAQs Screen or Show FAQs
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text('Contact Us'),
              subtitle: const Text('Reach out for support via email'),
              onTap: () {
                // Handle contact via email logic
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.orange),
              title: const Text('Call Support'),
              subtitle: const Text('Get in touch with our support team'),
              onTap: () {
                // Handle call support logic
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.purple),
              title: const Text('Live Chat'),
              subtitle: const Text('Chat with our support team in real-time'),
              onTap: () {
                // Handle live chat logic
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: const Text('Terms & Conditions'),
              subtitle: const Text('Learn more about our terms and policies'),
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
