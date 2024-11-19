import 'package:flutter/material.dart';

class ProductRecommendationSection extends StatelessWidget {
  final List<dynamic> products;
  final String Function(int) formatRupiah;

  const ProductRecommendationSection({
    Key? key,
    required this.products,
    required this.formatRupiah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final imageUrl = product['gambar'];
          final productName = product['nama'];
          final productPrice = formatRupiah(product['harga']);

          return GestureDetector(
            onTap: () {
              // Implementasi navigasi ke detail produk
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 10, bottom: 1),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.5, 6.5, 6.5, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 80,
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
                              fontSize: 8.0,
                              fontFamily: 'Poppins',
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            productPrice,
                            style: const TextStyle(
                              fontSize: 8.0,
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
    );
  }
}