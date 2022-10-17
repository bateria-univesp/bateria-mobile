import 'dart:ui';

import 'package:bateria_mobile/infrastructure/bateria_api/client.dart';
import 'package:bateria_mobile/main.dart';
import 'package:bateria_mobile/models/cluster_place.dart';
import 'package:bateria_mobile/models/collect_point.dart';
import 'package:bateria_mobile/views/search/components/details_modal.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final markers = StateProvider((ref) => <Marker>{});
final collectPoint = StateProvider<CollectPoint?>((ref) => null);

class SearchPageMap extends ConsumerStatefulWidget {
  const SearchPageMap({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPageMap> createState() => _SearchPageMapState();
}

class _SearchPageMapState extends ConsumerState<SearchPageMap> {
  final LatLng _initialLocation = const LatLng(-23.5499598, -46.6336663);
  final double _initialZoom = 12;

  late BateriaApiClient _apiClient;
  late ClusterManager<ClusterPlace<CollectPoint>> _clusterManager;
  late GoogleMapController _mapController;

  _fetchCollectPoints() async {
    final points = await _apiClient.fetchCollectPoints();
    final places = points.map((x) => ClusterPlace.fromCollectPoint(x)).toList();
    _clusterManager.setItems(places);
  }

  Future<Marker> _markerBuilder(
      Cluster<ClusterPlace<CollectPoint>> cluster) async {
    return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: await _getClusterIcon(cluster),
        onTap: () => _onClusterTap(cluster));
  }

  Future<BitmapDescriptor> _getClusterIcon(
      Cluster<ClusterPlace> cluster) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final theme = Theme.of(context);

    final size = cluster.isMultiple ? 90.0 : 90.0;
    const strokeWidth = 2;

    final Paint backgroundPaint = Paint()
      ..color = theme.appBarTheme.backgroundColor!;
    final Paint backgroundDarkPaint = Paint()..color = Colors.black26;
    final Paint foregroundPaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..strokeWidth = strokeWidth * 2
      ..style = PaintingStyle.stroke;
    final markerPath = Path();

    markerPath.moveTo(size * 1 / 6, size * 1 / 3);
    markerPath.cubicTo(
        size * 1 / 6, size * 1 / 3, size * 1 / 6, 0, size / 2, 0);
    markerPath.cubicTo(
        size / 2, 0, size * 5 / 6, 0, size * 5 / 6, size * 1 / 3);
    markerPath.cubicTo(
        size * 5 / 6, size * 1 / 3, size * 3 / 4, size * 4 / 6, size / 2, size);
    markerPath.cubicTo(
        size / 2, size, size * 1 / 4, size * 4 / 6, size * 1 / 6, size * 1 / 3);

    canvas.translate(strokeWidth.toDouble(), strokeWidth.toDouble());

    if (cluster.isMultiple) {
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        size / 2 - strokeWidth,
        backgroundPaint,
      );
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        size / 2 - strokeWidth,
        foregroundPaint,
      );

      final painter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: cluster.count.toString(),
          style: TextStyle(
            fontSize: size / 2.5,
            color: foregroundPaint.color,
          ),
        ),
      );

      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    } else {
      canvas.drawPath(markerPath, backgroundPaint);
      canvas.drawPath(markerPath, foregroundPaint);
      canvas.drawCircle(
          Offset(size / 2, size * 1 / 3), size / 6, backgroundDarkPaint);
    }

    final image = await pictureRecorder.endRecording().toImage(
          size.toInt() + strokeWidth * 2,
          size.toInt() + strokeWidth * 2,
        );
    final imageBytes = await image.toByteData(format: ImageByteFormat.png);

    if (imageBytes == null) {
      throw Exception('Error while creating marker\'s bitmap.');
    }

    return BitmapDescriptor.fromBytes(imageBytes.buffer.asUint8List());
  }

  void _updateMarkers(Set<Marker> clusteredMarkers) {
    ref.read(markers.state).state = clusteredMarkers;
  }

  void _onClusterTap(Cluster<ClusterPlace<CollectPoint>> cluster) {
    if (cluster.isMultiple) {
      // Zoom in the area
      _zoomIntoLocation(cluster.location);
    } else {
      // If it's not multiple, then it *must* contain a single item.
      // That item has a reference to the collect point.
      final selectedPoint = cluster.items.elementAt(0).data;
      ref.read(collectPoint.state).state = selectedPoint;

      showModalBottomSheet(
          context: context, builder: (context) => const DetailsModal());
    }
  }

  Future _zoomIntoLocation(LatLng location) async {
    final currentZoom = await _mapController.getZoomLevel();
    await _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(location, currentZoom * 1.1));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _clusterManager.setMapId(controller.mapId);
  }

  void _handleAddressUpdate(oldAddress, newAddress) {
    if (newAddress == null) {
      // No address to handle.
      return;
    }

    final viewport = newAddress.geometry.viewport;
    final cameraUpdate = CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(viewport.southwest.lat, viewport.southwest.lng),
          northeast: LatLng(viewport.northeast.lat, viewport.northeast.lng),
        ),
        8);

    _mapController.animateCamera(cameraUpdate);
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
    _apiClient = ref.read(bateriaApiClient);

    _fetchCollectPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.listen(currentMapsAddress, _handleAddressUpdate);

      return GoogleMap(
        onMapCreated: _onMapCreated,
        markers: ref.watch(markers),
        onCameraMove: _clusterManager.onCameraMove,
        onCameraIdle: _clusterManager.updateMap,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: _initialZoom,
        ),
      );
    });
  }
}
