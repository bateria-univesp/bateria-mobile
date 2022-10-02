import 'package:bateria_mobile/models/collect_point.dart';
import 'package:bateria_mobile/views/search/infrastructure/bateria_api/configuration.dart';
import 'package:dio/dio.dart';

class BateriaApiClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: BateriaApiConfiguration.baseUrl,
    ),
  );

  Future<List<CollectPoint>> fetchCollectPoints() async {
    final response = await _dio.get('/collect-point/');

    // Verify if it's possible to extract the list into an object.
    final result = <CollectPoint>[];

    for (var dataItem in response.data as List<dynamic>) {
      result.add(CollectPoint.fromJson(dataItem));
    }

    return result;
  }
}
