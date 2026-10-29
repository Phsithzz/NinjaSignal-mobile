import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/signals/data/models/signal_model.dart';
import 'package:mobile/features/trades/data/models/trade_model.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

void main() {
  group('Models Serialization Tests', () {
    test('UserModel fromJson deserializes correctly', () {
      final json = {
        'id': 1,
        'email': 'admin@ninjasignal.com',
        'name': 'Ninja Trader',
        'role': 'admin',
        'is_active': true,
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 1);
      expect(user.email, 'admin@ninjasignal.com');
      expect(user.name, 'Ninja Trader');
      expect(user.isAdmin, true);
    });

    test('TradeSignalModel fromJson deserializes correctly', () {
      final json = {
        'id': 101,
        'instrument': 'XAU_USD',
        'direction': 'buy',
        'entry': 2685.5,
        'sl': 2675.0,
        'tp': 2700.0,
        'rr': 2.0,
        'confidence': 'high',
        'status': 'active',
        'rules_triggered': ['EMA 20/50 Cross'],
        'time': '2026-10-29T04:30:00Z',
      };

      final signal = TradeSignalModel.fromJson(json);
      expect(signal.instrument, 'XAU_USD');
      expect(signal.isBuy, true);
      expect(signal.confidence, 'high');
      expect(signal.rulesTriggered.length, 1);
    });

    test('TradeModel fromJson deserializes correctly', () {
      final json = {
        'id': 201,
        'instrument': 'GBP_JPY',
        'direction': 'sell',
        'entry_price': 198.5,
        'sl': 199.0,
        'tp': 197.5,
        'current_price': 198.0,
        'lot_size': 0.01,
        'pnl_usd': 32.5,
        'pnl_r': 1.0,
        'status': 'open',
        'opened_at': '2026-10-29T04:00:00Z',
        'exit_mode': 'scale_out',
      };

      final trade = TradeModel.fromJson(json);
      expect(trade.instrument, 'GBP_JPY');
      expect(trade.isOpen, true);
      expect(trade.isProfit, true);
      expect(trade.pnlUsd, 32.5);
    });
  });
}
