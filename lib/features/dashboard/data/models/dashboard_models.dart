import '../../domain/entities/dashboard_entities.dart';

class SystemStatusModel extends SystemStatus {
  const SystemStatusModel({
    required super.systemEnabled,
    required super.sessionLabel,
    required super.sessionWindow,
    required super.priceFeed,
    required super.activeInstruments,
  });

  factory SystemStatusModel.fromJson(Map<String, dynamic> json) {
    final session = json['session'] as Map<String, dynamic>? ?? {};
    final activeList = (json['active_instruments'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return SystemStatusModel(
      systemEnabled: json['system_enabled'] ?? true,
      sessionLabel: session['label'] ?? 'Standard Session',
      sessionWindow: session['window'] ?? '07:00 - 21:00 ICT',
      priceFeed: json['price_feed'] ?? 'Standard Feed',
      activeInstruments: activeList,
    );
  }
}

class LivePriceModel extends LivePrice {
  const LivePriceModel({
    required super.symbol,
    required super.mid,
    super.bid,
    super.ask,
    super.changePct,
    super.time,
  });

  factory LivePriceModel.fromJson(String symbol, Map<String, dynamic> json) {
    return LivePriceModel(
      symbol: symbol,
      mid: (json['mid'] as num?)?.toDouble() ?? 0.0,
      bid: (json['bid'] as num?)?.toDouble(),
      ask: (json['ask'] as num?)?.toDouble(),
      changePct: (json['change_pct'] as num?)?.toDouble(),
      time: json['time']?.toString(),
    );
  }
}

class DailyStatsModel extends DailyStats {
  const DailyStatsModel({
    required super.totalUsd,
    required super.winRate,
    required super.totalTrades,
    required super.wins,
    required super.losses,
    required super.profitFactor,
  });

  factory DailyStatsModel.fromJson(Map<String, dynamic> json) {
    return DailyStatsModel(
      totalUsd: (json['total_usd'] as num?)?.toDouble() ?? 0.0,
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0.0,
      totalTrades: (json['total_trades'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      profitFactor: (json['profit_factor'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class EquityPointModel extends EquityPoint {
  const EquityPointModel({required super.time, required super.equity});

  factory EquityPointModel.fromJson(Map<String, dynamic> json) {
    return EquityPointModel(
      time: json['time']?.toString() ?? '',
      equity: (json['equity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
