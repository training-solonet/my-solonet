import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationCoveredSection extends StatelessWidget {
  final LatLng? _userLocation;

  const LocationCoveredSection({Key? key, required LatLng? userLocation})
      : _userLocation = userLocation,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchCoverage(_userLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
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
          return const Center(
            child: Text(
              'Data tidak ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        bool covered = snapshot.data!;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: covered
                ? const Color.fromARGB(255, 67, 105, 211)
                : Colors.red, // Ganti warna jika tidak tercover
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                covered
                    ? 'Lokasi Anda Tercover!'
                    : 'Lokasi Anda Tidak Tercover!',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                covered
                    ? 'Kami telah hadir di lokasi Anda. Nikmati layanan terbaik kami dengan cakupan area terluas.'
                    : 'Maaf, kami belum hadir di lokasi Anda. Kami sedang berupaya memperluas jangkauan kami.',
                style: const TextStyle(
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
