import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateBaseUrlEvent extends SettingsEvent {
  final String url;

  const UpdateBaseUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class ToggleMockModeEvent extends SettingsEvent {
  final bool enabled;

  const ToggleMockModeEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class UpdateConfigParamEvent extends SettingsEvent {
  final Map<String, dynamic> data;

  const UpdateConfigParamEvent(this.data);

  @override
  List<Object?> get props => [data];
}
