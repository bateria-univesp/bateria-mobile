import 'package:flutter/material.dart';

class BateriaTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.red,
        cardColor: Colors.red[50],
      ),
      appBarTheme: const AppBarTheme(
        elevation: 8,
        shadowColor: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
