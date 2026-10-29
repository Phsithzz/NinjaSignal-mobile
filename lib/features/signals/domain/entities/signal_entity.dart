import 'package:equatable/equatable.dart';

class TradeSignal extends Equatable {
  final int id;
  final String instrument;
  final String direction; // 'buy' or 'sell'
  final double entry;
  final double sl;
  final double tp;
  final double rr;
  final String confidence; // 'high', 'medium', 'low'
  final String status;     // 'active', 'closed'
  final List<String> rulesTriggered;
  final String time;

  const TradeSignal({
    required this.id,
    required this.instrument,
    required this.direction,
    required this.entry,
    required this.sl,
    required this.tp,
    required this.rr,
    required this.confidence,
    required this.status,
    required this.rulesTriggered,
    required this.time,
  });

  bool get isBuy => direction.toLowerCase() == 'buy';
  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
        id,
        instrument,
        direction,
        entry,
        sl,
        tp,
        rr,
        confidence,
        status,
        rulesTriggered,
        time,
      ];
}
