import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/notifications/models/app_notification.dart';
import '../../features/notifications/models/reminder.dart';
import '../../features/documents/models/document_attachment.dart';
import '../../features/settings/models/app_settings.dart';
import '../../features/businesses/models/business.dart';
import '../../features/transactions/models/transaction.dart';

/// Provider that exposes the Isar database instance.
/// This must be overridden in the ProviderScope at application startup.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar database provider has not been initialized');
});

/// Service class responsible for initializing the Isar database.
abstract class IsarDatabase {
  /// Initializes the local Isar database.
  /// Locates the application's documents directory and opens the Isar instance
  /// with the required schemas.
  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    
    return Isar.open(
      [
        AppSettingsSchema,
        BusinessSchema,
        TransactionSchema,
        DocumentAttachmentSchema,
        AppNotificationSchema,
        ReminderSchema,
      ],
      directory: dir.path,
      name: 'investtrack_db',
    );
  }
}
