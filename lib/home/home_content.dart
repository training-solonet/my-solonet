import 'package:flutter/material.dart';
import 'package:mysolonet/constants.dart';
import 'dart:async';
import 'package:mysolonet/detail/promo/detail_promo.dart';
import 'package:mysolonet/detail/product/detail_product_screen.dart';
import 'package:mysolonet/auth/connecting_account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageContent extends StatefulWidget {
  final int userId;
  final String nama;
  final String email;

  HomePageContent({
    Key? key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  List<dynamic> _banners = [];
  List<dynamic> _products = [];

  Future<void> _fetchBanners() async {
    final url = Uri.parse(baseUrl + 'banner');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _banners = data;
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
            if (widget.userId > 0 &&
                widget.email.isNotEmpty &&
                widget.nama.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hubungkan Sekarang!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Hubungkan akun Anda untuk mendapatkan pengalaman terbaik dan tawaran eksklusif.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectingAccountScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Hubungkan Akun',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Text(
              'Promo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 165,
              child: _banners.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: _banners.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final banner = _banners[index];
                        final imagePath = banner['gambar'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPromoScreen(
                                  imagePath: imagePath,
                                  title: banner['judul'],
                                  description: banner['deskripsi'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 290,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Rekomendasi Produk',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
         SizedBox(
  height: 140, // Reduced height for the product card container
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _products.length, // Use the length of products
    itemBuilder: (context, index) {
      final product = _products[index]; // Access each product
      final imageUrl = product['gambar'];
      final productName = product['nama'];
      final productPrice = formatRupiah(product['harga']); // Convert price to string

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProductScreen(
                productData: product,
              ),
            ),
          );
        },
        child: Container(
          width: 100, // Smaller width to reduce the card size
          margin: const EdgeInsets.only(right: 10, bottom: 1),
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
                  padding: const EdgeInsets.fromLTRB(6.5, 6.5, 6.5, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl, // Product image
                      height: 80, // Reduced image height
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 8.0, // Smaller font for product name
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3), // Reduced spacing
                      Text(
                        productPrice,
                        style: const TextStyle(
                          fontSize: 8.0, // Smaller font for product price
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
