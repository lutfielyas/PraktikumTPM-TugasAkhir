// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pexels/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'search_photos.dart';
import 'profile.dart';
import 'currency_page.dart'; // Import the currency_page.dart file
import 'time_page.dart'; // Import the time_page.dart file

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HomeTab(),
    const SearchPhotosPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? _buildHomePageAppBar()
          : _currentIndex == 1
              ? _buildAppBarWithTitle('Search by Words')
              : _buildAppBarWithTitle('Profile'),
      body: _tabs[_currentIndex],
      backgroundColor: Colors.black,
      drawer: _buildDrawer(), // Add the drawer to the Scaffold
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: const TextStyle(fontSize: 10),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: 'Search by Words',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildHomePageAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text('Gallery App'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_sharp),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  AppBar _buildAppBarWithTitle(String title) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_sharp),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Additional Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency Conversion'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrencyPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Time Conversion'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
