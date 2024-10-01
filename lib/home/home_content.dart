import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysolonet/promo/detail_promo.dart';
 // Import screen detail promo

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Menyimpan halaman yang sedang ditampilkan
  late Timer _timer; // Timer untuk menggeser halaman

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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Promo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 157.5,
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
                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
            const Text(
              'Recommended Products',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 3, bottom: 3),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      shadowColor: Colors.black38,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.5, 6.5, 6.5, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://via.placeholder.com/150',
                                    height: 80,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Title',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 6.5,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Rp 150000',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(255, 34, 50, 64),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
