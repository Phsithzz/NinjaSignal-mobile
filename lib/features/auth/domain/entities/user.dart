import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String role; // 'admin', 'subscriber', 'guest'
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
  });

  bool get isAdmin => role == 'admin';
  bool get isSubscriber => role == 'subscriber' || role == 'admin';
  bool get isGuest => role == 'guest';

  @override
  List<Object?> get props => [id, email, name, role, isActive];
}
