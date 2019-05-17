import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CurrencyMask extends TextInputFormatter {

  final int decimalDigits;
  
  CurrencyMask(this.decimalDigits);
  
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }
    var txtfmt = numberFormat(decimalDigits).format(double.parse(newValue.text) / pow(10, decimalDigits));

    return newValue.copyWith(
        text: txtfmt,
        selection: TextSelection.collapsed(offset: txtfmt.length));
  } 

  NumberFormat numberFormat(int decimalDigits){
    return NumberFormat.currency(
      decimalDigits: decimalDigits,
      symbol: " ",
      locale: 'en',
    );
  }

}
