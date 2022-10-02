import 'package:bateria_mobile/views/search/infrastructure/bateria_api/client.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bateriaApiClientProvider = Provider((ref) => BateriaApiClient());

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
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SearchPage(),
    );
  }
}
