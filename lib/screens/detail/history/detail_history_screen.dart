import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysolonet/widgets/alert/show_message_failed.dart';
import 'package:mysolonet/widgets/alert/show_message_success.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/screens/home/home_screen.dart';
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
      Permission.manageExternalStorage.request();
    });
  }

  Future<void> requestManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      print("Manage external storage permission granted.");
    } else {
      print("Manage external storage permission denied.");
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> fetchTransactionDetails() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/detail-tagihan/${widget.id}'),
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final boundary = _repaintBoundaryKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary?;
        if (boundary == null) {
          print('Boundary is null');
          return;
        }

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        // Save image in cache directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/receipt.png';
        final file = File(imagePath);
        await file.writeAsBytes(pngBytes);

        // Share the image using the file path
        final xFile = XFile(imagePath);
        await Share.shareXFiles([xFile], text: 'Struk Pembayaran');
      } catch (e) {
        print("Error during capture and share: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share receipt')),
        );
      }
    });
  }

  Future<void> _downloadReceiptWithWhiteBackground() async {
    try {
      // Render the download view layout
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        print('Boundary is null');
        return;
      }

      // Capture image as before
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Use canvas to draw white background
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = Colors.white;

      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          paint);

      final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      canvas.drawImage(frame.image, Offset.zero, Paint());

      final whiteBgImage =
          await recorder.endRecording().toImage(image.width, image.height);
      final whiteBgByteData =
          await whiteBgImage.toByteData(format: ui.ImageByteFormat.png);
      final whiteBgPngBytes = whiteBgByteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/receipt_with_white_background.png';
      final file = File(imagePath);
      await file.writeAsBytes(whiteBgPngBytes);

      final result = await GallerySaver.saveImage(imagePath);
      print('Gallery save result: $result');

      showSuccessMessage(context, 'Gambar berhasil disimpan ke galeri');
    } catch (e) {
      print("Error capturing and downloading image: $e");
      showFailedMessage(context, 'Gagal menyimpan gambar');
    }
  }

  Widget _buildDownloadButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent),
      ),
      child: IconButton(
        icon: const Icon(Icons.download, color: Colors.blueAccent),
        onPressed: _downloadReceiptWithWhiteBackground,
      ),
    );
  }

  Widget _buildDownloadView({bool isDownload = false}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              color: Colors.black,
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
              color: Colors.black,
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildItemList(isDownload: isDownload),
          const SizedBox(height: 20),
          _buildTotalAmount(isDownload: isDownload),
          if (!isDownload) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDownloadButton(),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
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
            Navigator.pop(
                context);
            final homeScreen =
                context.findAncestorStateOfType<HomeScreenState>();
            if (homeScreen != null) {
              homeScreen.setState(() {
                homeScreen.selectedIndex = 1;
              });
            }
          },
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
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
                            ? formatRupiah(
                                pembayaranData!['total_pembayaran'] ?? 0)
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
                              icon: const Icon(Icons.share, color: Colors.blueAccent),
                              onPressed: _captureAndSharePng,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildDownloadButton(),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Selesai',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
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

  Widget _buildItemList({bool isDownload = false}) {
    if (tagihanData == null || pembayaranData == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemRow(
            'Periode Tagihan', formatDate(tagihanData!['bulan'] ?? ''),
            isDownload: isDownload),
        _buildItemRow('Transaction Id', pembayaranData!['trx_id'] ?? 'N/A',
            isDownload: isDownload),
        _buildItemRow('Metode Pembayaran', pembayaranData!['bank'] ?? 'N/A',
            isDownload: isDownload),
        _buildItemRow('Tanggal Pembayaran',
            formatDate(pembayaranData!['tanggal_pembayaran'] ?? ''),
            isDownload: isDownload),
        _buildItemRow('Virtual Account',
            pembayaranData!['virtual_account']?.toString() ?? 'N/A',
            isDownload: isDownload),
        _buildItemRow('Total Pembayaran',
            formatRupiah(pembayaranData!['total_pembayaran'] ?? 0),
            isDownload: isDownload),
      ],
    );
  }

  Widget _buildItemRow(String label, String value, {bool isDownload = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDownload ? Colors.black : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDownload ? Colors.black : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount({bool isDownload = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDownload ? Colors.black : null,
          ),
        ),
        Text(
          pembayaranData != null
              ? formatRupiah(pembayaranData!['total_pembayaran'] ?? 0)
              : 'Total tidak tersedia',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDownload ? Colors.black : null,
          ),
        ),
      ],
    );
  }
}
