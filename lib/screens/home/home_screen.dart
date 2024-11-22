import 'package:flutter/material.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/screens/auth/login.dart';
import 'package:mysolonet/screens/auth/service/service.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/screens/help/help_screen.dart';
import 'package:mysolonet/screens/profile/profile_screen.dart';
import 'package:mysolonet/screens/home/home_content.dart';
import 'package:mysolonet/screens/history/history_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; 
  int userId = 0;
  String nama = '';
  String email = '';
  String? token;

  Future<void> _loadUserData() async {
    final authService = AuthService();
    token = await authService.getToken();

    if (token != null) {
      final url = Uri.parse('$baseUrl/users');

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
      if (token == null) {
        confirmPopup(
          context,
          'Anda Belum Login',
          'Silahkan login terlebih dahulu, untuk mengakses halaman ini',
          'Login',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          ),
        );
      } else {
        final url = Uri.parse('$baseUrl/users');
        try {
          final response = await http.get(url, headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });

          if (response.statusCode == 401) {
            confirmPopup(
              context,
              'Anda Belum Login',
              'Silahkan login terlebih dahulu, untuk mengakses halaman ini',
              'Login',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ),
            );
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        } catch (e) {
          print('Error checking token: $e');
        }
      }
    } else {
      setState(() {
        selectedIndex = index;
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
          HomePageContent(
            userId: userId,
            nama: nama,
            email: email,
          ),
          const HistoryScreen(),
          const HelpScreen(),
          const ProfileScreen(),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedIndex == 0
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
                              'Selamat Datang',
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
        index: selectedIndex,
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
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: selectedIndex,
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
