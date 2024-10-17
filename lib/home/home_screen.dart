import 'package:flutter/material.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/auth/connecting_account.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/auth/service/service.dart';
import 'package:mysolonet/constants.dart';
import 'package:mysolonet/help/help_screen.dart';
import 'package:mysolonet/profile/profile_screen.dart';
import 'package:mysolonet/home/home_content.dart';
import 'package:mysolonet/upgrade/upgrade_screen.dart';
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
  String? token;

  Future<void> _loadUserData() async {
    final authService = AuthService();
    token = await authService.getToken();

    if (token != null) {
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
  }

  void _onItemTapped(int index) async {
    if (index == 3) {
      // jika index ketiga (Profile) yang di klik
      if (token == null) {
        confirmPopup(
          context,
          'Login Required',
          'Please login to continue',
          'Login',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          ),
        );
      } else {
        final url = Uri.parse(baseUrl + 'users');
        try {
          final response = await http.get(url, headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });

          if (response.statusCode == 401) {
            confirmPopup(
              context,
              'Token Invalid',
              'Your session has expired. Please login again.',
              'Login',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ),
            );
          } else {
            setState(() {
              _selectedIndex = index; 
            });
          }
        } catch (e) {
          print('Error checking token: $e');
        }
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
                  if (token != null && nama.isNotEmpty)
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
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
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ConnectingAccountScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Hubungkan Akun',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
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
        onTap: _onItemTapped,
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
