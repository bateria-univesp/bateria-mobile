class BateriaApiConfiguration {
  static const baseUrl = String.fromEnvironment(
    'BATERIA_API_BASE_URL',
    defaultValue: 'https://bateria-univesp.herokuapp.com/api',
  );
}
