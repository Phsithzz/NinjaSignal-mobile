import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/config_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, SystemConfig>> getConfig() async {
    try {
      final config = await remoteDataSource.getConfig();
      return Right(config);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateConfig(Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateConfig(data);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  String getBaseUrl() {
    return apiClient.getBaseUrl();
  }

  @override
  Future<void> setBaseUrl(String url) async {
    await apiClient.setBaseUrl(url);
  }

  @override
  bool isMockMode() {
    return apiClient.isMockMode();
  }

  @override
  Future<void> setMockMode(bool enabled) async {
    await apiClient.setMockMode(enabled);
  }
}
