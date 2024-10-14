import 'package:flutter/material.dart';
import 'package:library_app/providers/storage.dart';
import 'package:library_app/screens/help_support_screen.dart';
import 'package:library_app/screens/language_screen.dart';
import 'package:library_app/screens/login_screen.dart';
import 'package:library_app/screens/privacy_screen.dart';
import 'package:library_app/screens/profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink[300]!, Colors.pink[500]!],
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSettingCard(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View and edit your profile information',
                    onTap: () => _navigateTo(ProfileScreen()),
                  ),
                  _buildSettingCard(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage notification settings',
                    onTap: () {},
                  ),
                  _buildSettingCard(
                    icon: Icons.lock,
                    title: 'Privacy',
                    subtitle: 'Adjust your privacy settings',
                    onTap: () => _navigateTo(PrivacyScreen()),
                  ),
                  _buildSettingCard(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and support',
                    onTap: () => _navigateTo(HelpSupportScreen()),
                  ),
                  _buildThemeCard(),
                  _buildSettingCard(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'Change app language',
                    onTap: () => _navigateTo(LanguageScreen()),
                  ),
                  _buildLogoutCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink[100],
          child: Icon(icon, color: Colors.pink[700]),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: Colors.pink[300]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        secondary: CircleAvatar(
          backgroundColor: Colors.pink[100],
          child: Icon(Icons.palette, color: Colors.pink[700]),
        ),
        title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Toggle dark mode on/off'),
        value: isDarkMode,
        activeColor: Colors.pink[300],
        onChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink[100],
          child: Icon(Icons.logout, color: Colors.pink[700]),
        ),
        title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Log out of your account'),
        trailing: Icon(Icons.chevron_right, color: Colors.pink[300]),
        onTap: _showLogoutDialog,
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Cancel', style: TextStyle(color: Colors.pink[300])),
          ),
          ElevatedButton(
            onPressed: () {
              Storage().deinitUser();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (_) => false,
              );
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Colors.pink[300],
            ),
          ),
        ],
      ),
    );
  }
}