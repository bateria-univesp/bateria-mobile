import 'package:flutter/material.dart';

class BateriaTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.red,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 2,
      ),
      useMaterial3: true,
    );
  }
}
