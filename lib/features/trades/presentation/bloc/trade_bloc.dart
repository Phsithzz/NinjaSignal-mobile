import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/trade_usecases.dart';
import 'trade_event.dart';
import 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final GetTradesUseCase getTradesUseCase;
  final CloseTradeUseCase closeTradeUseCase;

  TradeBloc({
    required this.getTradesUseCase,
    required this.closeTradeUseCase,
  }) : super(TradeInitial()) {
    on<LoadTradesEvent>(_onLoadTrades);
    on<ManualCloseTradeEvent>(_onManualCloseTrade);
  }

  Future<void> _onLoadTrades(LoadTradesEvent event, Emitter<TradeState> emit) async {
    emit(TradeLoading());
    final result = await getTradesUseCase(status: event.statusFilter);
    result.fold(
      (failure) => emit(TradeError(message: failure.message)),
      (trades) {
        final openTrades = trades.where((t) => t.isOpen).toList();
        final closedTrades = trades.where((t) => !t.isOpen).toList();
        emit(TradeLoaded(
          openTrades: openTrades,
          closedTrades: closedTrades,
        ));
      },
    );
  }

  Future<void> _onManualCloseTrade(ManualCloseTradeEvent event, Emitter<TradeState> emit) async {
    if (state is TradeLoaded) {
      final current = state as TradeLoaded;
      emit(current.copyWith(isSubmittingClose: true));

      final result = await closeTradeUseCase(
        tradeId: event.tradeId,
        exitPrice: event.exitPrice,
        pnlUsd: event.pnlUsd,
        note: event.note,
      );

      result.fold(
        (failure) {
          emit(current.copyWith(isSubmittingClose: false));
          emit(TradeError(message: failure.message));
        },
        (_) {
          add(const LoadTradesEvent());
        },
      );
    }
  }
}
