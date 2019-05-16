import 'package:flutter/services.dart';

class CpfFormatMark extends TextInputFormatter {
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
    var claered = s.replaceAll(_regexClean, "").padRight(11);
    var first = claered.substring(0, 3).replaceAll(" ", "");
    var second = claered.substring(3, 6).replaceAll(" ", "");
    var third = claered.substring(6, 9).replaceAll(" ", "");
    var end = claered.substring(9).replaceAll(" ", "");
    if (second.isEmpty) return "$first";
    if (third.isEmpty) return "$first.$second";
    if (end.isEmpty) return "$first.$second.$third";
    return "$first.$second.$third-$end";
  }
}
