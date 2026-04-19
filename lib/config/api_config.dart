class ApiConfig {
  static const String _hosted = 'https://voyant-server.vercel.app/api';
  static const String _localAndroidEmulator = 'http://10.0.2.2:3000/api';

  // flip this when needed
  static const bool useHosted = true;

  static String get baseUrl => useHosted ? _hosted : _localAndroidEmulator;
}
