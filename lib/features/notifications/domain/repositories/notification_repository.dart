import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications();
  Future<Either<Failure, void>> saveNotification(AppNotification notification);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> clearNotifications();
}
