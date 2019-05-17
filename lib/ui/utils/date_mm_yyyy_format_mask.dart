import 'package:flutter/services.dart';

class DateMMYYYYFormatMask extends TextInputFormatter {
  final RegExp _regexClean = RegExp(r"\.|\-|\/\\");
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
    var claered = s.replaceAll(_regexClean, "").padRight(6);
    var first = claered.substring(0, 2).replaceAll(" ", "");
    var second = claered.substring(2, 6).replaceAll(" ", "");
    if (second.isEmpty) return "$first";
    return "$first/$second";
  }
}
