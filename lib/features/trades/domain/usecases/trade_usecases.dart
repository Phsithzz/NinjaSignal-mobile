import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trade_entity.dart';
import '../repositories/trade_repository.dart';

class GetTradesUseCase {
  final TradeRepository repository;
  GetTradesUseCase(this.repository);

  Future<Either<Failure, List<Trade>>> call({String? status}) {
    return repository.getTrades(status: status);
  }
}

class CloseTradeUseCase {
  final TradeRepository repository;
  CloseTradeUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int tradeId,
    required double exitPrice,
    double? pnlUsd,
    String? note,
  }) {
    return repository.closeTrade(
      tradeId: tradeId,
      exitPrice: exitPrice,
      pnlUsd: pnlUsd,
      note: note,
    );
  }
}
