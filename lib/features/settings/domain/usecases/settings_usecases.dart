import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/config_entity.dart';
import '../repositories/settings_repository.dart';

class GetConfigUseCase {
  final SettingsRepository repository;
  GetConfigUseCase(this.repository);

  Future<Either<Failure, SystemConfig>> call() {
    return repository.getConfig();
  }
}

class UpdateConfigUseCase {
  final SettingsRepository repository;
  UpdateConfigUseCase(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> data) {
    return repository.updateConfig(data);
  }
}
