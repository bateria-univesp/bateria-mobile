import 'package:flutter/material.dart';

class BateriaTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ),
      useMaterial3: true,
    );
  }
}
