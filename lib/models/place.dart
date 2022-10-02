import 'package:bateria_mobile/models/collect_point.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  final String title;
  final String subtitle;
  final LatLng latLng;

  Place({required this.title, required this.subtitle, required this.latLng});

  factory Place.fromCollectPoint(CollectPoint collectPoint) {
    return Place(
        title: collectPoint.name,
        subtitle: collectPoint.address,
        latLng: LatLng(collectPoint.latitude, collectPoint.longitude));
  }

  @override
  LatLng get location => latLng;
}
