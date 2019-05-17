import 'package:flutter/services.dart';

class BankAccountFormatMark extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var fmt = newValue.text.replaceAll("-", "");
    if (fmt.length > 3)
      fmt =
          "${fmt.substring(0, fmt.length - 1)}-${fmt.substring(fmt.length - 1)}";
    return newValue.copyWith(
        text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
  }
}
