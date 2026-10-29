import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/config_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SystemConfig>> getConfig();
  Future<Either<Failure, void>> updateConfig(Map<String, dynamic> data);
  String getBaseUrl();
  Future<void> setBaseUrl(String url);
  bool isMockMode();
  Future<void> setMockMode(bool enabled);
}
