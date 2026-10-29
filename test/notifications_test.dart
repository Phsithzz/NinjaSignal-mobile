import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/notifications/data/models/app_notification_model.dart';
import 'package:mobile/features/notifications/domain/entities/app_notification.dart';

void main() {
  group('Notification Model Tests', () {
    test('AppNotificationModel fromJson and toJson work correctly', () {
      final json = {
        'id': 'notif_123',
        'title': '🥷 NEW SIGNAL: BUY XAU/USD',
        'message': 'Entry: 2685.50 | SL: 2675.00 | TP: 2700.00',
        'type': 'signal',
        'timestamp': '2026-10-29T06:50:00.000Z',
        'is_read': false,
      };

      final model = AppNotificationModel.fromJson(json);
      expect(model.id, 'notif_123');
      expect(model.title, '🥷 NEW SIGNAL: BUY XAU/USD');
      expect(model.type, 'signal');
      expect(model.isRead, false);

      final outJson = model.toJson();
      expect(outJson['id'], 'notif_123');
      expect(outJson['type'], 'signal');
    });

    test('copyWith updates isRead state correctly', () {
      final notif = AppNotification(
        id: '1',
        title: 'Title',
        message: 'Message',
        type: 'trade',
        timestamp: DateTime.now(),
        isRead: false,
      );

      final updated = notif.copyWith(isRead: true);
      expect(updated.isRead, true);
      expect(updated.title, 'Title');
    });
  });
}
