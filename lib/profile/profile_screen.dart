import 'package:flutter/material.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/auth/service/service.dart';
import 'change_profile.dart';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/alert/show_message_success.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int userId = 0;
  String nama = '';
  String email = '';

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final userData = await authService.getUserData();
    setState(() {
      userId = userData['id'] ?? 0;
      nama = userData['nama'] ?? '';
      email = userData['email'] ?? '';
    });
  }

  String _profileText(String nama) {
    List<String> words = nama.split(' ');

    if(words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    }
  }

  Future<void> _logout() async {
    try {
      final authService = AuthService();
      await authService.removeToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );

      showSuccessMessage(context, 'Logout successful');
    } catch (e) {
      showFailedMessage(context, 'Failed to logout');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
      body: Padding(
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
                    style: TextStyle(
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
                      MaterialPageRoute(builder: (context) => ChangeProfileScreen(userId: userId)),
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
                    icon: Icons.task,
                    title: 'My Activity',
                    onTap: () {
                      // Navigasi ke layar "My Activity"
                    },
                  ),
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'Notification',
                    onTap: () {
                      // Navigasi ke layar notifikasi
                    },
                  ),
                  _MenuItem(
                    icon: Icons.alternate_email,
                    title: 'Follow us',
                    onTap: () {
                      // Navigasi ke layar follow us
                    },
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      confirmPopup(context, 'Logout Confirmation', 'Are you sure you want to logout?', 'Logout', _logout);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

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
