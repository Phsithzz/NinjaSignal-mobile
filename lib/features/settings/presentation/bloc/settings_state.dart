import 'package:equatable/equatable.dart';
import '../../domain/entities/config_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SystemConfig? config;
  final String baseUrl;
  final bool isMock;
  final String? message;

  const SettingsLoaded({
    this.config,
    required this.baseUrl,
    required this.isMock,
    this.message,
  });

  SettingsLoaded copyWith({
    SystemConfig? config,
    String? baseUrl,
    bool? isMock,
    String? message,
  }) {
    return SettingsLoaded(
      config: config ?? this.config,
      baseUrl: baseUrl ?? this.baseUrl,
      isMock: isMock ?? this.isMock,
      message: message,
    );
  }

  @override
  List<Object?> get props => [config, baseUrl, isMock, message];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
