import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/signal_entity.dart';

abstract class SignalRepository {
  Future<Either<Failure, List<TradeSignal>>> getSignals({String? status, int limit = 50});
}
