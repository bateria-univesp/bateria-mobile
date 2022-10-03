import 'package:bateria_mobile/infrastructure/bateria_api/client.dart';
import 'package:bateria_mobile/infrastructure/google_maps_api/client.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:bateria_mobile/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bateriaApiClient = Provider((ref) => BateriaApiClient());
final googleMapsApiClient = Provider((ref) => GoogleMapsApiClient());

void main() {
  runApp(
    const ProviderScope(
      child: BateriaApp(),
    ),
  );
}

class BateriaApp extends StatelessWidget {
  const BateriaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: BateriaTheme.buildTheme(),
      home: const SearchPage(),
    );
  }
}
