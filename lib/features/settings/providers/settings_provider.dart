import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/app_settings.dart';
import '../repositories/isar_settings_repository.dart';
import '../repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarSettingsRepository(isar);
});

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getDefaultSettings();
  }

  Future<void> updateThemeMode(String mode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final current = state.value;
    if (current == null) return;

    final updated = AppSettings()
      ..id = current.id
      ..key = current.key
      ..themeMode = mode
      ..currency = current.currency
      ..isPinLockEnabled = current.isPinLockEnabled
      ..pinHash = current.pinHash
      ..isBiometricEnabled = current.isBiometricEnabled;

    state = AsyncData(updated);
    try {
      await repository.saveSettings(updated);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateCurrency(String currency) async {
    final repository = ref.read(settingsRepositoryProvider);
    final current = state.value;
    if (current == null) return;

    final updated = AppSettings()
      ..id = current.id
      ..key = current.key
      ..themeMode = current.themeMode
      ..currency = currency
      ..isPinLockEnabled = current.isPinLockEnabled
      ..pinHash = current.pinHash
      ..isBiometricEnabled = current.isBiometricEnabled;

    await repository.saveSettings(updated);
    CurrencyFormatter.updateCurrency(currency);
    state = AsyncData(updated);
  }
}

final appSettingsNotifierProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(
      AppSettingsNotifier.new,
    );
