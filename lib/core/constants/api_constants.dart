class ApiConstants {
  ApiConstants._();

  // Default URL: If running in Android emulator use 10.0.2.2, otherwise localhost or custom
  static const String defaultBaseUrl = 'http://10.0.2.2:8000';
  static const String defaultLocalhostUrl = 'http://localhost:8000';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';
  static const String refresh = '/api/auth/refresh';

  // Dashboard & System endpoints
  static const String status = '/api/status';
  static const String prices = '/api/prices';
  static const String systemToggle = '/api/system/toggle';
  static const String dailyStats = '/api/stats/daily';
  static const String weeklyStats = '/api/stats/weekly';
  static const String monthlyStats = '/api/stats/monthly';
  static const String equityStats = '/api/stats/equity';

  // Signals endpoints
  static const String signals = '/api/signals';

  // Trades endpoints
  static const String trades = '/api/trades';
  static String closeTrade(int tradeId) => '/api/trades/$tradeId/close';

  // News endpoints
  static const String news = '/api/news';
  static const String newsEvents = '/api/news/events';

  // Config & Settings endpoints
  static const String config = '/api/config';
  static const String instruments = '/api/instruments';
}
