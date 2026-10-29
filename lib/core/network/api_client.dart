import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences prefs;

  static const String keyToken = 'auth_token';
  static const String keyBaseUrl = 'base_url';
  static const String keyIsMock = 'is_mock_mode';

  ApiClient({required this.dio, required this.prefs}) {
    _initDio();
  }

  void _initDio() {
    dio.options.baseUrl = getBaseUrl();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            // Also pass cookie header for FastAPI endpoints that check Cookie
            options.headers['Cookie'] = 'access_token=$token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          return handler.next(error);
        },
      ),
    );
  }

  String getBaseUrl() {
    return prefs.getString(keyBaseUrl) ?? ApiConstants.defaultBaseUrl;
  }

  Future<void> setBaseUrl(String url) async {
    await prefs.setString(keyBaseUrl, url);
    dio.options.baseUrl = url;
  }

  bool isMockMode() {
    return prefs.getBool(keyIsMock) ?? false;
  }

  Future<void> setMockMode(bool enabled) async {
    await prefs.setBool(keyIsMock, enabled);
  }

  String? getToken() {
    return prefs.getString(keyToken);
  }

  Future<void> saveToken(String token) async {
    await prefs.setString(keyToken, token);
  }

  Future<void> clearToken() async {
    await prefs.remove(keyToken);
  }

  // Generic HTTP GET with Mock Mode fallback
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    if (isMockMode()) {
      return _mockHandler('GET', endpoint, queryParameters: queryParameters);
    }

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // Generic HTTP POST with Mock Mode fallback
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    if (isMockMode()) {
      return _mockHandler('POST', endpoint, data: data);
    }

    try {
      final response = await dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // Generic HTTP PATCH with Mock Mode fallback
  Future<dynamic> patch(String endpoint, {dynamic data}) async {
    if (isMockMode()) {
      return _mockHandler('PATCH', endpoint, data: data);
    }

    try {
      final response = await dio.patch(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('Unable to connect to NinjaSignal server. Please verify server address and connection.');
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    String message = 'An unexpected server error occurred';

    if (responseData is Map && responseData['detail'] != null) {
      message = responseData['detail'].toString();
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    }

    if (statusCode == 401) {
      return AuthFailure(message);
    }
    return ServerFailure(message, statusCode: statusCode);
  }

  // Realistic mock responses matching NinjaSignal web mock API
  dynamic _mockHandler(String method, String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) {
    final now = DateTime.now().toUtc();

    if (endpoint == ApiConstants.login) {
      return {'access_token': 'mock_jwt_token_ninja_trader_secure'};
    }

    if (endpoint == ApiConstants.register) {
      return {
        'id': 99,
        'email': data?['email'] ?? 'trader@ninjasignal.com',
        'name': data?['name'] ?? 'Ninja Trader',
        'role': 'subscriber',
        'is_active': true,
      };
    }

    if (endpoint == ApiConstants.me) {
      return {
        'id': 1,
        'email': 'admin@ninjasignal.com',
        'name': 'Ninja Trader Pro',
        'role': 'admin',
        'is_active': true,
      };
    }

    if (endpoint == ApiConstants.logout) {
      return {'detail': 'logged out'};
    }

    if (endpoint == ApiConstants.status) {
      return {
        'system_enabled': true,
        'session': {
          'label': 'London / NY Overlap',
          'window': '07:00 - 21:00 ICT',
          'is_active': true,
        },
        'price_feed': 'Twelve Data · MOCK',
        'active_instruments': [
          'XAU_USD',
          'EUR_USD',
          'GBP_JPY',
          'USD_CAD',
          'BTC_USDT',
          'USD_CHF',
        ],
      };
    }

    if (endpoint == ApiConstants.systemToggle) {
      return {'system_enabled': true};
    }

    if (endpoint == ApiConstants.prices) {
      return {
        'XAU_USD': {
          'symbol': 'XAU_USD',
          'bid': 2684.80,
          'ask': 2685.20,
          'mid': 2685.00,
          'change_pct': 0.75,
          'time': now.subtract(const Duration(seconds: 15)).toIso8601String(),
        },
        'EUR_USD': {
          'symbol': 'EUR_USD',
          'bid': 1.0842,
          'ask': 1.0844,
          'mid': 1.0843,
          'change_pct': -0.18,
          'time': now.subtract(const Duration(seconds: 22)).toIso8601String(),
        },
        'GBP_JPY': {
          'symbol': 'GBP_JPY',
          'bid': 198.42,
          'ask': 198.46,
          'mid': 198.44,
          'change_pct': 0.45,
          'time': now.subtract(const Duration(seconds: 8)).toIso8601String(),
        },
        'USD_CAD': {
          'symbol': 'USD_CAD',
          'bid': 1.3850,
          'ask': 1.3853,
          'mid': 1.38515,
          'change_pct': 0.12,
          'time': now.subtract(const Duration(seconds: 40)).toIso8601String(),
        },
        'BTC_USDT': {
          'symbol': 'BTC_USDT',
          'bid': 68410.00,
          'ask': 68425.00,
          'mid': 68417.50,
          'change_pct': 2.34,
          'time': now.subtract(const Duration(seconds: 5)).toIso8601String(),
        },
      };
    }

    if (endpoint == ApiConstants.dailyStats) {
      return {
        'total_usd': 342.50,
        'win_rate': 0.714,
        'total_trades': 7,
        'wins': 5,
        'losses': 2,
        'profit_factor': 2.45,
      };
    }

    if (endpoint == ApiConstants.equityStats) {
      double running = 1000.0;
      final points = <Map<String, dynamic>>[];
      for (int i = 20; i >= 0; i--) {
        running += (i % 3 == 0 ? -12.5 : 24.8);
        points.add({
          'time': now.subtract(Duration(hours: i * 3)).toIso8601String(),
          'equity': running,
        });
      }
      return {'points': points};
    }

    if (endpoint == ApiConstants.signals) {
      return [
        {
          'id': 101,
          'instrument': 'XAU_USD',
          'direction': 'buy',
          'entry': 2682.50,
          'sl': 2676.00,
          'tp': 2695.50,
          'rr': 2.0,
          'confidence': 'high',
          'status': 'active',
          'rules_triggered': ['EMA 20/50 Cross', 'RSI Bullish Div', 'FVG Bounce', 'H4 Trend Bias'],
          'time': now.subtract(const Duration(minutes: 18)).toIso8601String(),
        },
        {
          'id': 102,
          'instrument': 'GBP_JPY',
          'direction': 'sell',
          'entry': 198.80,
          'sl': 199.35,
          'tp': 197.70,
          'rr': 2.0,
          'confidence': 'high',
          'status': 'active',
          'rules_triggered': ['Resistance Rejection', 'Bearish Engulfing', 'Stochastic Overbought'],
          'time': now.subtract(const Duration(minutes: 42)).toIso8601String(),
        },
        {
          'id': 103,
          'instrument': 'EUR_USD',
          'direction': 'buy',
          'entry': 1.0835,
          'sl': 1.0815,
          'tp': 1.0875,
          'rr': 2.0,
          'confidence': 'medium',
          'status': 'closed',
          'rules_triggered': ['H1 S&D Zone', 'MACD Histogram Up'],
          'time': now.subtract(const Duration(hours: 3)).toIso8601String(),
        },
      ];
    }

    if (endpoint == ApiConstants.trades) {
      return [
        {
          'id': 201,
          'instrument': 'XAU_USD',
          'direction': 'buy',
          'entry_price': 2682.50,
          'sl': 2676.00,
          'tp': 2695.50,
          'current_price': 2685.00,
          'lot_size': 0.01,
          'pnl_usd': 25.00,
          'pnl_r': 0.38,
          'status': 'open',
          'opened_at': now.subtract(const Duration(minutes: 18)).toIso8601String(),
          'closed_at': null,
          'exit_mode': 'scale_out',
        },
        {
          'id': 202,
          'instrument': 'GBP_JPY',
          'direction': 'sell',
          'entry_price': 198.80,
          'sl': 199.35,
          'tp': 197.70,
          'current_price': 198.44,
          'lot_size': 0.01,
          'pnl_usd': 24.32,
          'pnl_r': 0.65,
          'status': 'open',
          'opened_at': now.subtract(const Duration(minutes: 42)).toIso8601String(),
          'closed_at': null,
          'exit_mode': 'scale_out',
        },
        {
          'id': 203,
          'instrument': 'EUR_USD',
          'direction': 'buy',
          'entry_price': 1.0835,
          'sl': 1.0815,
          'tp': 1.0875,
          'current_price': 1.0875,
          'exit_price': 1.0875,
          'lot_size': 0.01,
          'pnl_usd': 40.00,
          'pnl_r': 2.0,
          'status': 'tp_hit',
          'opened_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
          'closed_at': now.subtract(const Duration(hours: 1)).toIso8601String(),
          'exit_mode': 'fixed_target',
        },
      ];
    }

    if (endpoint.startsWith('/api/trades/') && endpoint.endsWith('/close')) {
      return {'detail': 'Trade closed successfully', 'status': 'closed'};
    }

    if (endpoint == ApiConstants.news || endpoint == ApiConstants.newsEvents) {
      return {
        'calendar': [
          {
            'country': 'USD',
            'title': 'Core PCE Price Index (MoM)',
            'impact': 'high',
            'time_ict': now.add(const Duration(hours: 2)).toIso8601String(),
            'forecast': '0.3%',
            'previous': '0.2%',
          },
          {
            'country': 'EUR',
            'title': 'ECB Monetary Policy Meeting Accounts',
            'impact': 'high',
            'time_ict': now.add(const Duration(hours: 4)).toIso8601String(),
            'forecast': null,
            'previous': null,
          },
          {
            'country': 'USD',
            'title': 'Initial Jobless Claims',
            'impact': 'medium',
            'time_ict': now.add(const Duration(hours: 5)).toIso8601String(),
            'forecast': '220K',
            'previous': '227K',
          },
        ],
        'events': [
          {
            'headline': 'Fed Signals Patience on Future Rate Reductions',
            'tier': 1,
            'action': 'pause_signals',
            'time': now.subtract(const Duration(minutes: 50)).toIso8601String(),
          },
          {
            'headline': 'US GDP Growth Beats Expectations at 2.8% Annualized',
            'tier': 2,
            'action': 'fyi',
            'time': now.subtract(const Duration(hours: 2)).toIso8601String(),
          },
        ]
      };
    }

    if (endpoint == ApiConstants.config) {
      return {
        'risk_per_trade_usd': 3.0,
        'max_loss_per_trade_usd': 5.0,
        'take_profit_usd': 6.0,
        'exit_mode': 'scale_out',
        'target_source': 'swing',
        'max_consecutive_losses': 3,
        'max_drawdown_pct': 10.0,
      };
    }

    return {};
  }
}
