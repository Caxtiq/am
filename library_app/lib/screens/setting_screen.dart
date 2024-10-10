import 'package:flutter/material.dart';
import 'package:library_app/screens/help_support_screen.dart';
import 'package:library_app/screens/language_screen.dart';
import 'package:library_app/screens/log_out_screen.dart';
import 'package:library_app/screens/privacy_screen.dart';
import 'package:library_app/screens/profile_screen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              subtitle: Text('View and edit your profile information'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Manage notification settings'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy'),
              subtitle: Text('Adjust your privacy settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacyScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              subtitle: Text('Get help and support'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpSupportScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
              subtitle: Text('Customize your app theme'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text('Change app language'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LanguageScreen()),);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              subtitle: Text('Log out of your account'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LogoutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}