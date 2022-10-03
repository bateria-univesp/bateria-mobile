import 'package:bateria_mobile/models/google_maps/maps_location.dart';
import 'package:bateria_mobile/models/google_maps/maps_viewport.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maps_geometry.freezed.dart';
part 'maps_geometry.g.dart';

@freezed
class MapsGeometry with _$MapsGeometry {
  const factory MapsGeometry({
    required MapsLocation location,
    required MapsViewport viewport,
  }) = _MapsGeometry;

  factory MapsGeometry.fromJson(Map<String, Object?> json) =>
      _$MapsGeometryFromJson(json);
}
