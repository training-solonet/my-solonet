import 'package:flutter/material.dart';
import 'package:mysolonet/screens/address_customer/address_customer_screen.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/screens/auth/login.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductScreen extends StatefulWidget {
  final dynamic productData;

  const DetailProductScreen({super.key, required this.productData});

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  int _selectedTabIndex = 0; // 0 for Benefits, 1 for Terms & Conditions

  Future<void> _actionBuyNow(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      confirmPopup(
          context,
          'Payment',
          'Apakah anda yakin ingin membeli ${widget.productData['nama']}',
          'Beli', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddressCustomerScreen()),
        );
      });
    } else {
      confirmPopup(
          context,
          'Anda Belum Login',
          'Silahkan login terlebih dahulu',
          'Login',
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.productData['gambar'];
    final productName = widget.productData['nama'];

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
          productName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                            '${formatRupiah(widget.productData['harga'])} / Bulan',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.productData['deskripsi'],
                            style: const TextStyle(
                              fontSize: 14,
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
                    // Custom Tab for Benefits and Terms & Conditions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTabButton('Benefits', 0),
                        _buildTabButton('Terms & Conditions', 1),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Content based on selected tab
                    _selectedTabIndex == 0
                        ? _buildSection(widget.productData['benefit'], context)
                        : _buildSection(
                            widget.productData['syarat_dan_ketentuan'],
                            context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
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
                    'Total Harga',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    formatRupiah(widget.productData['harga']),
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
                        'Beli Sekarang',
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
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  _selectedTabIndex == index ? Colors.blueAccent : Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 50, // Panjang garis bisa diatur
            color: _selectedTabIndex == index
                ? Colors.blueAccent
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

    Widget _buildSection(List<dynamic> items, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 20),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              items[index].toString(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            dense: true,
          ),
        );
      },
    );
  }

}
