import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ninja_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notifications/presentation/widgets/notification_bell_icon.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name.split(' ').first : 'Trader';
    final isAdmin = authState is Authenticated && authState.user.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🥷 ', style: TextStyle(fontSize: 20)),
            Text('Hello, $userName'),
          ],
        ),
        actions: [
          const NotificationBellIcon(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () {
              context.read<DashboardBloc>().add(LoadDashboardEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.loss),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is DashboardLoaded) {
            final isRunning = state.systemStatus.systemEnabled;

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboardEvent());
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // System Status Banner
                  NinjaCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRunning ? AppColors.active : AppColors.paused,
                            boxShadow: [
                              BoxShadow(
                                color: (isRunning ? AppColors.active : AppColors.paused).withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRunning ? 'SYSTEM ACTIVE' : 'SYSTEM PAUSED',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: isRunning ? AppColors.active : AppColors.paused,
                                ),
                              ),
                              Text(
                                '${state.systemStatus.sessionLabel} · ${state.systemStatus.sessionWindow}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isAdmin)
                          SizedBox(
                            height: 32,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                side: BorderSide(
                                  color: isRunning ? AppColors.loss : AppColors.primary,
                                ),
                              ),
                              onPressed: state.isToggling
                                  ? null
                                  : () {
                                      context.read<DashboardBloc>().add(ToggleSystemStatusEvent());
                                    },
                              child: Text(
                                isRunning ? 'Pause' : 'Resume',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isRunning ? AppColors.loss : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Title: Live Quotes
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MARKET OVERVIEW',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'Auto-refreshed',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Horizontal Price Marquee / List
                  SizedBox(
                    height: 98,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.prices.entries.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, idx) {
                        final item = state.prices.entries.elementAt(idx);
                        final symbol = item.key;
                        final price = item.value;
                        final change = price.changePct;
                        final isUp = change != null && change >= 0;

                        return Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Formatters.prettySymbol(symbol),
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                  Icon(
                                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: isUp ? AppColors.profit : AppColors.loss,
                                    size: 20,
                                  ),
                                ],
                              ),
                              Text(
                                Formatters.formatPrice(price.mid),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Formatters.formatPct(change),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isUp ? AppColors.profit : AppColors.loss,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatRelativeTime(price.time),
                                    style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Daily Performance Stats Grid
                  const Text(
                    'TODAY\'S PERFORMANCE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Net P&L',
                          value: Formatters.formatMoney(state.dailyStats.totalUsd),
                          valueColor: state.dailyStats.totalUsd >= 0 ? AppColors.profit : AppColors.loss,
                          subtitle: '${state.dailyStats.totalTrades} trades today',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          title: 'Win Rate',
                          value: Formatters.formatPct(state.dailyStats.winRate * 100, withSign: false),
                          valueColor: AppColors.primary,
                          subtitle: '${state.dailyStats.wins}W / ${state.dailyStats.losses}L',
                          icon: Icons.pie_chart_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Equity Curve Chart
                  const Text(
                    'EQUITY CURVE (USD)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  NinjaCard(
                    padding: const EdgeInsets.fromLTRB(10, 18, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cumulative Performance',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 190,
                          child: state.equityPoints.isEmpty
                              ? const Center(
                                  child: Text('No equity data available yet', style: TextStyle(color: AppColors.textMuted)),
                                )
                              : LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) => const FlLine(
                                        color: AppColors.cardBorder,
                                        strokeWidth: 0.8,
                                      ),
                                    ),
                                    titlesData: const FlTitlesData(
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 42,
                                          interval: 100,
                                          getTitlesWidget: _leftTitles,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: state.equityPoints.asMap().entries.map((e) {
                                          return FlSpot(e.key.toDouble(), e.value.equity);
                                        }).toList(),
                                        isCurved: true,
                                        curveSmoothness: 0.35,
                                        color: AppColors.primary,
                                        barWidth: 2.5,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary.withValues(alpha: 0.25),
                                              AppColors.primary.withValues(alpha: 0.0),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<DashboardBloc>().add(LoadDashboardEvent()),
              child: const Text('Load Dashboard'),
            ),
          );
        },
      ),
    );
  }

  static Widget _leftTitles(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NinjaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Icon(icon, size: 16, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
