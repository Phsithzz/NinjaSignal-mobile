import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetSystemStatusUseCase getSystemStatusUseCase;
  final GetLivePricesUseCase getLivePricesUseCase;
  final GetDailyStatsUseCase getDailyStatsUseCase;
  final GetEquityCurveUseCase getEquityCurveUseCase;
  final ToggleSystemUseCase toggleSystemUseCase;

  DashboardBloc({
    required this.getSystemStatusUseCase,
    required this.getLivePricesUseCase,
    required this.getDailyStatsUseCase,
    required this.getEquityCurveUseCase,
    required this.toggleSystemUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshPricesEvent>(_onRefreshPrices);
    on<ToggleSystemStatusEvent>(_onToggleSystemStatus);
  }

  Future<void> _onLoadDashboard(LoadDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final statusRes = await getSystemStatusUseCase();
    final pricesRes = await getLivePricesUseCase();
    final statsRes = await getDailyStatsUseCase();
    final equityRes = await getEquityCurveUseCase();

    statusRes.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (status) {
        final prices = pricesRes.getOrElse(() => {});
        final dailyStats = statsRes.fold(
          (l) => null,
          (r) => r,
        );
        final equityPoints = equityRes.getOrElse(() => []);

        if (dailyStats != null) {
          emit(DashboardLoaded(
            systemStatus: status,
            prices: prices,
            dailyStats: dailyStats,
            equityPoints: equityPoints,
          ));
        } else {
          emit(const DashboardError(message: 'Failed to load stats'));
        }
      },
    );
  }

  Future<void> _onRefreshPrices(RefreshPricesEvent event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      final pricesRes = await getLivePricesUseCase();
      pricesRes.fold(
        (_) => null,
        (prices) => emit(current.copyWith(prices: prices)),
      );
    }
  }

  Future<void> _onToggleSystemStatus(ToggleSystemStatusEvent event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      emit(current.copyWith(isToggling: true));

      final result = await toggleSystemUseCase();
      result.fold(
        (failure) => emit(current.copyWith(isToggling: false)),
        (_) => add(LoadDashboardEvent()),
      );
    }
  }
}
