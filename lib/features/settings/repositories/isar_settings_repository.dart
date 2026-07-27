import 'package:isar/isar.dart';

import 'package:investtrack/core/database/isar_database.dart';
import 'package:investtrack/features/settings/models/app_settings.dart';
import 'package:investtrack/features/settings/repositories/settings_repository.dart';

class IsarSettingsRepository implements SettingsRepository {
  IsarSettingsRepository(this._isar);

  final Isar _isar;

  @override
  Future<AppSettings> getDefaultSettings() async {
    final existing = await _isar.appSettings.getByKey('default');
    if (existing != null) {
      return existing;
    }

    final defaultSettings = AppSettings();
    defaultSettings.key = 'default';

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(defaultSettings);
    });

    return defaultSettings;
  }

  @override
  Future<List<AppSettings>> getAllSettings() async {
    return _isar.appSettings.where().findAll();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
  }
}
