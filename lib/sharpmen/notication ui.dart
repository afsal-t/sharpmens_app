import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          NotificationSection(
            sectionTitle: 'Today',
            notifications: [
              NotificationItem(
                icon: Icons.card_giftcard,
                title: 'Flat 30% OFF',
                description: 'Get 30% OFF on your first order',
              ),
              NotificationItem(
                icon: Icons.new_releases,
                title: 'Special New Year Offer',
                description:
                'Get Flat \$50 OFF on this new year. We hope this year you will get more comfort.',
              ),
              NotificationItem(
                icon: Icons.local_offer,
                title: 'Best Deal of the Day',
                description: 'Buy 1 Get 1 Offer on selected product... hurry up',
              ),
            ],
          ),
          NotificationSection(
            sectionTitle: 'Yesterday',
            notifications: [
              NotificationItem(
                icon: Icons.card_giftcard,
                title: 'Flat 50% OFF',
                description: 'Get 30% OFF on your first order',
              ),
              NotificationItem(
                icon: Icons.new_releases,
                title: 'Special New Year Offer',
                description:
                'Get Flat \$50 OFF on this new year. We hope this year you will get more comfort.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  final String sectionTitle;
  final List<NotificationItem> notifications;

  const NotificationSection({
    required this.sectionTitle,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Column(children: notifications),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
