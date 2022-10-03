import 'package:bateria_mobile/models/google_maps/maps_address.dart';
import 'package:bateria_mobile/views/search/components/app_bar.dart';
import 'package:bateria_mobile/views/search/components/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentMapsAddress = StateProvider<MapsAddress?>((ref) => null);

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return const Scaffold(
        appBar: SearchPageAppBar(),
        body: SearchPageMap(),
      );
    });
  }
}
