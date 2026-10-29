import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ninja_card.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../../domain/entities/app_notification.dart';

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Center'),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllNotificationsReadEvent());
            },
          ),
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textMuted),
            onPressed: () {
              context.read<NotificationBloc>().add(ClearAllNotificationsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    const Text(
                      'No notifications yet',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'New signals and trade executions will appear here',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final item = notifications[idx];
                return _NotificationItem(notification: item);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case 'signal':
        icon = Icons.radar_rounded;
        iconColor = AppColors.primary;
        break;
      case 'trade':
        icon = Icons.candlestick_chart_rounded;
        iconColor = AppColors.gold;
        break;
      case 'news':
        icon = Icons.warning_amber_rounded;
        iconColor = AppColors.loss;
        break;
      default:
        icon = Icons.info_outline_rounded;
        iconColor = AppColors.blue;
    }

    return NinjaCard(
      color: notification.isRead ? AppColors.card : AppColors.cardElevated,
      border: Border.all(
        color: notification.isRead ? AppColors.cardBorder : AppColors.primary.withValues(alpha: 0.4),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      Formatters.formatRelativeTime(notification.timestamp),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
