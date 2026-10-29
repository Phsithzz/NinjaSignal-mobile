import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/signal_entity.dart';
import '../../domain/usecases/get_signals_usecase.dart';
import 'signal_event.dart';
import 'signal_state.dart';

class SignalBloc extends Bloc<SignalEvent, SignalState> {
  final GetSignalsUseCase getSignalsUseCase;

  SignalBloc({required this.getSignalsUseCase}) : super(SignalInitial()) {
    on<LoadSignalsEvent>(_onLoadSignals);
    on<FilterSignalsEvent>(_onFilterSignals);
  }

  Future<void> _onLoadSignals(LoadSignalsEvent event, Emitter<SignalState> emit) async {
    emit(SignalLoading());
    final result = await getSignalsUseCase(status: event.statusFilter);
    result.fold(
      (failure) => emit(SignalError(message: failure.message)),
      (signals) {
        emit(SignalLoaded(
          allSignals: signals,
          filteredSignals: signals,
          activeStatusFilter: event.statusFilter,
        ));
      },
    );
  }

  void _onFilterSignals(FilterSignalsEvent event, Emitter<SignalState> emit) {
    if (state is SignalLoaded) {
      final current = state as SignalLoaded;
      List<TradeSignal> list = List.from(current.allSignals);

      if (event.status != null && event.status!.isNotEmpty && event.status != 'all') {
        list = list.where((s) => s.status.toLowerCase() == event.status!.toLowerCase()).toList();
      }

      if (event.instrument != null && event.instrument!.isNotEmpty && event.instrument != 'all') {
        list = list.where((s) => s.instrument.toLowerCase() == event.instrument!.toLowerCase()).toList();
      }

      emit(current.copyWith(
        filteredSignals: list,
        activeStatusFilter: event.status,
        activeInstrumentFilter: event.instrument,
      ));
    }
  }
}
