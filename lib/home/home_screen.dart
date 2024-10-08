import 'package:flutter/material.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/auth/service/service.dart';
import 'package:mysolonet/constants.dart';
import 'package:mysolonet/help/help_screen.dart';
import 'package:mysolonet/profile/profile_screen.dart';
import 'package:mysolonet/home/home_content.dart';
import 'package:mysolonet/upgrade/upgrade_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  int userId = 0;
  String nama = '';
  String email = '';

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final token = await authService.getToken();

    final url = Uri.parse(baseUrl + 'users');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userId = data['id'];
          nama = data['name'];
          email = data['email'];
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _onItemTapped(int index) async {
    if (index == 3) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        confirmPopup(
            context,
            'Login Required',
            'Please login to continue',
            'Login',
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                ));
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      setState(() {
        _screens = [
          const HomePageContent(),
          const UpgradeScreen(),
          const HelpScreen(),
          const ProfileScreen(),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (nama.isNotEmpty) ...[
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          nama,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ]
                    ],
                  ),
                  Image.asset(
                    'assets/images/solonet_logo.png',
                    height: 25,
                  ),
                ],
              ),
              backgroundColor: Colors.blueAccent,
            )
          : null, // Hide AppBar when not on the Home screen
      body: IndexedStack(
        index:
            _selectedIndex, // Switches between screens based on _selectedIndex
        children: _screens, // The list of screens
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
        onTap: _onItemTapped, // Change screen on tap without navigation
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }
}
