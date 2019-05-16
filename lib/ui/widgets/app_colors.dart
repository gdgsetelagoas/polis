import 'package:flutter/material.dart';

class AppColors {
  static Color lightenOrDarkenColor(Color color, int factor) {
    return Color.fromARGB(
        255, color.red + factor, color.green + factor, color.blue + factor);
  }

  static MaterialColor newColor(Color color) {
    return MaterialColor(color.value, {
      50: lightenOrDarkenColor(color, 105),
      100: lightenOrDarkenColor(color, 100),
      200: lightenOrDarkenColor(color, 75),
      300: lightenOrDarkenColor(color, 50),
      400: lightenOrDarkenColor(color, 25),
      500: color,
      600: lightenOrDarkenColor(color, -25),
      700: lightenOrDarkenColor(color, -50),
      800: lightenOrDarkenColor(color, -75),
      900: lightenOrDarkenColor(color, -100),
    });
  }
}
