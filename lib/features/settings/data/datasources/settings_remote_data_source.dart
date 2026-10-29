import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/config_model.dart';

abstract class SettingsRemoteDataSource {
  Future<SystemConfigModel> getConfig();
  Future<void> updateConfig(Map<String, dynamic> data);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient client;

  SettingsRemoteDataSourceImpl({required this.client});

  @override
  Future<SystemConfigModel> getConfig() async {
    final response = await client.get(ApiConstants.config);
    return SystemConfigModel.fromJson(response);
  }

  @override
  Future<void> updateConfig(Map<String, dynamic> data) async {
    await client.post(ApiConstants.config, data: data);
  }
}
