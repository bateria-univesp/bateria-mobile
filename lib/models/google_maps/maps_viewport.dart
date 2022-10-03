import 'package:bateria_mobile/models/google_maps/maps_location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maps_viewport.freezed.dart';
part 'maps_viewport.g.dart';

@freezed
class MapsViewport with _$MapsViewport {
  const factory MapsViewport({
    required MapsLocation northeast,
    required MapsLocation southwest,
  }) = _MapsViewport;

  factory MapsViewport.fromJson(Map<String, Object?> json) =>
      _$MapsViewportFromJson(json);
}
