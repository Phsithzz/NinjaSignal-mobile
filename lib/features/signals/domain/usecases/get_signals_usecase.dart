import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/signal_entity.dart';
import '../repositories/signal_repository.dart';

class GetSignalsUseCase {
  final SignalRepository repository;
  GetSignalsUseCase(this.repository);

  Future<Either<Failure, List<TradeSignal>>> call({String? status, int limit = 50}) {
    return repository.getSignals(status: status, limit: limit);
  }
}
