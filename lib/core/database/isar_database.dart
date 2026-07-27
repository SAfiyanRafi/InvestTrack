import 'dart:io';

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
  /// Tries the application documents directory first and falls back to a
  /// temporary directory if the primary location is unavailable.
  static Future<Isar> init() async {
    final candidateDirectories = <Directory>[];

    try {
      final dir = await getApplicationDocumentsDirectory();
      candidateDirectories.add(dir);
    } catch (_) {
      // Ignore and fall back to a temporary directory.
    }

    try {
      final tempDir = await Directory.systemTemp.createTemp('investtrack_');
      candidateDirectories.add(tempDir);
    } catch (_) {
      // If even the temp directory cannot be created, the next open attempt will fail.
    }

    Object? lastError;
    for (final dir in candidateDirectories) {
      try {
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
      } catch (error) {
        lastError = error;
      }
    }

    throw StateError(
      'Unable to initialize Isar database. Last error: $lastError',
    );
  }
}
