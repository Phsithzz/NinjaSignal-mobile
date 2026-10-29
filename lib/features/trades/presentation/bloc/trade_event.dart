import 'package:equatable/equatable.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTradesEvent extends TradeEvent {
  final String? statusFilter;

  const LoadTradesEvent({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

class ManualCloseTradeEvent extends TradeEvent {
  final int tradeId;
  final double exitPrice;
  final double? pnlUsd;
  final String? note;

  const ManualCloseTradeEvent({
    required this.tradeId,
    required this.exitPrice,
    this.pnlUsd,
    this.note,
  });

  @override
  List<Object?> get props => [tradeId, exitPrice, pnlUsd, note];
}
