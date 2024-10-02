import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysolonet/auth/login.dart';
import 'slide_page.dart';

class SplashSlide extends StatefulWidget {
  @override
  SplashSlideState createState() => SplashSlideState();
}

class SplashSlideState extends State<SplashSlide> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // No need to call _checkFirstLaunch() here
  }

  Future<void> _markNotFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView untuk menampilkan slides
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [
              SlidePage(
                imagePath: 'assets/images/slide1.png', // Update sesuai path
                title: 'Kecepatan Tinggi, \n Akses Tanpa Batas',
                description: 'Langganan internet di solonet dengan \n kecepatan tinggi dan akses tanpa batas',
              ),
              SlidePage(
                imagePath: 'assets/images/slide2.png',
                title: 'Support 24 per 7 hari',
                description: 'Jika ada kendala Solonet siap \n membantumu 24 jam',
              ),
              SlidePage(
                imagePath: 'assets/images/slide3.png',
                title: 'Harga Terjangkau',
                description: 'Berlangganan di Solonet harga \n murah dan terjangkau',
              ),
            ],
          ),
          // Indikator posisi halaman dan tombol di bagian bawah
          Positioned(
            bottom: 50,
            left: 45,
            right: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8.0,
                  ),
                ),
                // Tombol untuk pindah ke SignInScreen hanya di slide terakhir
                if (currentPage == 2) // Tampilkan tombol hanya di slide terakhir
                  ElevatedButton(
                    onPressed: () async {
                      await _markNotFirstLaunch(); // Mark as not first launch
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.keyboard_arrow_right_outlined),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
