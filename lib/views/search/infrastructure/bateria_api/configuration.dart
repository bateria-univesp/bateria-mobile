class BateriaApiConfiguration {
  static const baseUrl = String.fromEnvironment(
    'BATERIA_API_BASE_URL',
    defaultValue: 'http://192.168.18.4:8000/api',
  );
}
