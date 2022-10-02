import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  // The following location and zoom put São Paulo in focus.
  final LatLng _initialLocation = const LatLng(-23.5499598, -46.6336663);
  final double _initialZoom = 11;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bateria'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: _initialZoom,
        ),
      ),
    );
  }
}
