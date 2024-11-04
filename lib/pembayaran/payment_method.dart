import 'package:mysolonet/auth/service/service.dart';
import 'package:flutter/material.dart';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/pembayaran/service/bank_payment.dart';

class PaymentMethodScreen extends StatefulWidget {
  final int tagihanId;
  final int customerId;
  final String trxName;

  const PaymentMethodScreen(
      {super.key, required this.tagihanId, required this.customerId, required this.trxName});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedBank;
  final BankPayment bankPayment = BankPayment();
  bool _isLoading = false;
  String? token;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _navigateToPaymentScreen() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authService = AuthService();
      token = await authService.getToken();

      if (_selectedBank == null) {
        showFailedMessage(context, 'Pilih metode pembayaran terlebih dahulu');
      } else if (_selectedBank == 'BRI') {
        await bankPayment.briPayment(
            context, token!, widget.customerId, widget.tagihanId, '200000.00', widget.trxName);
      } else if (_selectedBank == 'BNI') {
        await bankPayment.bniPayment(context, token!, widget.customerId, widget.tagihanId);
      } else {
        showFailedMessage(context, 'Metode pembayaran tidak tersedia');
      }
    } catch (e) {
      print('Payment error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih metode pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            _buildBankCard('assets/images/bri.png', 'BRI'),
            const SizedBox(height: 10),
            _buildBankCard('assets/images/bni.png', 'BNI'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedBank != null ? _navigateToPaymentScreen : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Loading...' : 'Lanjutkan',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(String imagePath, String bankName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBank = bankName;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: _selectedBank == bankName ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 25,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  bankName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              if (_selectedBank == bankName)
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
