import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed. Please check your internet.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please login again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error occurred.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
