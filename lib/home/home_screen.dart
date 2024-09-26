import 'package:flutter/material.dart';
import 'package:mysolonet/constants.dart';
import 'package:mysolonet/home/login.dart';
import 'package:mysolonet/help/help_screen.dart';
import 'package:mysolonet/profile/profile_screen.dart';
import 'package:mysolonet/home/home_content.dart';
import 'package:mysolonet/upgrade/upgrade_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> recommendedProducts = [
    {
      'title': 'Product 1',
      'price': 150000,
      'category': 'Electronics',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Product 2',
      'price': 200000,
      'category': 'Clothing',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Product 3',
      'price': 120000,
      'category': 'Books',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  final List<Widget> _screens = [
    const HomePageContent(),  // Add HomePageContent for the home screen
    const UpgradeScreen(),    // Create an UpgradeScreen widget for the upgrade section
    const HelpScreen(),       // HelpScreen remains the same
    const ProfileScreen(),    // Create a ProfileScreen widget for the profile section
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: kTextGray,
                        ),
                      ),
                      Text(
                        'Kevin Andra Nugroho',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/solonet.png',
                    height: 25,
                  ),
                ],
              ),
            )
          : null, // Hide AppBar when not on the Home screen
      body: IndexedStack(
        index: _selectedIndex,  // Switches between screens based on _selectedIndex
        children: _screens,     // The list of screens
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Upgrade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,  // Change screen on tap without navigation
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }
}



// Placeholder screens for Upgrade and Profile


