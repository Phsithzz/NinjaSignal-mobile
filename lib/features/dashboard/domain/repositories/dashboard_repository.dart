import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<Either<Failure, SystemStatus>> getSystemStatus();
  Future<Either<Failure, Map<String, LivePrice>>> getLivePrices();
  Future<Either<Failure, DailyStats>> getDailyStats();
  Future<Either<Failure, List<EquityPoint>>> getEquityCurve();
  Future<Either<Failure, bool>> toggleSystem();
}
