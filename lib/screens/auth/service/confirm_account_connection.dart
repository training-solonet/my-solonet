import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import http package
import 'dart:convert';
import 'package:mysolonet/screens/home/home_screen.dart';

class ConfirmAccountConnectionScreen extends StatefulWidget {
  final Map<String, dynamic> customerData;
    final String token;  // Pass token to the screen


 const ConfirmAccountConnectionScreen({
    super.key,
    required this.customerData,
    required this.token, // Pass token to the screen
  });

  @override
  _ConfirmAccountConnectionScreenState createState() =>
      _ConfirmAccountConnectionScreenState();
}

class _ConfirmAccountConnectionScreenState
    extends State<ConfirmAccountConnectionScreen> {
  final TextEditingController _idPelangganController = TextEditingController();
  // final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idPelangganController.text = widget.customerData['id_pelanggan'];
  }

   Future<void> _connectAccount() async {
    final String idPelanggan = _idPelangganController.text;
    // final String otp = _otpController.text;
    final String token = widget.token; // Retrieve the token

    final Uri url = Uri.parse('https://api.connectis.my.id/hubungkan-account');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode({
        'id_pelanggan': idPelanggan,
        // 'otp': otp,
        'hubungkan_account': true,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // This will remove all previous routes
      );
    } else {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nama = widget.customerData['nama'];
    final alamat = widget.customerData['alamat'];
    final paket = widget.customerData['paket'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Penghubungan Akun',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Konfirmasi',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Anda akan menghubungkan akun Anda dengan data pelanggan berikut:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Non-editable form-like fields
            TextFormField(
              controller: _idPelangganController,
              decoration: InputDecoration(
                labelText: 'ID Pelanggan',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: nama,
              decoration: InputDecoration(
                labelText: 'Nama',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: alamat,
              decoration: InputDecoration(
                labelText: 'Alamat',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: paket['nama'],
              decoration: InputDecoration(
                labelText: 'Paket',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: 'Rp ${paket['harga']}',
              decoration: InputDecoration(
                labelText: 'Harga',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _connectAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Hubungkan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel and go back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
