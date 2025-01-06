import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationCoveredSection extends StatelessWidget {
  final LatLng? _userLocation;

  const LocationCoveredSection({super.key, required LatLng? userLocation})
      : _userLocation = userLocation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchCoverage(_userLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Tidak menampilkan apa pun saat loading
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Terjadi kesalahan, coba lagi nanti.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink(); // Tidak menampilkan apa pun jika data kosong
        }

        bool covered = snapshot.data!;

        // Hanya tampilkan jika lokasi tercover
        if (!covered) {
          return const SizedBox.shrink(); // Sembunyikan jika tidak tercover
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 67, 105, 211), // Warna untuk lokasi tercover
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lokasi Anda Tercover!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kami telah hadir di lokasi Anda. Nikmati layanan terbaik kami dengan cakupan area terluas.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _fetchCoverage(LatLng? userLocation) async {
    if (userLocation == null) return false;

    const String apiUrl = 'https://api.connectis.my.id/coverage-bts';
    final payload = {
      "lati": userLocation.latitude.toString(),
      "long": userLocation.longitude.toString()
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching coverage: $e');
      return false;
    }
  }
}
