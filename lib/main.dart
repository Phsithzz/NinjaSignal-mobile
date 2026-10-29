import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/navigation/presentation/pages/main_navigation_page.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/signals/presentation/bloc/signal_bloc.dart';
import 'features/trades/presentation/bloc/trade_bloc.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/notifications/presentation/bloc/notification_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const NinjaSignalApp());
}

class NinjaSignalApp extends StatelessWidget {
  const NinjaSignalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => di.sl<DashboardBloc>(),
        ),
        BlocProvider<SignalBloc>(
          create: (_) => di.sl<SignalBloc>(),
        ),
        BlocProvider<TradeBloc>(
          create: (_) => di.sl<TradeBloc>(),
        ),
        BlocProvider<NewsBloc>(
          create: (_) => di.sl<NewsBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => di.sl<SettingsBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => di.sl<NotificationBloc>()..add(LoadNotificationsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Ninja Signal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🥷', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 16),
                  CircularProgressIndicator(color: AppColors.primary),
                ],
              ),
            ),
          );
        }

        if (state is Authenticated) {
          return const MainNavigationPage();
        }

        return const LoginPage();
      },
    );
  }
}
