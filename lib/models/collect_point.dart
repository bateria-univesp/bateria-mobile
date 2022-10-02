import 'package:freezed_annotation/freezed_annotation.dart';

part 'collect_point.freezed.dart';
part 'collect_point.g.dart';

@freezed
class CollectPoint with _$CollectPoint {
  const factory CollectPoint({
    required double latitude,
    required double longitude,
    required String name,
    required String address,
  }) = _CollectPoint;

  factory CollectPoint.fromJson(Map<String, Object?> json) =>
      _$CollectPointFromJson(json);
}
