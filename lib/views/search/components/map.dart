import 'dart:ui';

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

  Future<Marker> _markerBuilder(Cluster<Place> cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      icon: cluster.isMultiple
          ? await _getClusterIcon(cluster)
          : BitmapDescriptor.defaultMarker,
    );
  }

  Future<BitmapDescriptor> _getClusterIcon(Cluster<Place> cluster) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final size = cluster.isMultiple ? 90 : 75;
    const strokeWidth = 2.0;

    final Paint redPaint = Paint()
      ..color = const Color.fromARGB(255, 234, 67, 52);
    final Paint whitePaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeWidth = strokeWidth * 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      whitePaint,
    );
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2 - strokeWidth,
      redPaint,
    );

    if (cluster.isMultiple) {
      final painter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: cluster.count.toString(),
          style: TextStyle(
            fontSize: size / 2.5,
            color: whitePaint.color,
          ),
        ),
      );

      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final image = await pictureRecorder.endRecording().toImage(size, size);
    final imageBytes = await image.toByteData(format: ImageByteFormat.png);

    if (imageBytes == null) {
      throw Exception('Error while creating marker\'s bitmap.');
    }

    return BitmapDescriptor.fromBytes(imageBytes.buffer.asUint8List());
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

    _clusterManager = ClusterManager(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 18.0, 20.0],
    );
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
