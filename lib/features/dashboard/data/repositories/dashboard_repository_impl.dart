import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/dashboard_entities.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SystemStatus>> getSystemStatus() async {
    try {
      final status = await remoteDataSource.getSystemStatus();
      return Right(status);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, LivePrice>>> getLivePrices() async {
    try {
      final prices = await remoteDataSource.getLivePrices();
      return Right(prices);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyStats>> getDailyStats() async {
    try {
      final stats = await remoteDataSource.getDailyStats();
      return Right(stats);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EquityPoint>>> getEquityCurve() async {
    try {
      final points = await remoteDataSource.getEquityCurve();
      return Right(points);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleSystem() async {
    try {
      final enabled = await remoteDataSource.toggleSystem();
      return Right(enabled);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
