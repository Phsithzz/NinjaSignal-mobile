import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<AppNotificationModel>> getNotifications();
  Future<void> saveNotification(AppNotificationModel notification);
  Future<void> markAllAsRead();
  Future<void> clearNotifications();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences prefs;
  static const String keyNotifications = 'cached_notifications_list';

  NotificationLocalDataSourceImpl({required this.prefs});

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final raw = prefs.getString(keyNotifications);
    if (raw == null || raw.isEmpty) {
      // Seed default welcome notifications
      return [
        AppNotificationModel(
          id: 'welcome_1',
          title: '🥷 Welcome to Ninja Signal Mobile',
          message: 'Real-time scalping notifications are active and ready.',
          type: 'system',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
        ),
      ];
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => AppNotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveNotification(AppNotificationModel notification) async {
    final current = await getNotifications();
    current.insert(0, notification);
    if (current.length > 50) current.removeLast(); // Keep latest 50

    final raw = jsonEncode(current.map((e) => e.toJson()).toList());
    await prefs.setString(keyNotifications, raw);
  }

  @override
  Future<void> markAllAsRead() async {
    final current = await getNotifications();
    final updated = current.map((e) => e.copyWith(isRead: true)).toList();
    final raw = jsonEncode(updated.map((e) => AppNotificationModel.fromEntity(e).toJson()).toList());
    await prefs.setString(keyNotifications, raw);
  }

  @override
  Future<void> clearNotifications() async {
    await prefs.remove(keyNotifications);
  }
}
