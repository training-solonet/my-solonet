import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:mysolonet/upgrade/detail_product_screen.dart';
import 'package:mysolonet/promo/detail_promo.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({Key? key}) : super(key: key);

  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  // Define which option is currently active
  String activeOption = 'Internet'; // Default is 'Internet'

  // List of products
  final List<Map<String, String>> products = [
    {'title': 'FO Up To 7Mbps', 'price': 'Rp 110.000/bulan'},
    {'title': 'FO Up To 10Mbps', 'price': 'Rp 125.000/bulan'},
    {'title': 'FO Up To 15Mbps', 'price': 'Rp 150.000/bulan'},
    {'title': 'FO Up To 20Mbps', 'price': 'Rp 200.000/bulan'},
    {'title': 'FO Up To 40 Mbps', 'price': 'Rp 500.000/bulan'},
    {'title': 'FO Up To 50 Mbps', 'price': 'Rp 600.000/bulan'},
  ];

  final PageController _pageController = PageController(viewportFraction: 0.9);
  late Timer _timer;
  int _currentPage = 0;

   @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        Future.delayed(const Duration(seconds: 0), () {
          _currentPage = 0;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOutCubic,
          );
        });
        return;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upgrade',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // Add padding to the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align all items to the start
          children: [
            const SizedBox(height: 10),
            
             SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 5,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  // Determine the image based on the index
                  String imagePath;
                  if (index == 0 || index == 2 || index == 4) {
                    imagePath = 'assets/images/Promo Free Pemasangan.png';
                  } else {
                    imagePath = 'assets/images/Promoalat.png';
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPromoScreen(
                            imagePath: imagePath, // Pass imagePath to DetailPromoScreen
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 280, // Lebar kontainer
                    margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imagePath, // Display the appropriate image based on the index
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Row with 'Internet' and 'Wifi Router' options
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildOption('Internet'),
                const SizedBox(width: 20), // Space between options
                buildOption('Wifi Router'),
              ],
            ),

            const SizedBox(height: 20),

            // Content Cards
            Expanded(
              child: ListView.builder(
                itemCount: products.length, // Use the length of the product list
                itemBuilder: (context, index) {
                  return buildCard(
                    products[index]['title']!,
                    products[index]['price']!,
                    context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the selectable options
  Widget buildOption(String option) {
    bool isActive = activeOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          activeOption = option; 
        });
      },
      child: Column(
        children: [
          Text(
            option,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: isActive ? Colors.blue : Colors.grey, // Active is blue, inactive is grey
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400, // Bold if active
            ),
          ),
          if (isActive)
            Align(
              alignment: Alignment.center, // Align the line to the center
              child: Container(
                margin: const EdgeInsets.only(top: 5), // Spacing for underline
                height: 2,
                width: 60, // Width of the underline
                color: Colors.blue, // Blue underline for active
              ),
            ),
        ],
      ),
    );
  }

  // Widget to build product cards with animated scaling effect on tap
 Widget buildCard(String title, String subtitle, BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigasi ke layar detail produk saat card di klik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(
              productTitle: title, // Mengirim judul produk ke layar detail
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.wifi, size: 36, color: Colors.blue),
                  const SizedBox(width: 10),
                  Column(
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
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, size: 24, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
