import 'package:equatable/equatable.dart';

class Trade extends Equatable {
  final int id;
  final String instrument;
  final String direction; // 'buy' or 'sell'
  final double entryPrice;
  final double sl;
  final double tp;
  final double currentPrice;
  final double lotSize;
  final double pnlUsd;
  final double pnlR;
  final String status; // 'open', 'tp_hit', 'sl_hit', 'closed', 'pending'
  final String openedAt;
  final String? closedAt;
  final String exitMode;
  final double? exitPrice;
  final String? closedBy;

  const Trade({
    required this.id,
    required this.instrument,
    required this.direction,
    required this.entryPrice,
    required this.sl,
    required this.tp,
    required this.currentPrice,
    required this.lotSize,
    required this.pnlUsd,
    required this.pnlR,
    required this.status,
    required this.openedAt,
    this.closedAt,
    required this.exitMode,
    this.exitPrice,
    this.closedBy,
  });

  bool get isBuy => direction.toLowerCase() == 'buy';
  bool get isOpen => status.toLowerCase() == 'open' || status.toLowerCase() == 'pending';
  bool get isProfit => pnlUsd >= 0;

  @override
  List<Object?> get props => [
        id,
        instrument,
        direction,
        entryPrice,
        sl,
        tp,
        currentPrice,
        lotSize,
        pnlUsd,
        pnlR,
        status,
        openedAt,
        closedAt,
        exitMode,
        exitPrice,
        closedBy,
      ];
}
