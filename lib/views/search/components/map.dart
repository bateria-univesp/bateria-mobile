import 'package:bateria_mobile/infrastructure/bateria_api/client.dart';
import 'package:bateria_mobile/main.dart';
import 'package:bateria_mobile/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final markers = StateProvider((ref) => <Marker>{});

class SearchPageMap extends ConsumerStatefulWidget {
  const SearchPageMap({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPageMap> createState() => _SearchPageMapState();
}

class _SearchPageMapState extends ConsumerState<SearchPageMap> {
  final LatLng _initialLocation = const LatLng(-23.5499598, -46.6336663);
  final double _initialZoom = 12;

  late BateriaApiClient _apiClient;
  late ClusterManager<Place> _clusterManager;

  _fetchCollectPoints() async {
    final points = await _apiClient.fetchCollectPoints();
    final places = points.map((x) => Place.fromCollectPoint(x)).toList();
    _clusterManager.setItems(places);
  }

  _updateMarkers(Set<Marker> clusteredMarkers) {
    ref.read(markers.state).state = clusteredMarkers;
  }

  void _onMapCreated(GoogleMapController controller) {
    _clusterManager.setMapId(controller.mapId);
  }

  @override
  void initState() {
    super.initState();

    _clusterManager = ClusterManager([], _updateMarkers);
    _apiClient = ref.read(bateriaApiClientProvider);
    _fetchCollectPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return GoogleMap(
        onMapCreated: _onMapCreated,
        markers: ref.watch(markers),
        onCameraMove: _clusterManager.onCameraMove,
        onCameraIdle: _clusterManager.updateMap,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: _initialZoom,
        ),
      );
    });
  }
}
