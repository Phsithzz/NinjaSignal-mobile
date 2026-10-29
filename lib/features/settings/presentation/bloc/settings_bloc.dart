import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/settings_usecases.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetConfigUseCase getConfigUseCase;
  final UpdateConfigUseCase updateConfigUseCase;
  final SettingsRepository settingsRepository;

  SettingsBloc({
    required this.getConfigUseCase,
    required this.updateConfigUseCase,
    required this.settingsRepository,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateBaseUrlEvent>(_onUpdateBaseUrl);
    on<ToggleMockModeEvent>(_onToggleMockMode);
    on<UpdateConfigParamEvent>(_onUpdateConfigParam);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final baseUrl = settingsRepository.getBaseUrl();
    final isMock = settingsRepository.isMockMode();

    final configRes = await getConfigUseCase();
    configRes.fold(
      (failure) => emit(SettingsLoaded(
        config: null,
        baseUrl: baseUrl,
        isMock: isMock,
        message: 'Could not load remote config: ${failure.message}',
      )),
      (config) => emit(SettingsLoaded(
        config: config,
        baseUrl: baseUrl,
        isMock: isMock,
      )),
    );
  }

  Future<void> _onUpdateBaseUrl(UpdateBaseUrlEvent event, Emitter<SettingsState> emit) async {
    await settingsRepository.setBaseUrl(event.url);
    add(LoadSettingsEvent());
  }

  Future<void> _onToggleMockMode(ToggleMockModeEvent event, Emitter<SettingsState> emit) async {
    await settingsRepository.setMockMode(event.enabled);
    add(LoadSettingsEvent());
  }

  Future<void> _onUpdateConfigParam(UpdateConfigParamEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(SettingsLoading());

      final res = await updateConfigUseCase(event.data);
      res.fold(
        (failure) => emit(current.copyWith(message: failure.message)),
        (_) => add(LoadSettingsEvent()),
      );
    }
  }
}
