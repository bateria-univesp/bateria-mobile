class BateriaApiConfiguration {
  static const baseUrl = String.fromEnvironment(
    'BATERIA_API_BASE_URL',
    defaultValue: 'http://192.168.15.44:8000/api',
  );
}
