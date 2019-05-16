import 'package:flutter/services.dart';

class CepFormatMark extends TextInputFormatter {
  final RegExp _regexClean = RegExp(r"\.|\-|\/\\");
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    // if (newValue.text.length < 3) return newValue;
    String fmt = _applyCepMask(newValue.text);
    return newValue.copyWith(
        text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
  }

  String _applyCepMask(String s) {
    var claered = s.replaceAll(_regexClean, "").padRight(8);
    var first = claered.substring(0, 5).replaceAll(" ", "");
    var second = claered.substring(5, 8).replaceAll(" ", "");
    if (second.isEmpty) return "$first";
    return "$first-$second";
  }
}
