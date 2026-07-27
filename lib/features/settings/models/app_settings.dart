import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String key = 'default';

  String themeMode = 'system'; // 'light', 'dark', 'system'

  String currency = 'PKR';

  bool isPinLockEnabled = false;

  String? pinHash;

  bool isBiometricEnabled = false;
}
