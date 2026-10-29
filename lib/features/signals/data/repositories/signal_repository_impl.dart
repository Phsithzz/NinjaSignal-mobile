import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/signal_entity.dart';
import '../../domain/repositories/signal_repository.dart';
import '../datasources/signal_remote_data_source.dart';

class SignalRepositoryImpl implements SignalRepository {
  final SignalRemoteDataSource remoteDataSource;

  SignalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TradeSignal>>> getSignals({String? status, int limit = 50}) async {
    try {
      final signals = await remoteDataSource.getSignals(status: status, limit: limit);
      return Right(signals);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
