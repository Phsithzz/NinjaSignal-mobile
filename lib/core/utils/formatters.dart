import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// "XAU_USD" -> "XAU/USD"
  static String prettySymbol(String? symbol) {
    if (symbol == null || symbol.isEmpty) return '—';
    return symbol.replaceAll('_', '/');
  }

  /// Price formatting matching NinjaSignal web logic based on magnitude
  static String formatPrice(num? value) {
    if (value == null) return '—';
    final abs = value.abs();
    if (abs >= 1000) {
      final formatter = NumberFormat('#,##0.00');
      return formatter.format(value);
    }
    if (abs >= 100) {
      return value.toStringAsFixed(2);
    }
    if (abs >= 1) {
      return value.toStringAsFixed(4);
    }
    return value.toStringAsFixed(5);
  }

  /// Format money: +$14.20 or -$3.50
  static String formatMoney(num? value) {
    if (value == null) return '—';
    final sign = value >= 0 ? '+\$' : '-\$';
    return '$sign${value.abs().toStringAsFixed(2)}';
  }

  /// Format pips: +12.4 or -5.1
  static String formatPips(num? value) {
    if (value == null) return '—';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)}';
  }

  /// Format percentage: +0.45% or -1.20%
  static String formatPct(num? value, {bool withSign = true}) {
    if (value == null) return '—';
    final sign = withSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Render timestamp in ICT (UTC+7)
  static String formatICT(dynamic dateTimeOrIso, {bool withDate = true}) {
    if (dateTimeOrIso == null) return '—';
    DateTime dt;
    if (dateTimeOrIso is DateTime) {
      dt = dateTimeOrIso;
    } else if (dateTimeOrIso is String) {
      final parsed = DateTime.tryParse(dateTimeOrIso);
      if (parsed == null) return dateTimeOrIso;
      dt = parsed;
    } else {
      return '—';
    }

    // Convert to ICT (UTC+7)
    final ict = dt.toUtc().add(const Duration(hours: 7));
    if (withDate) {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(ict)} ICT';
    }
    return '${DateFormat('HH:mm').format(ict)} ICT';
  }

  /// "12s ago", "3m ago", "2h ago"
  static String formatRelativeTime(dynamic dateTimeOrIso) {
    if (dateTimeOrIso == null) return '';
    DateTime dt;
    if (dateTimeOrIso is DateTime) {
      dt = dateTimeOrIso;
    } else if (dateTimeOrIso is String) {
      final parsed = DateTime.tryParse(dateTimeOrIso);
      if (parsed == null) return '';
      dt = parsed;
    } else {
      return '';
    }

    final diff = DateTime.now().toUtc().difference(dt.toUtc());
    final seconds = diff.inSeconds;
    if (seconds < 60) return '${seconds < 0 ? 0 : seconds}s ago';
    final minutes = diff.inMinutes;
    if (minutes < 60) return '${minutes}m ago';
    final hours = diff.inHours;
    if (hours < 24) return '${hours}h ago';
    return '${diff.inDays}d ago';
  }
}
