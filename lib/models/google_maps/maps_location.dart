import 'package:freezed_annotation/freezed_annotation.dart';

part 'maps_location.freezed.dart';
part 'maps_location.g.dart';

@freezed
class MapsLocation with _$MapsLocation {
  const factory MapsLocation({
    required double lat,
    required double lng,
  }) = _MapsLocation;

  factory MapsLocation.fromJson(Map<String, Object?> json) =>
      _$MapsLocationFromJson(json);
}
