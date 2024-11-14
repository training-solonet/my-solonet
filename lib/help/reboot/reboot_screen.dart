import 'package:flutter/material.dart';

class RebootScreen extends StatefulWidget {
  @override
  _RebootScreenState createState() => _RebootScreenState();
}

class _RebootScreenState extends State<RebootScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // List of image assets
  final List<String> _images = [
    'assets/images/6.png',
    'assets/images/7.png',
    'assets/images/8.png',
    'assets/images/9.png',
  ];

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reboot Guide'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _images[index],
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _currentPage == 0 ? null : _previousPage,
                ),
                // Page indicator text
                Text(
                  'Step ${_currentPage + 1} of ${_images.length}',
                  style: TextStyle(fontSize: 16),
                ),
                // Next button
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _currentPage == _images.length - 1 ? null : _nextPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
