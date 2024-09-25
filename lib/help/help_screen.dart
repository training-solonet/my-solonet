import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0), // Set the border height
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Set the border color
                  width: 2.0, // Set the border width
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                _buildItem(Icons.phone, 'Call Center', '+62 815-4201-7888'),
                _buildItem(Icons.email, 'Email us to', 'solonet@solonet.net.id'),
                _buildItem(Icons.alternate_email, 'Message us on', 'Instagram'),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 30.0), // Atur padding top di sini
                child: const Text(
                  'Application',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...[
                _buildItem(null, 'FAQ', null),
                _buildItem(null, 'Terms of Service', null),
                _buildItem(null, 'Privacy Policy', null),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildItem(IconData? icon, String title, String? subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // Handle item tap here
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 24,
                  color: Colors.blue,
                ),
              if (icon != null) const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
