import 'package:bateria_mobile/models/collect_point.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterPlace<T> with ClusterItem {
  final String title;
  final String subtitle;
  final LatLng latLng;
  final T data;

  ClusterPlace(
      {required this.title,
      required this.subtitle,
      required this.latLng,
      required this.data});

  static ClusterPlace<CollectPoint> fromCollectPoint(
      CollectPoint collectPoint) {
    return ClusterPlace(
        title: collectPoint.name,
        subtitle: collectPoint.address,
        latLng: LatLng(collectPoint.latitude, collectPoint.longitude),
        data: collectPoint);
  }

  @override
  LatLng get location => latLng;
}
