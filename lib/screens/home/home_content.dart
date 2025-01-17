import 'package:flutter/material.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/widgets/homecontent/connect_account_section.dart';
import 'package:mysolonet/widgets/homecontent/product_recommendation_section.dart';
import 'package:mysolonet/widgets/homecontent/profile_info_section.dart';
import 'package:mysolonet/widgets/homecontent/coverage_area.dart';
import 'package:mysolonet/widgets/homecontent/promo_section.dart';
import 'package:mysolonet/widgets/homecontent/location_covered_section.dart';
import 'package:mysolonet/widgets/homecontent/installation_info_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomePageContent extends StatefulWidget {
  final int userId;
  final String nama;
  final String email;

  const HomePageContent({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageNotifier =
      ValueNotifier<int>(0); // Tambahkan ValueNotifier
  late Timer _timer;
  List<dynamic> _banners = [];
  List<dynamic> _products = [];
  final bool _isConnect = false;
  LatLng? _userLocation;
  bool _permissionGranted = false;
  bool _locationFetched = false;
  bool _locationInitialized = false;
  final double _currentZoom = 13.0;
  MapController? _mapController;
  final bool _showInfoSection = true;

  Future<void> _fetchBanners() async {
    final url = Uri.parse('$baseUrl/banner');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _banners = data;
        });

        if (_banners.isNotEmpty) {
          _startBannerTimer();
        }
      } else {
        throw Exception('Failed to fetch banners');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchProducts() async {
    final url = Uri.parse('$baseUrl/paket');

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

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _permissionGranted = true;
      });
      await _getCurrentLocation();
    } else {
      setState(() {
        _userLocation = LatLng(-7.5593449,110.8289958); // Default to Surakarta
        _locationFetched = true;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_locationInitialized) return;
    _locationInitialized = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _locationFetched = true;
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _userLocation = LatLng(-7.5593449,110.8289958); // Default to Surakarta
        _locationFetched = true;
      });
    }
  }

  void _startBannerTimer() {
    if (_banners.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        final nextPage = (_currentPageNotifier.value + 1) % _banners.length;
        _currentPageNotifier.value = nextPage;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCubic,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchBanners();
    _fetchProducts();
    _requestLocationPermission();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _mapController = null;
    _currentPageNotifier.dispose(); // Pastikan ValueNotifier dihapus
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
            if (_isConnect && widget.userId > 0)
              const ProfileInfoSection(
                packageName: 'Paket 30 Mbps',
                isActive: true,
                period: '17 Oktober 2024 s.d 17 November 2024',
                billAmount: 'Rp 1.500.000',
                paymentStatus: 'Dibayar via BCA',
                paymentDate: '17 Agustus 2024',
              ),

            if (!_isConnect && _userLocation != null)
              LocationCoveredSection(userLocation: _userLocation),

            if (widget.userId > 0 &&
                !_isConnect)
              ConnectAccountSection(
                userId: widget.userId,
                nama: widget.nama,
                email: widget.email,
              ),

            const SizedBox(height: 10),

            const Text(
              'Promo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),

            ValueListenableBuilder<int>(
              valueListenable: _currentPageNotifier,
              builder: (context, currentPage, _) {
                return PromoSection(
                  banners: _banners,
                  pageController: _pageController,
                  currentPage: currentPage,
                  onPageChanged: (index) {
                    _currentPageNotifier.value = index;
                  },
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Rekomendasi Produk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            ),
            ProductRecommendationSection(
              products: _products
            ),

            const SizedBox(height: 20),

            if (_userLocation != null && _locationFetched)
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
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      CoverageArea(
                        userLocation: _userLocation,
                        permissionGranted: _permissionGranted,
                        locationFetched: _locationFetched,
                        initialZoom: _currentZoom,
                        mapController: _mapController!,
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
