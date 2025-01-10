import 'package:flutter/material.dart';
import 'package:sharpens/sharpmen/profile/privacy.dart';

import 'language.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color tealColor = Colors.teal;
    final Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: tealColor,
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Change Password Section
            _buildOptionTile(
              context,
              icon: Icons.lock,
              title: 'Change Password',
              tealColor: tealColor,
              onTap: () {
                // Navigate to the change password page
                print('Navigate to Change Password');
              },
            ),
            const Divider(),

            // Notifications Settings Section
            _buildOptionTile(
              context,
              icon: Icons.notifications,
              title: 'Notifications Settings',
              tealColor: tealColor,
              onTap: () {
                // Navigate to notifications settings page
                print('Navigate to Notifications Settings');
              },
            ),
            const Divider(),

            // Privacy Settings Section
            _buildOptionTile(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Settings',
              tealColor: tealColor,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacySettingsPage()));
                print('Navigate to Privacy Settings');
              },
            ),
            const Divider(),

            // Language Settings Section
            _buildOptionTile(
              context,
              icon: Icons.language,
              title: 'Language Settings',
              tealColor: tealColor,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LanguageSelectionPage(onLanguageChanged: (String languageCode) {  },)));
              },
            ),
            const Divider(),

            // Logout Button
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Settings Section Option Tile
  Widget _buildOptionTile(BuildContext context, {
    required IconData icon,
    required String title,
    required Color tealColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: tealColor,
        radius: 25,
        child: Icon(icon, color: Colors.white, size: 28),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      onTap: onTap,
    );
  }
}