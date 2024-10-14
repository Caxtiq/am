import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Profile Visibility'),
              subtitle: const Text('Control whether your profile is visible to others'),
              value: true,
              onChanged: (bool value) {
                // Handle profile visibility change
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Location Sharing'),
              subtitle: const Text('Allow sharing your location with trusted contacts'),
              value: false,
              onChanged: (bool value) {
                // Handle location sharing change
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Data Collection'),
              subtitle: const Text('Allow app to collect data for personalized experience'),
              value: true,
              onChanged: (bool value) {
                // Handle data collection change
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Enable Two-Factor Authentication'),
              subtitle: const Text('Add an extra layer of security to your account'),
              value: false,
              onChanged: (bool value) {
                // Handle two-factor authentication change
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Ad Personalization'),
              subtitle: const Text('Control whether ads are personalized based on your activity'),
              value: true,
              onChanged: (bool value) {
                // Handle ad personalization change
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Account'),
              subtitle: const Text('Permanently delete your account and all data'),
              onTap: () {
                // Handle account deletion logic
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle account deletion confirmation
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
