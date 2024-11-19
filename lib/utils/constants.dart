import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const kTextGray = Color(0xFF787878);
const baseUrl = 'https://api.connectis.my.id';

const String tokenBri =
    'EMD3nAKY0T757NYCuq1uL6W1qvy7QkeSKGv1ZUxzKXp0lwcEHJIsVU1LTWpAnFxA';
const String tokenBni =
    'fFvCP2kk4wABO8CZO3z25BYF6cAuyGKmpsAIFp4rK4CWmjRkOnXNxNGfQkM5VmHf';

// const kDefaultPaddin = 10.0;

String formatRupiah(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  return formatter.format(amount);
}

String formatAmount(String amount) {
  try {
    double amountValue = double.parse(amount);
    final formattedAmount = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amountValue);
    return formattedAmount;
  } catch (e) {
    print('Error formatting amount: $e');
    return amount;
  }
}

String formatDateTime(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error formatting date: $e');
    return dateTimeString;
  }
}