import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/dashboard_usecases.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Signals
import '../../features/signals/data/datasources/signal_remote_data_source.dart';
import '../../features/signals/data/repositories/signal_repository_impl.dart';
import '../../features/signals/domain/repositories/signal_repository.dart';
import '../../features/signals/domain/usecases/get_signals_usecase.dart';
import '../../features/signals/presentation/bloc/signal_bloc.dart';

// Trades
import '../../features/trades/data/datasources/trade_remote_data_source.dart';
import '../../features/trades/data/repositories/trade_repository_impl.dart';
import '../../features/trades/domain/repositories/trade_repository.dart';
import '../../features/trades/domain/usecases/trade_usecases.dart';
import '../../features/trades/presentation/bloc/trade_bloc.dart';

// News
import '../../features/news/data/datasources/news_remote_data_source.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_news_usecase.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';

// Settings
import '../../features/settings/data/datasources/settings_remote_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

// Notifications
import '../services/notification_service.dart';
import '../../features/notifications/data/datasources/notification_local_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/notification_usecases.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //! External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  //! Core
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), prefs: sl()),
  );

  //! Features - Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), apiClient: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getMeUseCase: sl(),
      logoutUseCase: sl(),
      apiClient: sl(),
    ),
  );

  //! Features - Dashboard
  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetSystemStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetLivePricesUseCase(sl()));
  sl.registerLazySingleton(() => GetDailyStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetEquityCurveUseCase(sl()));
  sl.registerLazySingleton(() => ToggleSystemUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => DashboardBloc(
      getSystemStatusUseCase: sl(),
      getLivePricesUseCase: sl(),
      getDailyStatsUseCase: sl(),
      getEquityCurveUseCase: sl(),
      toggleSystemUseCase: sl(),
    ),
  );

  //! Features - Signals
  // Data sources
  sl.registerLazySingleton<SignalRemoteDataSource>(
    () => SignalRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<SignalRepository>(
    () => SignalRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetSignalsUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => SignalBloc(getSignalsUseCase: sl()),
  );

  //! Features - Trades
  // Data sources
  sl.registerLazySingleton<TradeRemoteDataSource>(
    () => TradeRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<TradeRepository>(
    () => TradeRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetTradesUseCase(sl()));
  sl.registerLazySingleton(() => CloseTradeUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => TradeBloc(
      getTradesUseCase: sl(),
      closeTradeUseCase: sl(),
    ),
  );

  //! Features - News
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => NewsBloc(getNewsUseCase: sl()),
  );

  //! Features - Settings
  // Data sources
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(remoteDataSource: sl(), apiClient: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetConfigUseCase(sl()));
  sl.registerLazySingleton(() => UpdateConfigUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      getConfigUseCase: sl(),
      updateConfigUseCase: sl(),
      settingsRepository: sl(),
    ),
  );

  //! Features - Notifications
  final notifService = NotificationService();
  await notifService.init();
  sl.registerLazySingleton<NotificationService>(() => notifService);

  // Data sources
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(prefs: sl()),
  );
  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(localDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => SaveNotificationUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerLazySingleton(() => ClearNotificationsUseCase(sl()));
  // Bloc
  sl.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: sl(),
      saveNotificationUseCase: sl(),
      markAllNotificationsReadUseCase: sl(),
      clearNotificationsUseCase: sl(),
      notificationService: sl(),
    ),
  );
}
