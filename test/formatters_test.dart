import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/formatters.dart';

void main() {
  group('Formatters Tests', () {
    test('prettySymbol converts underscores to slashes', () {
      expect(Formatters.prettySymbol('XAU_USD'), 'XAU/USD');
      expect(Formatters.prettySymbol('EUR_USD'), 'EUR/USD');
      expect(Formatters.prettySymbol('BTC_USDT'), 'BTC/USDT');
      expect(Formatters.prettySymbol(''), '—');
      expect(Formatters.prettySymbol(null), '—');
    });

    test('formatPrice correctly formats based on magnitude', () {
      // >= 1000 (BTC, Gold)
      expect(Formatters.formatPrice(2685.45), '2,685.45');
      expect(Formatters.formatPrice(68450.2), '68,450.20');

      // >= 100 (JPY pairs)
      expect(Formatters.formatPrice(198.423), '198.42');

      // >= 1 (Forex standard pairs)
      expect(Formatters.formatPrice(1.08453), '1.0845');

      // < 1
      expect(Formatters.formatPrice(0.654321), '0.65432');

      // null
      expect(Formatters.formatPrice(null), '—');
    });

    test('formatMoney adds correct signs and precision', () {
      expect(Formatters.formatMoney(25.5), '+\$25.50');
      expect(Formatters.formatMoney(-14.2), '-\$14.20');
      expect(Formatters.formatMoney(0), '+\$0.00');
      expect(Formatters.formatMoney(null), '—');
    });

    test('formatPct formats percentage correctly', () {
      expect(Formatters.formatPct(0.45), '+0.45%');
      expect(Formatters.formatPct(-1.2), '-1.20%');
      expect(Formatters.formatPct(75.5, withSign: false), '75.50%');
      expect(Formatters.formatPct(null), '—');
    });

    test('formatICT converts to UTC+7 ICT time', () {
      final utcTime = DateTime.utc(2026, 10, 29, 4, 30); // 04:30 UTC = 11:30 ICT
      final formatted = Formatters.formatICT(utcTime, withDate: false);
      expect(formatted, '11:30 ICT');
    });
  });
}
