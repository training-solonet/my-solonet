import 'package:flutter/material.dart';
import 'change_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: const Text(
                    'KA',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Kevin Andra',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'
                        ),
                      ),
                      Text(
                        'kutubsangatdingin@gmail.com',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'
                        ),
                      ),
                      Text(
                        '+6212345678910',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'
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
                      MaterialPageRoute(builder: (context) => ChangeProfileScreen()),
                    );
                  },
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  _MenuItem(
                    icon: Icons.task,
                    title: 'My Activity',
                  ),
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'Notification',
                  ),
                  _MenuItem(
                    icon: Icons.alternate_email,
                    title: 'Follow us',
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
  final String? subtitle;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
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
      onTap: () {
        // Aksi untuk menu item
      },
    );
  }
}
