import '../../domain/entities/config_entity.dart';

class SystemConfigModel extends SystemConfig {
  const SystemConfigModel({
    required super.riskPerTradeUsd,
    required super.maxLossPerTradeUsd,
    required super.takeProfitUsd,
    required super.exitMode,
    required super.targetSource,
    required super.maxConsecutiveLosses,
    required super.maxDrawdownPct,
  });

  factory SystemConfigModel.fromJson(Map<String, dynamic> json) {
    return SystemConfigModel(
      riskPerTradeUsd: (json['risk_per_trade_usd'] as num?)?.toDouble() ?? 3.0,
      maxLossPerTradeUsd: (json['max_loss_per_trade_usd'] as num?)?.toDouble() ?? 5.0,
      takeProfitUsd: (json['take_profit_usd'] as num?)?.toDouble() ?? 6.0,
      exitMode: json['exit_mode']?.toString() ?? 'scale_out',
      targetSource: json['target_source']?.toString() ?? 'swing',
      maxConsecutiveLosses: (json['max_consecutive_losses'] as num?)?.toInt() ?? 3,
      maxDrawdownPct: (json['max_drawdown_pct'] as num?)?.toDouble() ?? 10.0,
    );
  }
}
