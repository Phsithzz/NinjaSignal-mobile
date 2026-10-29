import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({required String email, required String password, required String name}) {
    return repository.register(email: email, password: password, name: name);
  }
}

class GetMeUseCase {
  final AuthRepository repository;
  GetMeUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.getMe();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
