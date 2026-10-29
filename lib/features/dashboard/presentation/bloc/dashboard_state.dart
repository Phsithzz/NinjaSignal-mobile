import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entities.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final SystemStatus systemStatus;
  final Map<String, LivePrice> prices;
  final DailyStats dailyStats;
  final List<EquityPoint> equityPoints;
  final bool isToggling;

  const DashboardLoaded({
    required this.systemStatus,
    required this.prices,
    required this.dailyStats,
    required this.equityPoints,
    this.isToggling = false,
  });

  DashboardLoaded copyWith({
    SystemStatus? systemStatus,
    Map<String, LivePrice>? prices,
    DailyStats? dailyStats,
    List<EquityPoint>? equityPoints,
    bool? isToggling,
  }) {
    return DashboardLoaded(
      systemStatus: systemStatus ?? this.systemStatus,
      prices: prices ?? this.prices,
      dailyStats: dailyStats ?? this.dailyStats,
      equityPoints: equityPoints ?? this.equityPoints,
      isToggling: isToggling ?? this.isToggling,
    );
  }

  @override
  List<Object?> get props => [
        systemStatus,
        prices,
        dailyStats,
        equityPoints,
        isToggling,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
