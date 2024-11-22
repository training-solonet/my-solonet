import 'package:flutter/material.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mysolonet/screens/detail/history/detail_history_screen.dart';

class CheckPayment {

  // CHECK BRI 
  Future<void> checkBri(BuildContext context, String tokenJwt, int customerId, int tagihanId) async {
    try {
      final url = Uri.parse('$baseUrl/bri-inquiry');
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

      if (response.statusCode == 200 && res['responseCode'] == "2002600") {
        if (res['additionalInfo']['paidStatus'] == "Y") {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(id: tagihanId)
            )
          );
        } else {
          confirmPopup(
            context, 
            'Lakukan pembayaran', 
            'Anda belum melakukan pembayaran, silahkan lakukan pembayaran', 
            'Bayar Sekarang', 
            () {});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Check BNI
  Future<void> checkBni(BuildContext context, String tokenJwt, int customerId, String trxId, int tagihanId) async {
    try {
      final url = Uri.parse('$baseUrl/bni-inquiry');
      final headers = {
        'Content-Type': 'application/json',
        'X-Authorization': tokenBni,
        'Authorization': 'Bearer $tokenJwt'
      };
      final body = json.encode({
        "customer_id": customerId,
        "trx_id": trxId,
        "tagihan_id": tagihanId,
      });

      final response = await http.post(url, headers: headers, body: body);
      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['data']['status'] == "000") {
        if (res['data']['data']['trx_amount'] >= res['data']['data']['payment_amount']) {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(id: tagihanId)
            )
          );
        } else {
          confirmPopup(
            context, 
            'Lakukan pembayaran', 
            'Anda belum melakukan pembayaran, silahkan lakukan pembayaran', 
            'Bayar Sekarang', () {});
        }
      } 

    } catch (e) {
      print(e);
    }
  }

}