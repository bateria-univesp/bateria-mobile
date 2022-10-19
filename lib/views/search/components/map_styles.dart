import 'package:flutter/widgets.dart';

class MapStyles {
  static Future<String> getStyles(context) async {
    return DefaultAssetBundle.of(context)
        .loadString('assets/maps/styles/default.json');
  }
}
