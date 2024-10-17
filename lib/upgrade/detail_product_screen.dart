import 'package:flutter/material.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/profile/address/location_address_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductScreen extends StatelessWidget {
  final dynamic productData;

  DetailProductScreen({required this.productData});

  Future<void> _actionBuyNow(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      confirmPopup(context, 'Payment', 'Are you sure you want to buy this product?', 'Buy', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocationAddressScreen()),
        );
      });
    } else {
      confirmPopup(
          context,
          'Login Required',
          'Please login to continue with payment',
          'Login',
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ));
    }
  }

  String formatRupiah(int number) {
    // Formats the number as Rupiah currency
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    // Image URL handling logic
    final imageUrl = productData['gambar'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Detail Product',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.network(
                      imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${formatRupiah(productData['harga'])} / Bulan',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productData['deskripsi'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Details Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildExpandableSection('Benefits', productData['benefit']),
                    const SizedBox(height: 10),
                    _buildExpandableSection('Terms & Conditions', productData['syarat_dan_ketentuan']),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Footer Section inside a Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        formatRupiah(productData['harga']),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            _actionBuyNow(context);
                          },
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<dynamic> items) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: items.map((item) {
        return ListTile(
          title: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }
}
