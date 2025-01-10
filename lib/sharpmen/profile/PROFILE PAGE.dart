import 'package:flutter/material.dart';

import '../favorite page.dart';
import 'add users page.dart';
import 'language.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color tealColor = Colors.black54;
    final Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: tealColor,
        title: const Text('Accounts'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSmallButton(
                    label: "Orders",
                    icon: Icons.shopping_bag,
                    color: tealColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserOrdersPage()),
                      );
                    },
                  ),
                  _buildSmallButton(
                    label: "Wishlist",
                    icon: Icons.favorite_border,
                    color: tealColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WishlistPage()),
                      );
                    },
                  ),
                  _buildSmallButton(
                    label: "Coupons",
                    icon: Icons.card_giftcard,
                    color: tealColor,
                    onTap: () {
                      // Navigate to Coupons Page
                    },
                  ),
                  _buildSmallButton(
                    label: "Help",
                    icon: Icons.headset_mic,
                    color: tealColor,
                    onTap: () {
                      // Navigate to Help Center Page
                    },
                  ),
                ],
              ),
            ),
            const Divider(),

            // Account Settings Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Account Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            _buildListTile(
              icon: Icons.star_border,
              title: "Flipkart Plus",
              onTap: () {
                // Navigate to Flipkart Plus Page
              },
            ),
            _buildListTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {
                // Navigate to Edit Profile Page
              },
            ),
            _buildListTile(
              icon: Icons.credit_card,
              title: "Saved Credit / Debit & Gift Cards",
              onTap: () {
                // Navigate to Payment Methods Page
              },
            ),
            _buildListTile(
              icon: Icons.location_on_outlined,
              title: "Saved Addresses",
              onTap: () {
                // Navigate to Saved Addresses Page
              },
            ),
            _buildListTile(
              icon: Icons.language,
              title: "Select Language",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LanguageSelectionPage(
                  onLanguageChanged: (String languageCode) {  },)));
              },
            ),
            _buildListTile(
              icon: Icons.notifications_none,
              title: "Notification Settings",
              onTap: () {
                // Navigate to Notification Settings Page
              },
            ),
            const Divider(),

            // My Activity Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "My Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            _buildListTile(
              icon: Icons.reviews,
              title: "Reviews",
              onTap: () {
                // Navigate to Reviews Page
              },
            ),
            _buildListTile(
              icon: Icons.question_answer_outlined,
              title: "Questions & Answers",
              onTap: () {
                // Navigate to Q&A Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSmallButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 24), // Smaller Icon
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // Smaller text
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}