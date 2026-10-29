import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_models.dart';

abstract class DashboardRemoteDataSource {
  Future<SystemStatusModel> getSystemStatus();
  Future<Map<String, LivePriceModel>> getLivePrices();
  Future<DailyStatsModel> getDailyStats();
  Future<List<EquityPointModel>> getEquityCurve();
  Future<bool> toggleSystem();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<SystemStatusModel> getSystemStatus() async {
    final response = await client.get(ApiConstants.status);
    return SystemStatusModel.fromJson(response);
  }

  @override
  Future<Map<String, LivePriceModel>> getLivePrices() async {
    final response = await client.get(ApiConstants.prices);
    final result = <String, LivePriceModel>{};
    if (response is Map) {
      response.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          result[key.toString()] = LivePriceModel.fromJson(key.toString(), value);
        }
      });
    }
    return result;
  }

  @override
  Future<DailyStatsModel> getDailyStats() async {
    final response = await client.get(ApiConstants.dailyStats);
    return DailyStatsModel.fromJson(response);
  }

  @override
  Future<List<EquityPointModel>> getEquityCurve() async {
    final response = await client.get(ApiConstants.equityStats);
    final points = (response['points'] as List<dynamic>?)
            ?.map((e) => EquityPointModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return points;
  }

  @override
  Future<bool> toggleSystem() async {
    final response = await client.post(ApiConstants.systemToggle);
    return response['system_enabled'] ?? false;
  }
}
