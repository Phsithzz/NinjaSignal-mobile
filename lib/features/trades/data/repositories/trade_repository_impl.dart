import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/trade_entity.dart';
import '../../domain/repositories/trade_repository.dart';
import '../datasources/trade_remote_data_source.dart';

class TradeRepositoryImpl implements TradeRepository {
  final TradeRemoteDataSource remoteDataSource;

  TradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Trade>>> getTrades({String? status}) async {
    try {
      final trades = await remoteDataSource.getTrades(status: status);
      return Right(trades);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeTrade({
    required int tradeId,
    required double exitPrice,
    double? pnlUsd,
    String? note,
  }) async {
    try {
      await remoteDataSource.closeTrade(
        tradeId: tradeId,
        exitPrice: exitPrice,
        pnlUsd: pnlUsd,
        note: note,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
