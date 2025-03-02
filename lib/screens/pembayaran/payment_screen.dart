import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysolonet/widgets/alert/show_message_success.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/screens/pembayaran/service/check_payment.dart';

class PaymentScreen extends StatefulWidget {
  final String bankName;
  final String virtualAccount;
  final String amount;
  final String expirationDate;
  final String? virtualAccountName;
  final int tagihanId;
  final int customerId;
  final String token;
  final String trxId;

  const PaymentScreen({
    super.key,
    required this.bankName,
    required this.virtualAccount,
    required this.amount,
    required this.expirationDate,
    required this.virtualAccountName,
    required this.tagihanId,
    required this.customerId,
    required this.token,
    required this.trxId,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = false;

  void _checkPaymentStatus() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (widget.bankName == "BNI") {
        await CheckPayment().checkBni(context, widget.token, widget.customerId,
            widget.trxId, widget.tagihanId);
      } else if (widget.bankName == "BRI") {
        await CheckPayment().checkBri(
            context, widget.token, widget.customerId, widget.tagihanId);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatDateTime(String dateTime) {
  try {
    // Handle different possible input formats
    DateTime parsedDate;
    
    // Remove any 'WIB', 'WITA', 'WIT' timezone indicators if present
    dateTime = dateTime.replaceAll(RegExp(r'\s*(WIB|WITA|WIT)'), '');
    
    // Try parsing different common formats
    try {
      // Try ISO format first (yyyy-MM-dd HH:mm:ss)
      parsedDate = DateTime.parse(dateTime);
    } catch (e) {
      try {
        // Try dd/MM/yyyy HH:mm:ss format
        var parts = dateTime.split(' ');
        var dateParts = parts[0].split('/');
        var timeParts = parts[1].split(':');
        
        parsedDate = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
          int.parse(timeParts[0]), // hour
          int.parse(timeParts[1]), // minute
          int.parse(timeParts[2]), // second
        );
      } catch (e) {
        // If all parsing attempts fail, throw an error
        throw FormatException('Invalid date format: $dateTime');
      }
    }
    
    // Format to dd/mm/yy HH:mm:ss
    String day = parsedDate.day.toString().padLeft(2, '0');
    String month = parsedDate.month.toString().padLeft(2, '0');
    String year = (parsedDate.year % 100).toString().padLeft(2, '0');
    String hour = parsedDate.hour.toString().padLeft(2, '0');
    String minute = parsedDate.minute.toString().padLeft(2, '0');
    String second = parsedDate.second.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute:$second';
  } catch (e) {
    print('Error formatting date: $e');
    return dateTime; // Return original string if parsing fails
  }
}

  Future<bool> _onWillPop() {
    return confirmPopupBack(
      context,
      'Konfirmasi',
      'Apakah Anda yakin ingin kembali?',
      'Ya',
      () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Pembayaran untuk ${widget.bankName}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Nomor Virtual Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
                    '-----------------------------------------',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.virtualAccount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.black),
                        iconSize: 15,
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.virtualAccount));
                          showSuccessMessage(context, 'Nomor VA telah disalin');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatAmount(widget.amount),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Lakukan Pembayaran Sebelum\n${formatDateTime(widget.expirationDate)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton('ATM', 0),
                      _buildTabButton('Mobile Banking', 1),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _selectedTabIndex == 0
                      ? _buildSection([
                          '- Masukkan kartu ATM dan PIN.',
                          '- Pilih menu “Transfer”.',
                          '- Pilih “Virtual Account” dan masukkan nomor VA.',
                          '- Masukkan nominal pembayaran.',
                          '- Ikuti instruksi untuk menyelesaikan pembayaran.'
                        ])
                      : _buildSection([
                          '- Buka aplikasi mobile banking.',
                          '- Pilih menu “Transfer”.',
                          '- Pilih “Virtual Account” dan masukkan nomor VA.',
                          '- Masukkan nominal pembayaran.',
                          '- Konfirmasi pembayaran.'
                        ]),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _checkPaymentStatus();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _isLoading ? 'Wait a moment...' : 'Cek Status Pembayaran',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
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
            width: 50,
            color: _selectedTabIndex == index
                ? Colors.blueAccent
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(List<String> steps) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 20),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              steps[index],
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