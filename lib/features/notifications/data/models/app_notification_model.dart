import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.timestamp,
    super.isRead,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'system',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  factory AppNotificationModel.fromEntity(AppNotification entity) {
    return AppNotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
    );
  }
}
