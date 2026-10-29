import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/ninja_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  void _showEditUrlDialog(String currentUrl) {
    final controller = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        title: const Text('Change Backend API URL', style: TextStyle(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'http://10.0.2.2:8000',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: [
                ActionChip(
                  label: const Text('10.0.2.2 (Emulator)', style: TextStyle(fontSize: 10)),
                  onPressed: () => controller.text = 'http://10.0.2.2:8000',
                ),
                ActionChip(
                  label: const Text('localhost:8000', style: TextStyle(fontSize: 10)),
                  onPressed: () => controller.text = 'http://localhost:8000',
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                context.read<SettingsBloc>().add(UpdateBaseUrlEvent(newUrl));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          final isMock = state is SettingsLoaded ? state.isMock : false;
          final baseUrl = state is SettingsLoaded ? state.baseUrl : '';
          final config = state is SettingsLoaded ? state.config : null;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // User Profile Card
              if (user != null)
                NinjaCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cardBorder,
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: AppColors.primary, size: 26),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                user.role.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Environment & Connectivity Section
              const Text(
                'SERVER & CONNECTIVITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              NinjaCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Base URL tile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Backend Server URL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(
                                baseUrl,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                          onPressed: () => _showEditUrlDialog(baseUrl),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Mock Mode Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mock Data Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text(
                              'Run offline without running the backend',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Switch(
                          value: isMock,
                          activeThumbColor: AppColors.primary,
                          onChanged: (enabled) {
                            context.read<SettingsBloc>().add(ToggleMockModeEvent(enabled));
                            context.read<AuthBloc>().add(SwitchModeEvent(isMock: enabled));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notifications Test Section
              const Text(
                'PUSH NOTIFICATIONS & ALERTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              NinjaCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications_active_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Instant Trading Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pushes live heads-up banners on your phone when new Scalping Signals trigger or trades hit TP/SL.',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardBorder,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 16, color: AppColors.primary),
                      label: const Text('Send Test Push Notification', style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        context.read<NotificationBloc>().add(
                              const PushCustomAlertEvent(
                                title: '🥷 NINJA SIGNAL ALERT',
                                message: 'Test Notification: BUY XAU/USD @ 2685.50 (SL: 2675.00, TP: 2700.00)',
                                type: 'signal',
                              ),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test notification sent! Check your notification bar.'),
                            backgroundColor: AppColors.cardElevated,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // System Risk & Rules Section
              const Text(
                'QUANT RISK MANAGEMENT (SPEC)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              NinjaCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _ConfigRow(
                      label: 'Risk per Trade',
                      value: '\$${config?.riskPerTradeUsd.toStringAsFixed(2) ?? "3.00"}',
                      subtext: 'Calculates dynamic lot size via ATR',
                    ),
                    const Divider(height: 16),
                    _ConfigRow(
                      label: 'Max Loss Hard Cap',
                      value: '\$${config?.maxLossPerTradeUsd.toStringAsFixed(2) ?? "5.00"}',
                      subtext: 'Hard ceiling per trade loss',
                    ),
                    const Divider(height: 16),
                    _ConfigRow(
                      label: 'Exit Mode',
                      value: config?.exitMode.toUpperCase() ?? 'SCALE_OUT',
                      subtext: '+1R → Breakeven → Trail 3x ATR',
                    ),
                    const Divider(height: 16),
                    _ConfigRow(
                      label: 'Target Source',
                      value: config?.targetSource.toUpperCase() ?? 'SWING',
                      subtext: 'Nearest swing high/low (> 0.5R)',
                    ),
                    const Divider(height: 16),
                    _ConfigRow(
                      label: 'Consecutive Loss Pause',
                      value: '${config?.maxConsecutiveLosses ?? 3} losses',
                      subtext: 'Pauses bot automatically upon 3 consecutive losses',
                    ),
                    const Divider(height: 16),
                    _ConfigRow(
                      label: 'Max Drawdown Halt',
                      value: '${config?.maxDrawdownPct ?? 10.0}%',
                      subtext: 'Halts system if portfolio drops 10%',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Sign Out Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.loss,
                  side: BorderSide(color: AppColors.loss.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;

  const _ConfigRow({
    required this.label,
    required this.value,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(subtext, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
