import 'package:flutter/material.dart';

class SorrisinhoTheme {
  static Color primaryColor = const Color(0xFF0D593B);
  static Color informationBackgroundColor = const Color(0xFF00008B);

  static MaterialColor getMaterialColor() {
    final int red = primaryColor.red;
    final int green = primaryColor.green;
    final int blue = primaryColor.blue;
    final int alpha = primaryColor.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };

    return MaterialColor(primaryColor.value, shades);
  }
}
