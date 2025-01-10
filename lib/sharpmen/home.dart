import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharpens/sharpmen/profile/PROFILE%20PAGE.dart';
import 'package:sharpens/sharpmen/profile/add%20users%20page.dart';
import 'package:sharpens/sharpmen/profile/settings.dart';

import 'add to cart.dart';
import 'cart provider.dart';
import 'favorite page.dart';
import 'homeee.dart'; // Replace with actual Home Page file
import 'notication ui.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageee(),
    WishlistPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Sharp Men',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {},
          ),
          CartIconWithBadge(),
        ],
      )
          : null,
      drawer: _selectedIndex == 0 ? AppDrawer() : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.deepOrange, // Custom background color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
            backgroundColor: Colors.blue, // Custom background color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
            backgroundColor: Colors.green, // Custom background color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            backgroundColor: Colors.purple, // Custom background color
          ),
        ],
        selectedItemColor: Colors.black54, // Color for selected icon
        unselectedItemColor: Colors.black54, // Color for unselected icon
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        iconSize: 30, // Icon size
        showSelectedLabels: true, // Show labels under icons
        showUnselectedLabels: false, // Hide labels when unselected
      ),
    );
  }
}

// Favorites Screen


// Drawer for navigation
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Orders'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UserOrdersPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
