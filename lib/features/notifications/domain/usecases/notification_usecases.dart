import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<AppNotification>>> call() {
    return repository.getNotifications();
  }
}

class SaveNotificationUseCase {
  final NotificationRepository repository;
  SaveNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(AppNotification notification) {
    return repository.saveNotification(notification);
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;
  MarkAllNotificationsReadUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}

class ClearNotificationsUseCase {
  final NotificationRepository repository;
  ClearNotificationsUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearNotifications();
  }
}
