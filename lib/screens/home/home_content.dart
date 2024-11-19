import 'package:flutter/material.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/widgets/homecontent/connect_account_section.dart';
import 'package:mysolonet/widgets/homecontent/coverage_area.dart';
import 'package:mysolonet/widgets/homecontent/promo_section.dart';
import 'package:mysolonet/widgets/homecontent/product_recommendation_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePageContent extends StatefulWidget {
  final int userId;
  final String nama;
  final String email;

  const HomePageContent({
    Key? key,
    required this.userId,
    required this.nama,
    required this.email,
  }) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  List<dynamic> _banners = [];
  List<dynamic> _products = [];
  bool _isCoverageLoading = true; // Status untuk loading CoverageArea

  Future<void> _fetchBanners() async {
    final url = Uri.parse('${baseUrl}/banner');

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
    final url = Uri.parse('${baseUrl}/paket');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _products = data['products'];
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
    _pageController.dispose();
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
              ConnectAccountSection(
                userId: widget.userId,
                nama: widget.nama,
                email: widget.email,
              ),
            const Text(
              'Promo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            PromoSection(
              banners: _banners,
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Rekomendasi Produk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            ProductRecommendationSection(
              products: _products,
              formatRupiah: (price) => 'Rp $price',
            ),
            const SizedBox(height: 20),
           
            const SizedBox(height: 10),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cek Cakupan Area',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'
                      ),
                    ),
                    const SizedBox(height: 8),
                    CoverageArea(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
