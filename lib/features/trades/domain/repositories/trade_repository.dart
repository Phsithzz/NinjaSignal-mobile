import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trade_entity.dart';

abstract class TradeRepository {
  Future<Either<Failure, List<Trade>>> getTrades({String? status});
  Future<Either<Failure, void>> closeTrade({
    required int tradeId,
    required double exitPrice,
    double? pnlUsd,
    String? note,
  });
}
