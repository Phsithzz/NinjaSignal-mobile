import 'package:equatable/equatable.dart';

class SystemConfig extends Equatable {
  final double riskPerTradeUsd;
  final double maxLossPerTradeUsd;
  final double takeProfitUsd;
  final String exitMode;
  final String targetSource;
  final int maxConsecutiveLosses;
  final double maxDrawdownPct;

  const SystemConfig({
    required this.riskPerTradeUsd,
    required this.maxLossPerTradeUsd,
    required this.takeProfitUsd,
    required this.exitMode,
    required this.targetSource,
    required this.maxConsecutiveLosses,
    required this.maxDrawdownPct,
  });

  @override
  List<Object?> get props => [
        riskPerTradeUsd,
        maxLossPerTradeUsd,
        takeProfitUsd,
        exitMode,
        targetSource,
        maxConsecutiveLosses,
        maxDrawdownPct,
      ];
}
