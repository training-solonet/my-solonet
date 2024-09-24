import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/home/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> recommendedProducts = [
    {
      'title': 'Product 1',
      'price': 150000,
      'category': 'Electronics',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Product 2',
      'price': 200000,
      'category': 'Clothing',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Product 3',
      'price': 120000,
      'category': 'Books',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: kTextGray,
                  ),
                ),
                Text(
                  'Kevin Andra Nugroho',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/solonet.png',
              height: 25,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Latest Promo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recommended Products',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180, // Increase height for better spacing
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedProducts.length,
                  itemBuilder: (context, index) {
                    final product = recommendedProducts[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3.0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  product['image'],
                                  height: 80, // Set height for the image
                                  width: 80, // Set width for the image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                product['title'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.0, // Smaller font size
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center, // Center text
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                'Rp ${product['price']}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10, // Smaller font size
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center, // Center text
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                product['category'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8, // Smaller font size
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center, // Center text
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Upgrade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }
}
