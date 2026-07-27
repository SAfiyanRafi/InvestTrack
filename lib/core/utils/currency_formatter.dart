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
  static CurrencyConfig currentConfig = CurrencyConfig.defaultConfig;

  static void updateCurrency(String currency) {
    currentConfig = _configForCurrency(currency);
  }

  static CurrencyConfig _configForCurrency(String currency) {
    switch (currency) {
      case 'USD':
        return const CurrencyConfig(
          symbol: '\$',
          locale: 'en_US',
          decimalDigits: 2,
          compactDecimalDigits: 1,
        );
      case 'EUR':
        return const CurrencyConfig(
          symbol: '€',
          locale: 'en_IE',
          decimalDigits: 2,
          compactDecimalDigits: 1,
        );
      case 'GBP':
        return const CurrencyConfig(
          symbol: '£',
          locale: 'en_GB',
          decimalDigits: 2,
          compactDecimalDigits: 1,
        );
      case 'AED':
        return const CurrencyConfig(
          symbol: 'د.إ ',
          locale: 'en_AE',
          decimalDigits: 2,
          compactDecimalDigits: 1,
        );
      case 'PKR':
      default:
        return const CurrencyConfig(
          symbol: 'Rs. ',
          locale: 'en_PK',
          decimalDigits: 2,
          compactDecimalDigits: 1,
        );
    }
  }

  static String formatCurrency(
    num value, {
    int? decimalDigits,
    CurrencyConfig? config,
  }) {
    final effectiveConfig = config ?? currentConfig;
    return NumberFormat.currency(
      locale: effectiveConfig.locale,
      symbol: effectiveConfig.symbol,
      decimalDigits: decimalDigits ?? effectiveConfig.decimalDigits,
    ).format(value);
  }

  static String formatSignedCurrency(
    num value, {
    int? decimalDigits,
    CurrencyConfig? config,
  }) {
    final sign = value >= 0 ? '+' : '-';
    return '$sign${formatCurrency(value.abs(), decimalDigits: decimalDigits, config: config)}';
  }

  static String formatCompactCurrency(
    num value, {
    int? decimalDigits,
    bool signed = false,
    CurrencyConfig? config,
  }) {
    final effectiveConfig = config ?? currentConfig;
    final formatted = NumberFormat.compactCurrency(
      locale: effectiveConfig.locale,
      symbol: effectiveConfig.symbol,
      decimalDigits: decimalDigits ?? effectiveConfig.compactDecimalDigits,
    ).format(value.abs());

    if (!signed) return formatted;
    final sign = value >= 0 ? '+' : '-';
    return '$sign$formatted';
  }
}
