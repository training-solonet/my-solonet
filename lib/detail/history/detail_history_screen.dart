import 'package:flutter/material.dart';
import 'package:mysolonet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'dart:io';

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
  final ScreenshotController screenshotController = ScreenshotController();

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

  Future<void> _downloadAndShareReceipt() async {
    Future<void> requestStoragePermission() async {
      PermissionStatus status = await Permission.storage.status;

      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Izin penyimpanan ditolak secara permanen. Harap aktifkan di Pengaturan.'),
            action: SnackBarAction(
              label: 'Pengaturan',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }
    }

    await requestStoragePermission();

    final image = await screenshotController.capture();

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File(
          '${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png');
      await imagePath.writeAsBytes(image);

      // Save to gallery
      await GallerySaver.saveImage(imagePath.path).then((bool? success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success == true
                ? 'Gambar disimpan ke galeri'
                : 'Gagal menyimpan ke galeri'),
          ),
        );
      });

      // Share image after saving to gallery
      await Share.shareXFiles([XFile(imagePath.path)],
          text: 'Berikut adalah bukti pembayaran Anda!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menangkap tangkapan layar')),
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
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
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
                              ? formatRupiah(
                                  pembayaranData!['total_pembayaran'])
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
                        ElevatedButton(
                          onPressed:
                              _downloadAndShareReceipt, // Mengganti fungsi yang dipanggil
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Download',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
          'Total',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          pembayaranData != null
              ? formatRupiah(pembayaranData!['total_pembayaran'])
              : 'Tidak tersedia',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
