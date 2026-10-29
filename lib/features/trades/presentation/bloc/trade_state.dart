import 'package:equatable/equatable.dart';
import '../../domain/entities/trade_entity.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object?> get props => [];
}

class TradeInitial extends TradeState {}

class TradeLoading extends TradeState {}

class TradeLoaded extends TradeState {
  final List<Trade> openTrades;
  final List<Trade> closedTrades;
  final bool isSubmittingClose;
  final String? actionSuccessMessage;

  const TradeLoaded({
    required this.openTrades,
    required this.closedTrades,
    this.isSubmittingClose = false,
    this.actionSuccessMessage,
  });

  TradeLoaded copyWith({
    List<Trade>? openTrades,
    List<Trade>? closedTrades,
    bool? isSubmittingClose,
    String? actionSuccessMessage,
  }) {
    return TradeLoaded(
      openTrades: openTrades ?? this.openTrades,
      closedTrades: closedTrades ?? this.closedTrades,
      isSubmittingClose: isSubmittingClose ?? this.isSubmittingClose,
      actionSuccessMessage: actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        openTrades,
        closedTrades,
        isSubmittingClose,
        actionSuccessMessage,
      ];
}

class TradeError extends TradeState {
  final String message;

  const TradeError({required this.message});

  @override
  List<Object?> get props => [message];
}
