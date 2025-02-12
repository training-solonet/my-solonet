import 'package:flutter/material.dart';
import 'package:mysolonet/screens/profile/address/address_customer.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/screens/auth/login.dart';
import 'package:mysolonet/screens/auth/service/service.dart';
import 'package:mysolonet/widgets/loading/loading_screen.dart';
import 'change_profile.dart';
import 'package:mysolonet/widgets/alert/show_message_failed.dart';
import 'package:mysolonet/widgets/alert/show_message_success.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  int userId = 0;
  String nama = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final userData = await authService.getUserData();
    setState(() {
      isLoggedIn = userData.isNotEmpty;
      if (isLoggedIn) {
        userId = userData['id'] ?? 0;
        nama = userData['nama'] ?? '';
        email = userData['email'] ?? '';
      }
    });
  }

  String _profileText(String nama) {
    List<String> words = nama.split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    try {
      final authService = AuthService();
      await authService.removeToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      showSuccessMessage(context, 'Logout successful');
    } catch (e) {
      Navigator.of(context).pop();
      showFailedMessage(context, 'Failed to logout');
    }
  }

  Widget _buildLoggedInContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: Text(
                  _profileText(nama),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeProfileScreen(userId: userId),
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                _MenuItem(
                  icon: Icons.airline_seat_recline_extra_sharp,
                  title: 'Address',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileAddressCustomerScreen(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.task,
                  title: 'My Activity',
                  onTap: () {
                    // Navigate to My Activity screen
                  },
                ),
                _MenuItem(
                  icon: Icons.notifications,
                  title: 'Notification',
                  onTap: () {
                    // Navigate to notifications screen
                  },
                ),
                _MenuItem(
                  icon: Icons.alternate_email,
                  title: 'Follow us',
                  onTap: () {
                    // Navigate to follow us screen
                  },
                ),
                _MenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    confirmPopup(context, 'Logout Confirmation',
                        'Are you sure you want to logout?', 'Logout', _logout);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Anda harus login untuk melihat profil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Login Sekarang',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoggedIn ? _buildLoggedInContent() : _buildNotLoggedInContent(),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}