import 'dart:convert';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mysolonet/pembayaran/payment_screen.dart';

class BankPayment {
  final String tokenBri =
      'EMD3nAKY0T757NYCuq1uL6W1qvy7QkeSKGv1ZUxzKXp0lwcEHJIsVU1LTWpAnFxA';
  final String tokenBni =
      'fFvCP2kk4wABO8CZO3z25BYF6cAuyGKmpsAIFp4rK4CWmjRkOnXNxNGfQkM5VmHf';

  // CREATE BRI VA
  Future<void> briPayment(BuildContext context, String tokenJwt, int customerId,
      int tagihanId, String amount, String description) async {
    try {
      final url = Uri.parse('${baseUrl}/bri');
      final headers = {
        'Content-Type': 'application/json',
        'X-Authorization': tokenBri,
        'Authorization': 'Bearer $tokenJwt'
      };
      final body = json.encode({
        "customer_id": customerId,
        "tagihan_id": tagihanId,
        "partnerServiceId": "   14948",
        "totalAmount": {
          "value": amount,
          "currency": "IDR",
        },
        "additionalInfo": {"description": description}
      });

      final response = await http.post(url, headers: headers, body: body);
      final res = json.decode(response.body);

      if (res['responseCode'] == "2002600") {
        var virtualAccountData = res['virtualAccountData'];

        if (virtualAccountData != null) {
          final virtualAccountNo = virtualAccountData['virtualAccountNo'];
          final amountValue = virtualAccountData['totalAmount']['value'];
          final expirationDate = virtualAccountData['expiredDate'];
          final virtualAccountName = virtualAccountData['virtualAccountName'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                bankName: "BRI",
                virtualAccount: virtualAccountNo,
                amount: amountValue,
                expirationDate: expirationDate,
                virtualAccountName: virtualAccountName,
                tagihanId: tagihanId,
              ),
            ),
          );
        } else {
          showFailedMessage(
              context, 'Gagal mendapatkan virtual account, coba lagi');
        }
      } else {
        final message = json.decode(response.body)['message'];
        showFailedMessage(context, message);
      }
    } catch (e) {
      print(e);
      showFailedMessage(context, '$e');
    }
  }

  // CREATE BNI VA
  Future<void> bniPayment(BuildContext context, String tokenJwt, int customerId,
      int tagihanId, String amount, String description) async {
    try {
      final url = Uri.parse('${baseUrl}/bni');
      final headers = {
        'Content-Type': 'application/json',
        'X-Authorization': tokenBni,
        'Authorization': 'Bearer $tokenJwt'
      };
      final body = json.encode({
        "customer_id": customerId,
        "trx_amount": amount,
        "description": description,
        "billing_type": "c"
      });

      final response = await http.post(url, headers: headers, body: body);
      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['data']['status'] == "000") {
        // Accessing the nested virtual account information
        final virtualAccount = res['data']['data']['virtual_account'];
        final amountValue = amount;
        final expirationDate = res[
            'expiredDate']; // Corrected to match the format in the debug output

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              bankName: "BNI",
              virtualAccount: virtualAccount,
              amount: amountValue,
              expirationDate: expirationDate,
              virtualAccountName: '',
              tagihanId: tagihanId,
            ),
          ),
        );
      } else {
        final message = res['message'] ?? 'Unknown error';
        showFailedMessage(context, message);
      }
    } catch (e) {
      print(e);
      showFailedMessage(context, '$e');
    }
  }
}
