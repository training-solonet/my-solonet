import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui; // Import dart:ui for image manipulation
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysolonet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart'; // Import the share_plus package
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker for XFile
import 'package:permission_handler/permission_handler.dart'; // Import for permissions
import 'package:gallery_saver/gallery_saver.dart'; // Import for saving to gallery

class DetailHistoryScreen extends StatefulWidget {
  final int id;

  const DetailHistoryScreen({super.key, required this.id});

  @override
  _DetailHistoryScreenState createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  Map<String, dynamic>? tagihanData;
  Map<String, dynamic>? pembayaranData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null).then((_) {
      fetchTransactionDetails();
    });
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> fetchTransactionDetails() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}/detail-tagihan/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tagihanData = data['tagihan'];
        pembayaranData = data['pembayaran'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load data');
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(parsedDate);
  }

  Future<void> _captureAndSharePng() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary;

        if (boundary != null) {
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();

          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/receipt.png';
          final file = File(imagePath);

          await file.writeAsBytes(pngBytes);
          print('File path: $imagePath');
          print('File exists: ${await file.exists()}');

          if (await file.exists()) {
            final xFile = XFile(imagePath);
            Share.shareXFiles([xFile], text: 'Detail Riwayat Transaksi');
          } else {
            print("File does not exist at path: $imagePath");
          }
        }
      });
    } catch (e) {
      print("Error capturing and sharing image: $e");
    }
  }

  Future<void> _downloadReceipt() async {
    try {
      // Capture the image first
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary;

        if (boundary != null) {
          // Convert the boundary to an image
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();

          // Request storage permissions
          PermissionStatus status = await Permission.storage.request();

          if (status.isGranted) {
            // Get the temporary directory and create the file path
            final directory = await getTemporaryDirectory();
            final imagePath = '${directory.path}/receipt.png';
            final file = File(imagePath);

            // Write the bytes to the file
            await file.writeAsBytes(pngBytes);
            print('File path: $imagePath');

            // Save the image to the gallery
            final result = await GallerySaver.saveImage(imagePath);
            print('Gallery save result: $result'); // Debug output

            if (result != null && result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Struk berhasil diunduh ke galeri')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal mengunduh struk ke galeri')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Izin penyimpanan ditolak')),
            );
          }
        } else {
          print('Boundary is null'); // Debug output
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menangkap struk')),
          );
        }
      });
    } catch (e) {
      print("Error capturing and downloading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detail Riwayat Transaksi',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : RepaintBoundary(
                key: _repaintBoundaryKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 45,
                          child: Image.asset(
                            'assets/images/checkbox.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pembayaran Berhasil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tagihanData != null
                            ? formatDate(tagihanData!['createdAt'])
                            : 'Tanggal tidak tersedia',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pembayaranData != null
                            ? formatRupiah(pembayaranData!['total_pembayaran'])
                            : 'Total tidak tersedia',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildItemList(),
                      const SizedBox(height: 20),
                      _buildTotalAmount(),
                      const SizedBox(height: 16),

                      // Share and download button section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Share Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.share, color: Colors.blueAccent),
                              onPressed: _captureAndSharePng, // Share action
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Download Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.download,
                                  color: Colors.blueAccent),
                              onPressed: _downloadReceipt, // Download action
                            ),
                          ),

                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Selesai',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildItemList() {
    if (tagihanData == null || pembayaranData == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemRow('Periode Tagihan', formatDate(tagihanData!['bulan'])),
        _buildItemRow('Transaction Id', pembayaranData!['trx_id']),
        _buildItemRow('Metode Pembayaran', pembayaranData!['bank']),
        _buildItemRow('Tanggal Pembayaran',
            formatDate(pembayaranData!['tanggal_pembayaran'])),
        _buildItemRow(
            'Virtual Account', pembayaranData!['virtual_account'].toString()),
        _buildItemRow('Total Pembayaran',
            formatRupiah(pembayaranData!['total_pembayaran'])),
      ],
    );
  }

  Widget _buildItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          pembayaranData != null
              ? formatRupiah(pembayaranData!['total_pembayaran'])
              : 'Total tidak tersedia',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
