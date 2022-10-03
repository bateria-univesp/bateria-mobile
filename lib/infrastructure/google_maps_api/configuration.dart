class GoogleMapsApiConfiguration {
  static const apiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: 'AIzaSyC8SKu0RwkYDGz5S6ev5xzyDW7YBBn9nY8',
  );
}
