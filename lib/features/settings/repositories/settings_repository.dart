import '../models/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getDefaultSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<List<AppSettings>> getAllSettings();
}
