import '../../domain/entities/trade_entity.dart';

class TradeModel extends Trade {
  const TradeModel({
    required super.id,
    required super.instrument,
    required super.direction,
    required super.entryPrice,
    required super.sl,
    required super.tp,
    required super.currentPrice,
    required super.lotSize,
    required super.pnlUsd,
    required super.pnlR,
    required super.status,
    required super.openedAt,
    super.closedAt,
    required super.exitMode,
    super.exitPrice,
    super.closedBy,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      instrument: json['instrument'] ?? 'XAU_USD',
      direction: json['direction']?.toString().toLowerCase() ?? 'buy',
      entryPrice: (json['entry_price'] as num?)?.toDouble() ?? 0.0,
      sl: (json['sl'] as num?)?.toDouble() ?? 0.0,
      tp: (json['tp'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (json['current_price'] as num?)?.toDouble() ??
          (json['entry_price'] as num?)?.toDouble() ??
          0.0,
      lotSize: (json['lot_size'] as num?)?.toDouble() ?? 0.01,
      pnlUsd: (json['pnl_usd'] as num?)?.toDouble() ?? 0.0,
      pnlR: (json['pnl_r'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString().toLowerCase() ?? 'open',
      openedAt: json['opened_at']?.toString() ?? '',
      closedAt: json['closed_at']?.toString(),
      exitMode: json['exit_mode']?.toString() ?? 'scale_out',
      exitPrice: (json['exit_price'] as num?)?.toDouble(),
      closedBy: json['closed_by']?.toString(),
    );
  }
}
