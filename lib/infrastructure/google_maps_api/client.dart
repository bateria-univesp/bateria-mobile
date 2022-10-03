import 'package:bateria_mobile/infrastructure/google_maps_api/configuration.dart';
import 'package:bateria_mobile/models/google_maps/maps_address.dart';
import 'package:dio/dio.dart';

class GoogleMapsApiClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com/maps/api',
      queryParameters: {
        'key': GoogleMapsApiConfiguration.apiKey,
      },
    ),
  );

  Future<List<MapsAddress>> fetchPlacesByText(String query) async {
    final response = await _dio.get(
      '/place/textsearch/json',
      queryParameters: {
        'query': query,
        ..._dio.options.queryParameters,
      },
    );

    final result = <MapsAddress>[];

    for (var dataItem in response.data['results'] as List<dynamic>) {
      result.add(MapsAddress.fromJson(dataItem));
    }

    return result;
  }
}
