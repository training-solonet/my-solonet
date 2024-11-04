import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysolonet/constants.dart';
import 'package:mysolonet/history/history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
  final GlobalKey _repaintBoundaryKey = GlobalKey();

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
      print('Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(parsedDate);
  }

Future<void> _captureAndSharePng() async {
  if (_repaintBoundaryKey.currentContext == null) return;

  // Delay capturing the image until the next frame is drawn
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      print('Boundary is null');
      return;
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/receipt.png';
    final file = File(imagePath);

    // Write the PNG bytes to the file
    await file.writeAsBytes(pngBytes);
    print('File saved at: $imagePath');

    // Create the XFile after the file has been written
    final xFile = XFile(imagePath);

    // Share the image
    await Share.shareXFiles([xFile], text: 'Detail Riwayat Transaksi');
  });
}

Future<void> _downloadReceipt() async {
  try {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Check and request permission only if it hasn't been granted yet
        PermissionStatus status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/receipt.png';
          final file = File(imagePath);

          await file.writeAsBytes(pngBytes);
          print('File path: $imagePath');

          // Save the image to the gallery
          final result = await GallerySaver.saveImage(imagePath);
          print('Gallery save result: $result');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Struk berhasil disimpan ke galeri')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Izin penyimpanan ditolak')),
          );
        }
      } else {
        print('Boundary is null');
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
       leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HistoryScreen()),
          );
        },
      ),
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
                          child: Image.asset('assets/images/checkbox.png'),
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
                            ? formatDate(tagihanData!['createdAt'] ?? '')
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
                            ? formatRupiah(pembayaranData!['total_pembayaran'] ?? 0)
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
                              onPressed: _captureAndSharePng,
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
                              icon: Icon(Icons.download, color: Colors.blueAccent),
                              onPressed: _downloadReceipt,
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
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
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
        _buildItemRow('Periode Tagihan', formatDate(tagihanData!['bulan'] ?? '')),
        _buildItemRow('Transaction Id', pembayaranData!['trx_id'] ?? 'N/A'),
        _buildItemRow('Metode Pembayaran', pembayaranData!['bank'] ?? 'N/A'),
        _buildItemRow('Tanggal Pembayaran', formatDate(pembayaranData!['tanggal_pembayaran'] ?? '')),
        _buildItemRow('Virtual Account', pembayaranData!['virtual_account']?.toString() ?? 'N/A'),
        _buildItemRow('Total Pembayaran', formatRupiah(pembayaranData!['total_pembayaran'] ?? 0)),
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
              ? formatRupiah(pembayaranData!['total_pembayaran'] ?? 0)
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
