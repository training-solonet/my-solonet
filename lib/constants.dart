import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const kTextGray = Color(0xFF787878);
const baseUrl = 'https://api.connectis.my.id/';

// const kDefaultPaddin = 10.0;

String formatRupiah(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ', 
    decimalDigits: 0,
  );
  
  return formatter.format(amount);
}
