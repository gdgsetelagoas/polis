import 'package:flutter/services.dart';

class CreditCardFormatMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    // if (newValue.text.length < 3) return newValue;
    String fmt = _applyCpfMask(newValue.text);
    return newValue.copyWith(
        text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
  }

  String _applyCpfMask(String s) {
    var claered = s.replaceAll(" ", "").padRight(16);
    var first = claered.substring(0, 4).replaceAll(" ", "");
    var second = claered.substring(4, 8).replaceAll(" ", "");
    var third = claered.substring(8, 12).replaceAll(" ", "");
    var end = claered.substring(12).replaceAll(" ", "");
    if (second.isEmpty) return "$first";
    if (third.isEmpty) return "$first $second";
    if (end.isEmpty) return "$first $second $third";
    return "$first $second $third $end";
  }
}
