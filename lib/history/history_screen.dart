import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // You can now call _buildItem to create items for the list
          _buildItem(Icons.history, 'History Item 1', 'Details of item 1'),
          _buildItem(Icons.history, 'History Item 2', 'Details of item 2'),
          _buildItem(Icons.history, 'History Item 3', 'Details of item 3'),
        ],
      ),
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
