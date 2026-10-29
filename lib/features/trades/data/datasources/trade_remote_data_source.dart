import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/trade_model.dart';

abstract class TradeRemoteDataSource {
  Future<List<TradeModel>> getTrades({String? status});
  Future<void> closeTrade({
    required int tradeId,
    required double exitPrice,
    double? pnlUsd,
    String? note,
  });
}

class TradeRemoteDataSourceImpl implements TradeRemoteDataSource {
  final ApiClient client;

  TradeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TradeModel>> getTrades({String? status}) async {
    final params = <String, dynamic>{};
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }

    final response = await client.get(ApiConstants.trades, queryParameters: params);
    if (response is List) {
      return response
          .map((item) => TradeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<void> closeTrade({
    required int tradeId,
    required double exitPrice,
    double? pnlUsd,
    String? note,
  }) async {
    final data = <String, dynamic>{
      'exit_price': exitPrice,
    };
    if (pnlUsd != null) data['pnl_usd'] = pnlUsd;
    if (note != null && note.isNotEmpty) data['note'] = note;

    await client.post(
      ApiConstants.closeTrade(tradeId),
      data: data,
    );
  }
}
