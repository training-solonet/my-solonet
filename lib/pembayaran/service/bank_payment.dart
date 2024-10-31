import 'dart:convert';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mysolonet/pembayaran/payment_screen.dart';

class BankPayment {
  final String token =
      'EMD3nAKY0T757NYCuq1uL6W1qvy7QkeSKGv1ZUxzKXp0lwcEHJIsVU1LTWpAnFxA';

  // CREATE BRI VA
  Future<void> briPayment(BuildContext context, String tokenJwt, int customerId,
      int tagihanId, String amount) async {

    try {
      final url = Uri.parse('${baseUrl}/bri');
      final headers = {
        'Content-Type': 'application/json',
        'X-Authorization': token,
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
        "additionalInfo": {"description": "Tagihan Internet September"}
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var virtualAccountData = data['virtualAccountData'];

        if (virtualAccountData != null) {
          final virtualAccountNo = virtualAccountData['virtualAccountNo'];
          final amountValue = virtualAccountData['totalAmount']['value'];
          final expirationDate = virtualAccountData['expiredDate'];
          final trxId = virtualAccountData['trxId'];
          final virtualAccountName = virtualAccountData['virtualAccountName'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                bankName: "BRI",
                virtualAccount: virtualAccountNo,
                amount: amountValue,
                expirationDate: expirationDate,
                trxId: trxId,
                virtualAccountName: virtualAccountName,
                tagihanId: tagihanId,
              ),
            ),
          );
        } else {
          showFailedMessage(context, 'Virtual account tidak tersedia.');
        }
      } else {
        final message = json.decode(response.body)['responseMessage'];
        showFailedMessage(context, message);
      }
    } catch (e) {
      print(e);
      showFailedMessage(context, '$e');
    }
  }
}
