import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_entities.dart';
import '../repositories/dashboard_repository.dart';

class GetSystemStatusUseCase {
  final DashboardRepository repository;
  GetSystemStatusUseCase(this.repository);

  Future<Either<Failure, SystemStatus>> call() {
    return repository.getSystemStatus();
  }
}

class GetLivePricesUseCase {
  final DashboardRepository repository;
  GetLivePricesUseCase(this.repository);

  Future<Either<Failure, Map<String, LivePrice>>> call() {
    return repository.getLivePrices();
  }
}

class GetDailyStatsUseCase {
  final DashboardRepository repository;
  GetDailyStatsUseCase(this.repository);

  Future<Either<Failure, DailyStats>> call() {
    return repository.getDailyStats();
  }
}

class GetEquityCurveUseCase {
  final DashboardRepository repository;
  GetEquityCurveUseCase(this.repository);

  Future<Either<Failure, List<EquityPoint>>> call() {
    return repository.getEquityCurve();
  }
}

class ToggleSystemUseCase {
  final DashboardRepository repository;
  ToggleSystemUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.toggleSystem();
  }
}
