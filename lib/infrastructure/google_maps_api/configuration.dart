class GoogleMapsApiConfiguration {
  static const apiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: '',
  );
}
