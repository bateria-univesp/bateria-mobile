import 'package:bateria_mobile/models/google_maps/maps_geometry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maps_address.freezed.dart';
part 'maps_address.g.dart';

@freezed
class MapsAddress with _$MapsAddress {
  const factory MapsAddress({
    required String name,
    required MapsGeometry geometry,
  }) = _MapsAddress;

  factory MapsAddress.fromJson(Map<String, Object?> json) =>
      _$MapsAddressFromJson(json);
}
