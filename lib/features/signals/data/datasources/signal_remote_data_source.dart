import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/signal_model.dart';

abstract class SignalRemoteDataSource {
  Future<List<TradeSignalModel>> getSignals({String? status, int limit = 50});
}

class SignalRemoteDataSourceImpl implements SignalRemoteDataSource {
  final ApiClient client;

  SignalRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TradeSignalModel>> getSignals({String? status, int limit = 50}) async {
    final params = <String, dynamic>{'limit': limit};
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }

    final response = await client.get(ApiConstants.signals, queryParameters: params);
    if (response is List) {
      return response
          .map((item) => TradeSignalModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
