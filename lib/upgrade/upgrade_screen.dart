import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:mysolonet/constants.dart';
import 'package:mysolonet/upgrade/detail_product_screen.dart';
import 'package:mysolonet/promo/detail_promo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({Key? key}) : super(key: key);

  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  String activeOption = 'Internet'; // Default is 'Internet'

  List<dynamic> _banners = [];
  List<dynamic> _products = [];

  final PageController _pageController = PageController(viewportFraction: 0.9);
  late Timer _timer;
  int _currentPage = 0;

  Future<void> _fetchBanners() async {
    final url = Uri.parse(baseUrl + 'banner');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _banners = data; // Simpan data banner dari API
        });
      } else {
        throw Exception('Failed to fetch banners');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchProducts() async {
    final url = Uri.parse(baseUrl + 'paket');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _products = data['products']; // Parse products from API response
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchProducts();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 750),
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
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 157.5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _banners.isEmpty ? 0 : _banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPromoScreen(
                            imagePath: banner['gambar'],
                            title: banner['judul'],
                            description: banner['deskripsi'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 280,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              banner['gambar'], // Mengambil gambar dari banner
                              fit: BoxFit.cover,
                            ),
                          ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: buildOption('Internet'),
                ),
                const SizedBox(width: 20),
                buildOption('Wifi Router'),
              ],
            ),

            const SizedBox(height: 20),

            // Content Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return buildCard(
                      _products[index]['nama'],
                      '${formatRupiah(_products[index]['harga'])}/bulan',
                      _products[index]['gambar'],
                      index,
                      context,
                    );
                  },
                ),
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
              color: isActive ? Colors.blue : Colors.grey,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          if (isActive)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                height: 2,
                width: 60,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  // Widget to build product cards with animated scaling effect on tap
  Widget buildCard(String title, String subtitle, String imageUrl, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(
              productData: _products[index],
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
                  ClipOval(
                    child: Image.network(
                      imageUrl, // Gambar produk
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
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
              Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
