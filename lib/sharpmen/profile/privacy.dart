import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _isDataSharingEnabled = false; // Default: Data sharing is off
  bool _isProfileVisible = true; // Default: Profile is visible

  @override
  Widget build(BuildContext context) {
    final Color tealColor = Colors.teal;
    final Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: tealColor,
        title: const Text('Privacy Settings'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Settings Title
            const Text(
              'Manage your privacy settings below.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Data Sharing Toggle
            SwitchListTile(
              title: const Text('Allow Data Sharing'),
              subtitle: const Text('Enable to share your data with third parties for better services.'),
              value: _isDataSharingEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isDataSharingEnabled = value;
                });
              },
              activeColor: tealColor,
              inactiveThumbColor: Colors.grey,
            ),

            const Divider(),

            // Profile Visibility Toggle
            SwitchListTile(
              title: const Text('Make Profile Visible'),
              subtitle: const Text('Enable to make your profile visible to other users.'),
              value: _isProfileVisible,
              onChanged: (bool value) {
                setState(() {
                  _isProfileVisible = value;
                });
              },
              activeColor: tealColor,
              inactiveThumbColor: Colors.grey,
            ),

            const Divider(),

            // Data Deletion Section
            const SizedBox(height: 30),
            const Text(
              'Delete your data if you no longer wish to use our services.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Delete Account Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Delete My Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show confirmation dialog before account deletion
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This will permanently delete your account and all related data.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle account deletion
                print('Account Deleted');
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}