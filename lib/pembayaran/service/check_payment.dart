import 'package:flutter/material.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mysolonet/detail/history/detail_history_screen.dart';

class CheckPayment {

  Future<void> checkBni(BuildContext context, String tokenJwt, int customerId, String trxId, int tagihanId) async {
    try {
      final url = Uri.parse('${baseUrl}/inquiry-bni');
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
        if (res['data']['data']['va_status'] == "1") {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(id: res['tagihan_id'])
            )
          );
        } else {
          confirmPopup(
            context, 
            'Lakukan pembayaran', 
            'Anda belum melakukan pembayaran, silahkan lakukan pembayaran', 
            'Bayar Sekarang', () {
              Navigator.of(context).pop(false); 
            });
        }
      } 

    } catch (e) {
      print(e);
    }
  }

}