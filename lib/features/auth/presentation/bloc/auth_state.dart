import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final bool isMock;

  const Authenticated({required this.user, this.isMock = false});

  @override
  List<Object?> get props => [user, isMock];
}

class Unauthenticated extends AuthState {
  final String? message;
  final bool isMock;

  const Unauthenticated({this.message, this.isMock = false});

  @override
  List<Object?> get props => [message, isMock];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
