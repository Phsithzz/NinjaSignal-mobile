import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/signals/domain/entities/signal_entity.dart';
import '../../features/trades/domain/entities/trade_entity.dart';
import '../utils/formatters.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const String channelId = 'ninja_signal_alerts';
  static const String channelName = 'Ninja Signal Alerts';
  static const String channelDesc = 'Real-time scalping signals, TP/SL executions, and news alerts';

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(defaultActionName: 'Open notification');

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        },
      );

      // Request permission on Android 13+
      if (!kIsWeb && Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        await androidImplementation?.requestNotificationsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('showNotification error: $e');
    }
  }

  // Pre-configured notification for new trade signal
  Future<void> showSignalNotification(TradeSignal signal) async {
    final symbol = Formatters.prettySymbol(signal.instrument);
    final direction = signal.direction.toUpperCase();
    final entry = Formatters.formatPrice(signal.entry);
    final tp = Formatters.formatPrice(signal.tp);
    final sl = Formatters.formatPrice(signal.sl);
    final title = '🥷 NEW SIGNAL: $direction $symbol';
    final body = 'Entry: $entry | SL: $sl | TP: $tp (1:${signal.rr.toStringAsFixed(1)})';

    await showNotification(
      id: signal.id,
      title: title,
      body: body,
      payload: 'signal_${signal.id}',
    );
  }

  // Pre-configured notification for TP / SL trade hit
  Future<void> showTradeExitNotification(Trade trade) async {
    final symbol = Formatters.prettySymbol(trade.instrument);
    final isProfit = trade.isProfit;
    final icon = isProfit ? '🎯 TP HIT' : '🛑 SL HIT';
    final title = '$icon: $symbol';
    final pnl = Formatters.formatMoney(trade.pnlUsd);
    final r = '${trade.pnlR >= 0 ? "+" : ""}${trade.pnlR.toStringAsFixed(2)}R';
    final body = 'Trade closed: $pnl ($r) at ${Formatters.formatPrice(trade.exitPrice ?? trade.currentPrice)}';

    await showNotification(
      id: trade.id + 10000,
      title: title,
      body: body,
      payload: 'trade_${trade.id}',
    );
  }

  // Pre-configured notification for high-impact news
  Future<void> showNewsWarningNotification({required String country, required String title, required String timeIct}) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '⚠️ HIGH IMPACT NEWS: $country',
      body: '$title ($timeIct) — Scalping paused ±30m',
      payload: 'news_alert',
    );
  }
}
