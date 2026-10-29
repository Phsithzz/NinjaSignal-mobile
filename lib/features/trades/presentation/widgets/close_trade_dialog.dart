import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/trade_entity.dart';

class CloseTradeDialog extends StatefulWidget {
  final Trade trade;
  final Function(double exitPrice, double? pnlUsd, String? note) onConfirm;

  const CloseTradeDialog({
    super.key,
    required this.trade,
    required this.onConfirm,
  });

  @override
  State<CloseTradeDialog> createState() => _CloseTradeDialogState();
}

class _CloseTradeDialogState extends State<CloseTradeDialog> {
  late final TextEditingController _exitPriceController;
  final _pnlController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Default exit price to current market price
    _exitPriceController = TextEditingController(
      text: widget.trade.currentPrice.toString(),
    );
  }

  @override
  void dispose() {
    _exitPriceController.dispose();
    _pnlController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardElevated,
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            'Close ${Formatters.prettySymbol(widget.trade.instrument)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Record manual trade closure from your broker / MT5:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Exit Price (Required)
              TextFormField(
                controller: _exitPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Exit Price (Required)',
                  hintText: 'e.g. 2684.50',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Exit price is required';
                  final numVal = double.tryParse(val.trim());
                  if (numVal == null || numVal <= 0) return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Actual MT5 P&L USD (Optional)
              TextFormField(
                controller: _pnlController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Actual MT5 P&L (\$, Optional)',
                  hintText: 'e.g. 25.50 or -5.00',
                ),
              ),
              const SizedBox(height: 12),

              // Note (Optional)
              TextFormField(
                controller: _noteController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'e.g. Closed before NFP news release',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final exitPrice = double.parse(_exitPriceController.text.trim());
              final pnlUsd = double.tryParse(_pnlController.text.trim());
              final note = _noteController.text.trim();

              widget.onConfirm(exitPrice, pnlUsd, note.isEmpty ? null : note);
              Navigator.pop(context);
            }
          },
          child: const Text('Confirm Close'),
        ),
      ],
    );
  }
}
