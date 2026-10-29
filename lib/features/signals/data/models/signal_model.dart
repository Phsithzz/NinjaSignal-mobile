import '../../domain/entities/signal_entity.dart';

class TradeSignalModel extends TradeSignal {
  const TradeSignalModel({
    required super.id,
    required super.instrument,
    required super.direction,
    required super.entry,
    required super.sl,
    required super.tp,
    required super.rr,
    required super.confidence,
    required super.status,
    required super.rulesTriggered,
    required super.time,
  });

  factory TradeSignalModel.fromJson(Map<String, dynamic> json) {
    final rules = (json['rules_triggered'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return TradeSignalModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      instrument: json['instrument'] ?? 'XAU_USD',
      direction: json['direction']?.toString().toLowerCase() ?? 'buy',
      entry: (json['entry'] as num?)?.toDouble() ?? 0.0,
      sl: (json['sl'] as num?)?.toDouble() ?? 0.0,
      tp: (json['tp'] as num?)?.toDouble() ?? 0.0,
      rr: (json['rr'] as num?)?.toDouble() ?? 2.0,
      confidence: json['confidence']?.toString().toLowerCase() ?? 'medium',
      status: json['status']?.toString().toLowerCase() ?? 'active',
      rulesTriggered: rules,
      time: json['time']?.toString() ?? '',
    );
  }
}
