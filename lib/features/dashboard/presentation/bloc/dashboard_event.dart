import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {}

class RefreshPricesEvent extends DashboardEvent {}

class ToggleSystemStatusEvent extends DashboardEvent {}
