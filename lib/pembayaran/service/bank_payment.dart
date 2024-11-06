import 'dart:convert';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mysolonet/pembayaran/payment_screen.dart';

class BankPayment {
  // CREATE BRI VA
  Future<void> briPayment(BuildContext context, String tokenJwt, int customerId, int tagihanId) async {
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
      });

      final response = await http.post(url, headers: headers, body: body);
      final res = json.decode(response.body);

      if (res['responseCode'] == "2002700" && response.statusCode == 200) {
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
                amount: amountValue.toString(),
                expirationDate: expirationDate,
                virtualAccountName: virtualAccountName,
                tagihanId: tagihanId,
                customerId: customerId,
                token: tokenJwt,
                trxId: '',
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
      int tagihanId) async {
    try {
      final url = Uri.parse('${baseUrl}/bni');
      final headers = {
        'Content-Type': 'application/json',
        'X-Authorization': tokenBni,
        'Authorization': 'Bearer $tokenJwt'
      };
      final body = json.encode({
        "customer_id": customerId,
        "tagihan_id": tagihanId,
      });

      final response = await http.post(url, headers: headers, body: body);
      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['data']['status'] == "000") {
        final virtualAccount = res['data']['data']['virtual_account'];
        final trxId = res['data']['data']['trx_id'].toString();
        final amountValue = res['trx_amount'].toString();
        final expirationDate = res['expired_date'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                bankName: "BNI",
                virtualAccount: virtualAccount,
                amount: amountValue.toString(),
                expirationDate: expirationDate,
                virtualAccountName: '',
                tagihanId: tagihanId,
                customerId: customerId,
                token: tokenJwt,
                trxId: trxId,
              ),
            ),
          );
        });
      } else {
        final message = res['data']['message'];
        showFailedMessage(context, message);
      }
    } catch (e) {
      print(e);
      showFailedMessage(context, '$e');
    }
  }
}
