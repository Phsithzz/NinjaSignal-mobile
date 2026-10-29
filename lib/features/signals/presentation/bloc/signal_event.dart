import 'package:equatable/equatable.dart';

abstract class SignalEvent extends Equatable {
  const SignalEvent();

  @override
  List<Object?> get props => [];
}

class LoadSignalsEvent extends SignalEvent {
  final String? statusFilter;

  const LoadSignalsEvent({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

class FilterSignalsEvent extends SignalEvent {
  final String? instrument;
  final String? status;

  const FilterSignalsEvent({this.instrument, this.status});

  @override
  List<Object?> get props => [instrument, status];
}
