import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final SaveNotificationUseCase saveNotificationUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;
  final ClearNotificationsUseCase clearNotificationsUseCase;
  final NotificationService notificationService;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.saveNotificationUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.clearNotificationsUseCase,
    required this.notificationService,
  }) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<PushSignalAlertEvent>(_onPushSignalAlert);
    on<PushTradeAlertEvent>(_onPushTradeAlert);
    on<PushCustomAlertEvent>(_onPushCustomAlert);
    on<MarkAllNotificationsReadEvent>(_onMarkAllAsRead);
    on<ClearAllNotificationsEvent>(_onClearAll);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unread,
        ));
      },
    );
  }

  Future<void> _onPushSignalAlert(
    PushSignalAlertEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final signal = event.signal;
    final symbol = Formatters.prettySymbol(signal.instrument);
    final direction = signal.direction.toUpperCase();

    // 1. Fire system push notification
    await notificationService.showSignalNotification(signal);

    // 2. Persist in local history
    final appNotification = AppNotification(
      id: 'sig_${signal.id}_${DateTime.now().millisecondsSinceEpoch}',
      title: '🥷 NEW SIGNAL: $direction $symbol',
      message: 'Entry: ${Formatters.formatPrice(signal.entry)} | SL: ${Formatters.formatPrice(signal.sl)} | TP: ${Formatters.formatPrice(signal.tp)}',
      type: 'signal',
      timestamp: DateTime.now(),
      isRead: false,
    );

    await saveNotificationUseCase(appNotification);
    add(LoadNotificationsEvent());
  }

  Future<void> _onPushTradeAlert(
    PushTradeAlertEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final trade = event.trade;
    final symbol = Formatters.prettySymbol(trade.instrument);

    // 1. Fire system push notification
    await notificationService.showTradeExitNotification(trade);

    // 2. Persist in local history
    final appNotification = AppNotification(
      id: 'trd_${trade.id}_${DateTime.now().millisecondsSinceEpoch}',
      title: '${trade.isProfit ? "🎯 TP HIT" : "🛑 SL HIT"}: $symbol',
      message: 'P&L: ${Formatters.formatMoney(trade.pnlUsd)} (${trade.pnlR >= 0 ? "+" : ""}${trade.pnlR.toStringAsFixed(2)}R)',
      type: 'trade',
      timestamp: DateTime.now(),
      isRead: false,
    );

    await saveNotificationUseCase(appNotification);
    add(LoadNotificationsEvent());
  }

  Future<void> _onPushCustomAlert(
    PushCustomAlertEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: event.title,
      body: event.message,
    );

    final appNotification = AppNotification(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: event.title,
      message: event.message,
      type: event.type,
      timestamp: DateTime.now(),
      isRead: false,
    );

    await saveNotificationUseCase(appNotification);
    add(LoadNotificationsEvent());
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await markAllNotificationsReadUseCase();
    add(LoadNotificationsEvent());
  }

  Future<void> _onClearAll(
    ClearAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await clearNotificationsUseCase();
    add(LoadNotificationsEvent());
  }
}
