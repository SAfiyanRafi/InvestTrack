import 'package:intl/intl.dart';

/// Centralized currency configuration for the whole app.
class CurrencyConfig {
  const CurrencyConfig({
    required this.symbol,
    required this.locale,
    required this.decimalDigits,
    required this.compactDecimalDigits,
  });

  final String symbol;
  final String locale;
  final int decimalDigits;
  final int compactDecimalDigits;

  static const CurrencyConfig defaultConfig = CurrencyConfig(
    symbol: 'Rs. ',
    locale: 'en_PK',
    decimalDigits: 2,
    compactDecimalDigits: 1,
  );
}

/// Shared formatter helpers for all monetary presentation.
class CurrencyFormatter {
  static String formatCurrency(
    num value, {
    int? decimalDigits,
    CurrencyConfig config = CurrencyConfig.defaultConfig,
  }) {
    return NumberFormat.currency(
      locale: config.locale,
      symbol: config.symbol,
      decimalDigits: decimalDigits ?? config.decimalDigits,
    ).format(value);
  }

  static String formatSignedCurrency(
    num value, {
    int? decimalDigits,
    CurrencyConfig config = CurrencyConfig.defaultConfig,
  }) {
    final sign = value >= 0 ? '+' : '-';
    return '$sign${formatCurrency(value.abs(), decimalDigits: decimalDigits, config: config)}';
  }

  static String formatCompactCurrency(
    num value, {
    int? decimalDigits,
    bool signed = false,
    CurrencyConfig config = CurrencyConfig.defaultConfig,
  }) {
    final formatted = NumberFormat.compactCurrency(
      locale: config.locale,
      symbol: config.symbol,
      decimalDigits: decimalDigits ?? config.compactDecimalDigits,
    ).format(value.abs());

    if (!signed) return formatted;
    final sign = value >= 0 ? '+' : '-';
    return '$sign$formatted';
  }
}