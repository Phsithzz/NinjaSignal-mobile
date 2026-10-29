import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetMeUseCase getMeUseCase;
  final LogoutUseCase logoutUseCase;
  final ApiClient apiClient;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getMeUseCase,
    required this.logoutUseCase,
    required this.apiClient,
  }) : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<SwitchModeEvent>(_onSwitchMode);
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final isMock = apiClient.isMockMode();
    final token = apiClient.getToken();

    if (token == null || token.isEmpty) {
      emit(Unauthenticated(isMock: isMock));
      return;
    }

    emit(AuthLoading());
    final result = await getMeUseCase();
    result.fold(
      (failure) {
        apiClient.clearToken();
        emit(Unauthenticated(message: failure.message, isMock: isMock));
      },
      (user) => emit(Authenticated(user: user, isMock: isMock)),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isMock = apiClient.isMockMode();
    final result = await loginUseCase(email: event.email, password: event.password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user, isMock: isMock)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => add(LoginEvent(email: event.email, password: event.password)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(Unauthenticated(isMock: apiClient.isMockMode()));
  }

  Future<void> _onSwitchMode(SwitchModeEvent event, Emitter<AuthState> emit) async {
    await apiClient.setMockMode(event.isMock);
    add(CheckAuthEvent());
  }
}
