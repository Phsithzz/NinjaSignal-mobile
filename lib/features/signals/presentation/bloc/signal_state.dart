import 'package:equatable/equatable.dart';
import '../../domain/entities/signal_entity.dart';

abstract class SignalState extends Equatable {
  const SignalState();

  @override
  List<Object?> get props => [];
}

class SignalInitial extends SignalState {}

class SignalLoading extends SignalState {}

class SignalLoaded extends SignalState {
  final List<TradeSignal> allSignals;
  final List<TradeSignal> filteredSignals;
  final String? activeStatusFilter;
  final String? activeInstrumentFilter;

  const SignalLoaded({
    required this.allSignals,
    required this.filteredSignals,
    this.activeStatusFilter,
    this.activeInstrumentFilter,
  });

  SignalLoaded copyWith({
    List<TradeSignal>? allSignals,
    List<TradeSignal>? filteredSignals,
    String? activeStatusFilter,
    String? activeInstrumentFilter,
  }) {
    return SignalLoaded(
      allSignals: allSignals ?? this.allSignals,
      filteredSignals: filteredSignals ?? this.filteredSignals,
      activeStatusFilter: activeStatusFilter ?? this.activeStatusFilter,
      activeInstrumentFilter: activeInstrumentFilter ?? this.activeInstrumentFilter,
    );
  }

  @override
  List<Object?> get props => [
        allSignals,
        filteredSignals,
        activeStatusFilter,
        activeInstrumentFilter,
      ];
}

class SignalError extends SignalState {
  final String message;

  const SignalError({required this.message});

  @override
  List<Object?> get props => [message];
}
