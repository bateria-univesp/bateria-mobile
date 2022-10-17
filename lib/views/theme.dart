import 'package:flutter/material.dart';

class BateriaTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff20e9b3),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 8,
        backgroundColor: Color(0xff2dec96),
        shadowColor: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
