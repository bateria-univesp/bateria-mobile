import 'package:bateria_mobile/main.dart';
import 'package:bateria_mobile/models/collect_point.dart';
import 'package:bateria_mobile/views/search/infrastructure/bateria_api/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final collectPointsList = StateProvider((ref) => <CollectPoint>[]);
final collectPointsMarkers = Provider((ref) {
  final list = ref.watch(collectPointsList);

  return list
      .map(
        (item) => Marker(
          markerId: MarkerId(item.name),
          infoWindow: InfoWindow(
            title: item.name,
            snippet: item.address,
          ),
          position: LatLng(item.latitude, item.longitude),
        ),
      )
      .toSet();
});

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<SearchPage> {
  late BateriaApiClient _apiClient;

  _fetchCollectPoints() async {
    final collectPoints = await _apiClient.fetchCollectPoints();
    ref.read(collectPointsList.state).state = collectPoints;
  }

  @override
  void initState() {
    super.initState();

    _apiClient = ref.read(bateriaApiClientProvider);
    _fetchCollectPoints();
  }

  // The following location and zoom put São Paulo in focus.
  final LatLng _initialLocation = const LatLng(-23.5499598, -46.6336663);
  final double _initialZoom = 15;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bateria'),
        ),
        body: Consumer(builder: (context, ref, _) {
          final markers = ref.watch(collectPointsMarkers);

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: _initialZoom,
            ),
            markers: markers,
          );
        }),
      );
    });
  }
}
