import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  // The following location and zoom put São Paulo in focus.
  final LatLng _initialLocation = const LatLng(-23.5499598, -46.6336663);
  final double _initialZoom = 10;

  final Marker _sampleMarker = const Marker(
    markerId: MarkerId('sample-location'),
    position: LatLng(-23.5551967, -46.4151768),
    infoWindow: InfoWindow(
      title: 'Ecoponto Guaianazes',
      snippet: 'R. da Passagem Funda, 250',
    ),
  );

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
        markers: {
          _sampleMarker,
        },
      ),
    );
  }
}
