import 'package:equatable/equatable.dart';

class SystemStatus extends Equatable {
  final bool systemEnabled;
  final String sessionLabel;
  final String sessionWindow;
  final String priceFeed;
  final List<String> activeInstruments;

  const SystemStatus({
    required this.systemEnabled,
    required this.sessionLabel,
    required this.sessionWindow,
    required this.priceFeed,
    required this.activeInstruments,
  });

  @override
  List<Object?> get props => [
        systemEnabled,
        sessionLabel,
        sessionWindow,
        priceFeed,
        activeInstruments,
      ];
}

class LivePrice extends Equatable {
  final String symbol;
  final double mid;
  final double? bid;
  final double? ask;
  final double? changePct;
  final String? time;

  const LivePrice({
    required this.symbol,
    required this.mid,
    this.bid,
    this.ask,
    this.changePct,
    this.time,
  });

  @override
  List<Object?> get props => [symbol, mid, bid, ask, changePct, time];
}

class DailyStats extends Equatable {
  final double totalUsd;
  final double winRate;
  final int totalTrades;
  final int wins;
  final int losses;
  final double profitFactor;

  const DailyStats({
    required this.totalUsd,
    required this.winRate,
    required this.totalTrades,
    required this.wins,
    required this.losses,
    required this.profitFactor,
  });

  @override
  List<Object?> get props => [
        totalUsd,
        winRate,
        totalTrades,
        wins,
        losses,
        profitFactor,
      ];
}

class EquityPoint extends Equatable {
  final String time;
  final double equity;

  const EquityPoint({required this.time, required this.equity});

  @override
  List<Object?> get props => [time, equity];
}
