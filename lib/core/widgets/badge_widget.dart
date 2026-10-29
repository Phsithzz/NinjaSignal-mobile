import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DirBadge extends StatelessWidget {
  final String direction;

  const DirBadge({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    final isBuy = direction.toLowerCase() == 'buy';
    final color = isBuy ? AppColors.buy : AppColors.sell;
    final bg = isBuy ? AppColors.profitBg : AppColors.lossBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBuy ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            direction.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    String label = status;

    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
        color = AppColors.active;
        bg = AppColors.profitBg;
        label = '● ACTIVE';
        break;
      case 'tp_hit':
        color = AppColors.profit;
        bg = AppColors.profitBg;
        label = '★ TP HIT';
        break;
      case 'sl_hit':
        color = AppColors.loss;
        bg = AppColors.lossBg;
        label = '✕ SL HIT';
        break;
      case 'closed':
        color = AppColors.textMuted;
        bg = AppColors.cardBorder.withValues(alpha: 0.3);
        label = 'CLOSED';
        break;
      case 'pending':
        color = AppColors.paused;
        bg = AppColors.paused.withValues(alpha: 0.1);
        label = '○ PENDING';
        break;
      default:
        color = AppColors.textMuted;
        bg = AppColors.cardBorder.withValues(alpha: 0.3);
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class ConfidenceBadge extends StatelessWidget {
  final String confidence;

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (confidence.toLowerCase()) {
      case 'high':
        color = AppColors.primary;
        break;
      case 'medium':
        color = AppColors.blue;
        break;
      default:
        color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        confidence.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
