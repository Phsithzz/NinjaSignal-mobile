import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String email, required String password});
  Future<Either<Failure, User>> register({required String email, required String password, required String name});
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, void>> logout();
  Future<bool> hasToken();
}
