import 'package:equatable/equatable.dart';
import '../../../signals/domain/entities/signal_entity.dart';
import '../../../trades/domain/entities/trade_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class PushSignalAlertEvent extends NotificationEvent {
  final TradeSignal signal;

  const PushSignalAlertEvent(this.signal);

  @override
  List<Object?> get props => [signal];
}

class PushTradeAlertEvent extends NotificationEvent {
  final Trade trade;

  const PushTradeAlertEvent(this.trade);

  @override
  List<Object?> get props => [trade];
}

class PushCustomAlertEvent extends NotificationEvent {
  final String title;
  final String message;
  final String type;

  const PushCustomAlertEvent({
    required this.title,
    required this.message,
    this.type = 'system',
  });

  @override
  List<Object?> get props => [title, message, type];
}

class MarkAllNotificationsReadEvent extends NotificationEvent {}

class ClearAllNotificationsEvent extends NotificationEvent {}
