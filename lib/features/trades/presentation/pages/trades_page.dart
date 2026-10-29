import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badge_widget.dart';
import '../../../../core/widgets/ninja_card.dart';
import '../bloc/trade_bloc.dart';
import '../bloc/trade_event.dart';
import '../bloc/trade_state.dart';
import '../../domain/entities/trade_entity.dart';
import '../widgets/close_trade_dialog.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({super.key});

  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<TradeBloc>().add(const LoadTradesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCloseDialog(Trade trade) {
    showDialog(
      context: context,
      builder: (ctx) => CloseTradeDialog(
        trade: trade,
        onConfirm: (exitPrice, pnlUsd, note) {
          context.read<TradeBloc>().add(
                ManualCloseTradeEvent(
                  tradeId: trade.id,
                  exitPrice: exitPrice,
                  pnlUsd: pnlUsd,
                  note: note,
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Positions & Trades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () {
              context.read<TradeBloc>().add(const LoadTradesEvent());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Open Positions'),
            Tab(text: 'Trade History'),
          ],
        ),
      ),
      body: BlocConsumer<TradeBloc, TradeState>(
        listener: (context, state) {
          if (state is TradeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.loss),
            );
          }
        },
        builder: (context, state) {
          if (state is TradeLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is TradeLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildOpenTradesList(state.openTrades),
                _buildClosedTradesList(state.closedTrades),
              ],
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<TradeBloc>().add(const LoadTradesEvent()),
              child: const Text('Load Trades'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOpenTradesList(List<Trade> trades) {
    if (trades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 50, color: AppColors.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text(
              'No active positions',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'New positions will appear when signals trigger',
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
        context.read<TradeBloc>().add(const LoadTradesEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: trades.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final trade = trades[idx];
          final isProfit = trade.isProfit;

          return NinjaCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      Formatters.prettySymbol(trade.instrument),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 8),
                    DirBadge(direction: trade.direction),
                    const SizedBox(width: 8),
                    StatusBadge(status: trade.status),
                    const Spacer(),
                    Text(
                      '${trade.lotSize} lot',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // P&L and Price Stats
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isProfit ? AppColors.profitBg : AppColors.lossBg),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (isProfit ? AppColors.profit : AppColors.loss).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('UNREALIZED P&L', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatMoney(trade.pnlUsd),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isProfit ? AppColors.profit : AppColors.loss,
                              ),
                            ),
                            Text(
                              '${trade.pnlR >= 0 ? "+" : ""}${trade.pnlR.toStringAsFixed(2)}R',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isProfit ? AppColors.profit : AppColors.loss,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TradeRow(label: 'Entry Price', value: Formatters.formatPrice(trade.entryPrice)),
                          const SizedBox(height: 4),
                          _TradeRow(label: 'Current Price', value: Formatters.formatPrice(trade.currentPrice)),
                          const SizedBox(height: 4),
                          _TradeRow(label: 'Stop Loss', value: Formatters.formatPrice(trade.sl)),
                          const SizedBox(height: 4),
                          _TradeRow(label: 'Take Profit', value: Formatters.formatPrice(trade.tp)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Footer: Exit rule + "I closed this" button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Exit: ${trade.exitMode}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      icon: const Icon(Icons.done_all_rounded, size: 14, color: AppColors.primary),
                      label: const Text('I closed this', style: TextStyle(fontSize: 11)),
                      onPressed: () => _showCloseDialog(trade),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClosedTradesList(List<Trade> trades) {
    if (trades.isEmpty) {
      return const Center(
        child: Text('No trade history recorded yet', style: TextStyle(color: AppColors.textMuted)),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        context.read<TradeBloc>().add(const LoadTradesEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: trades.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, idx) {
          final trade = trades[idx];
          final isProfit = trade.isProfit;

          return NinjaCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            Formatters.prettySymbol(trade.instrument),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          DirBadge(direction: trade.direction),
                          const SizedBox(width: 6),
                          StatusBadge(status: trade.status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'In: ${Formatters.formatPrice(trade.entryPrice)} → Out: ${Formatters.formatPrice(trade.exitPrice ?? trade.currentPrice)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      if (trade.closedAt != null)
                        Text(
                          Formatters.formatICT(trade.closedAt),
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatMoney(trade.pnlUsd),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isProfit ? AppColors.profit : AppColors.loss,
                      ),
                    ),
                    Text(
                      '${trade.pnlR >= 0 ? "+" : ""}${trade.pnlR.toStringAsFixed(2)}R',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isProfit ? AppColors.profit : AppColors.loss,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  final String label;
  final String value;

  const _TradeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
