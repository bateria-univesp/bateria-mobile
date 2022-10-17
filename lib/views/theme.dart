import 'package:flutter/material.dart';

const _seedColor = Color(0xff2dec96);

class BateriaTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 8,
        backgroundColor: _seedColor,
        shadowColor: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
