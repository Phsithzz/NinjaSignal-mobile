import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badge_widget.dart';
import '../../../../core/widgets/ninja_card.dart';
import '../bloc/signal_bloc.dart';
import '../bloc/signal_event.dart';
import '../bloc/signal_state.dart';
import '../../domain/entities/signal_entity.dart';
import '../../../notifications/presentation/widgets/notification_bell_icon.dart';

class SignalsPage extends StatefulWidget {
  const SignalsPage({super.key});

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage> {
  String _selectedTab = 'all';

  @override
  void initState() {
    super.initState();
    context.read<SignalBloc>().add(const LoadSignalsEvent());
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedTab = filter;
    });
    context.read<SignalBloc>().add(FilterSignalsEvent(
          status: filter == 'all' ? null : filter,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trading Signals'),
        actions: [
          const NotificationBellIcon(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () {
              context.read<SignalBloc>().add(LoadSignalsEvent(
                    statusFilter: _selectedTab == 'all' ? null : _selectedTab,
                  ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All Signals', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Active Only', 'active'),
                const SizedBox(width: 8),
                _buildFilterChip('Closed', 'closed'),
              ],
            ),
          ),
          const Divider(height: 1),

          // Signals List
          Expanded(
            child: BlocConsumer<SignalBloc, SignalState>(
              listener: (context, state) {
                if (state is SignalError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: AppColors.loss),
                  );
                }
              },
              builder: (context, state) {
                if (state is SignalLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (state is SignalLoaded) {
                  final signals = state.filteredSignals;

                  if (signals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.radar_rounded, size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          const Text(
                            'No signals found',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Scanning markets for confluence setups...',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    onRefresh: () async {
                      context.read<SignalBloc>().add(LoadSignalsEvent(
                            statusFilter: _selectedTab == 'all' ? null : _selectedTab,
                          ));
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: signals.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        return _SignalCard(signal: signals[idx]);
                      },
                    ),
                  );
                }

                return Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<SignalBloc>().add(const LoadSignalsEvent()),
                    child: const Text('Load Signals'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedTab == value;
    return InkWell(
      onTap: () => _onFilterChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  final TradeSignal signal;

  const _SignalCard({required this.signal});

  @override
  Widget build(BuildContext context) {
    return NinjaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Pair, Direction, Confidence & Time
          Row(
            children: [
              Text(
                Formatters.prettySymbol(signal.instrument),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              DirBadge(direction: signal.direction),
              const SizedBox(width: 8),
              ConfidenceBadge(confidence: signal.confidence),
              const Spacer(),
              Text(
                Formatters.formatRelativeTime(signal.time),
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Price levels grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceCol(
                  label: 'ENTRY',
                  value: Formatters.formatPrice(signal.entry),
                  valueColor: AppColors.textPrimary,
                ),
                _PriceCol(
                  label: 'STOP LOSS',
                  value: Formatters.formatPrice(signal.sl),
                  valueColor: AppColors.loss,
                ),
                _PriceCol(
                  label: 'TAKE PROFIT',
                  value: Formatters.formatPrice(signal.tp),
                  valueColor: AppColors.profit,
                ),
                _PriceCol(
                  label: 'R:R',
                  value: '1:${signal.rr.toStringAsFixed(1)}',
                  valueColor: AppColors.gold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Strategy Confluence Rules Triggered Chips
          if (signal.rulesTriggered.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: signal.rulesTriggered.map((rule) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    rule,
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _PriceCol extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _PriceCol({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textMuted),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: valueColor),
        ),
      ],
    );
  }
}
