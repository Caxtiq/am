import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Profile Visibility'),
              subtitle: Text('Control whether your profile is visible to others'),
              value: true,
              onChanged: (bool value) {
                // Handle profile visibility change
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Location Sharing'),
              subtitle: Text('Allow sharing your location with trusted contacts'),
              value: false,
              onChanged: (bool value) {
                // Handle location sharing change
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Data Collection'),
              subtitle: Text('Allow app to collect data for personalized experience'),
              value: true,
              onChanged: (bool value) {
                // Handle data collection change
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Enable Two-Factor Authentication'),
              subtitle: Text('Add an extra layer of security to your account'),
              value: false,
              onChanged: (bool value) {
                // Handle two-factor authentication change
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Ad Personalization'),
              subtitle: Text('Control whether ads are personalized based on your activity'),
              value: true,
              onChanged: (bool value) {
                // Handle ad personalization change
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Account'),
              subtitle: Text('Permanently delete your account and all data'),
              onTap: () {
                // Handle account deletion logic
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Account'),
                      content: Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle account deletion confirmation
                          },
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
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
